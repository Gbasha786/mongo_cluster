#!/usr/bin/env bash

compose=`which docker-compose`" "

include () {
    [[ -f "$1" ]] && source "$1"
}

LOG_TAG="docker-updater"
COMPOSE_FILES="/etc/docker-compose/*.yml"

for i in $( ls -1 $COMPOSE_FILES ); do
    compose+=( -f "${i}" )
done


if [[ -e /var/docker-updater-disable ]]; then
    logger -s -p debug -t $LOG_TAG "/var/docker-updater-disable presents, aborting"
    exit 0
fi


LOCK_FILE="/tmp/.docker-updater.lock"

(

if ! flock -xn 42; then
    logger -s -p alert -t $LOG_TAG "Can't lock \"$LOCK_FILE\", other instance of docker-updater is being performed"
    exit 1
fi

logfile=$( mktemp /tmp/docker-updater.XXXXXXX )

if [ -d /opt/docker-updater/env.d ]; then
    for file in /opt/docker-updater/env.d/*; do
        include $file
    done
else
    logger -s -p warning -t $LOG_TAG "/opt/docker-updater/env.d not present"
fi

# DEPRECATED: Do not use this, support is going away soon.
include /opt/docker-updater/pre_template_instantiation
# TEMPLATES NO LONGER SUPPORTED
for file in $( ls -1 $COMPOSE_FILES ); do
    if head -1 $file | grep '^#docker-compose-template' >/dev/null; then
        echo "docker-compose-template files are no longer supported. Use ansible templates."
        exit 1
    fi
done

include /opt/docker-updater/pre

# make sure we always have the latest image
if [[ $1 = 'run' ]]; then
    echo "skipping pull state"
else
    include /opt/docker-updater/pre_pull
    if ${compose} pull --help | grep -q parallel && ( [[ $1 = 'pull' ]] || [ -z ${monit_healthcheck+x} ] ); then
        PARALLEL="--parallel"
    else
        PARALLEL=""
    fi
    ${compose[@]} pull ${PARALLEL} > $logfile 2>&1
    if [ $? -ne 0 ]; then
        echo 'Error while pulling containers!'
        cat $logfile
        exit 1
    fi
fi

# start it all up
if [[ $1 = 'pull' ]]; then
    echo "skipping up state"
else
    pull_count=$( grep -c -E "^Status: Downloaded" $logfile )
    if [ $pull_count -gt 0 ] && [ ! -z ${monit_healthcheck+x} ]; then
        echo -n "$pull_count updates detected, removing this node from a load balancer"
        if [ -f /var/allow_users ]; then
            mv /var/allow_users{,_disabled}
            counter=0
            while [ "$( curl -s -o /dev/null -w "%{http_code}" http://127.0.0.1:58080/healthy.html)" == 200 ] && [ $counter -lt 120 ]; do
                sleep 1
                echo -n .
            done
            sleep 10
            echo .
            echo 'Now node is removed from LB'
        else
            echo '/var/allow_users not present, not removing node from a load balancer'
        fi
        [ -f /usr/bin/monit ] && /bin/systemctl stop monit.service
    fi

    include /opt/docker-updater/pre_up

    ${compose[@]} up -d --remove-orphans || exit 1

    include /opt/docker-updater/post_up
fi


# images cleanup
if [[ $(docker images -q --filter "dangling=true") ]]; then
    docker rmi $(docker images -q --filter "dangling=true")
fi


if [ -f /var/allow_users_disabled ]; then
    echo "Adding this node back to a load balancer"
    mv /var/allow_users{_disabled,}
fi

[ -f /usr/local/bin/docker-pid ] && /usr/local/bin/docker-pid
[ -f /usr/bin/monit ] && /bin/systemctl start monit.service

if [ -f $logfile ]; then
    rm -f $logfile
fi

) 42>$LOCK_FILE
