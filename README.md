# redmine-plugin-recurring-tasks

Plugin for Redmine project management software to configure recurring tasks. Any task can be set to recur on a fixed (e.g. every Monday) or flexible (e.g. 2 days after task was last completed) schedule.

Released under GPLv2 in accordance with Redmine licensing.

## Installation

Follow standard Redmine plugin installation -- (barely) modified from http://www.redmine.org/projects/redmine/wiki/Plugins

1. Copy or clone the plugin directory into #{RAILS_ROOT}/plugins/recurring_tasks
   e.g. git clone https://github.com/teresan/redmine-plugin-recurring-tasks recurring_tasks
2. Rake the database migration (make a db backup before)
   e.g. rake redmine:plugins:migrate RAILS_ENV=production
3. Restart Redmine (or web server)

You should now be able to see the plugin list in Administration -> Plugins.
     
## Configuration
     
1. Set the check for recurrence via Crontab.
   Crontab example (running the check for recurrence every 6 hours):
   ```bash
   * */4 * * * cd {path_to_redmine} && rake RAILS_ENV=production redmine:recur_tasks >> log/cron_rake.log 2>&1
   ```
   
## Upgrade or Migrate Plugin

Please check the Release Notes (ReleaseNotes.md) for substantive or breaking changes.

### Option 1: Git Pull
1. If you installed via git clone, you can just change to the recurring_tasks directory and do a git pull to get the update
2. Run database migrations (make a db backup before)
   rake redmine:plugins:migrate RAILS_ENV=production
3. Restart Redmine (or web server)

### Option 2: Remove and Re-install Plugin
1. Follow Remove or Uninstall Plugin instructions below
2. Follow Installation instructions above
   
## Remove or Uninstall Plugin

Follow standard Redmine plugin un-installation -- (barely) modified from http://www.redmine.org/projects/redmine/wiki/Plugins
1. Downgrade the database (make a db backup before)
   rake redmine:plugins:migrate NAME=recurring_tasks VERSION=0 RAILS_ENV=production
2. Remove the plugin from the plugins folder (#{RAILS_ROOT}/plugins)
3. Restart Redmine (or web server)