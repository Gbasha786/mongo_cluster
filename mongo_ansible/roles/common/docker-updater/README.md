Docker-updater deployment and configuration
If you want to deploy docker-updater, but not to run it, use
```yaml
   - { role: common/docker-updater, run: false }
``` 

Option `disable_file` controls whether to create '/var/docker-updater-disable' file or not.
File '/var/docker-updater-disable' is removed before docker-updater execution if `run: true`, and is recreated after if `disable_file: true`.
