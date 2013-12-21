redmine-plugin-recurring-tasks
==============================

Plugin for Redmine project management software to configure recurring tasks. Any task can be set to recur on a fixed (e.g. every Monday) or flexible (e.g. 2 days after task was last completed) schedule.

Released under GPLv2 in accordance with Redmine licensing.

Installation

1. Follow standard Redmine plugin installation (http://www.redmine.org/projects/redmine/wiki/Plugins)
2. Set the check for recurrence via Crontab.
   Crontab example (running the check for recurrence every 6 hours):
   ```bash
   * */4 * * * cd {path_to_redmine} && rake RAILS_ENV=production redmine:recur_tasks >> log/cron_rake.log 2>&1
   ```