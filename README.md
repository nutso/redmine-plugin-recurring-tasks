redmine-plugin-recurring-tasks
==============================

Plugin for Redmine project management software to configure recurring tasks

Crontab example (running the check for recurrence every 6 hours):
```bash
* */4 * * * cd {path_to_redmine} && rake RAILS_ENV=production redmine:recur_tasks >> log/cron_rake.log 2>&1
```

Steps taken to generate the plugin
```bash
ruby script/rails generate redmine_plugin recurring_tasks
ruby script/rails generate redmine_plugin_model recurring_tasks RecurringTask current_issue_id:integer, fixed_schedule:boolean, interval_number:integer, interval_unit:string
ruby script/rails generate redmine_plugin_controller RecurringTasks recurring_tasks index show new create edit update destroy
```