# redmine-plugin-recurring-tasks

Plugin for Redmine project management software to configure recurring tasks. The plugin creates a new issue in Redmine for each recurrence, linking the duplicated issue as a related issue.

Released under GPLv2 in accordance with Redmine licensing.

## Features

* Any Redmine issue can have one or more associated recurrence schedules.
* Supported recurrence schedules are:
  * Every x days/weeks/months/years, e.g. every 1 day or every 3 months
  * The nth day of every x months, e.g. the 3rd of every month
  * The nth-to-last day of every x months, e.g. the 5th-to-last day of every 4 months
  * The nth week day of every x months, e.g. the 3rd Thursday of every 2 months
  * The nth-to-last week day of every x months, e.g. the 2nd-to-last Saturday of every 1 month
* All recurrence schedules can be set to recur on a fixed or flexible schedule.
  * Fixed: recurs whether the previous task completed or not
  * Flexible: recurs only if the previous task was complete
* View/Add/Edit/Delete issue recurrence permissions controlled via Redmine's native Roles and Permissions menu

Note: recurrences depend on the date of the issue that is recurring (e.g. if you want it 
to recur every 2nd Thursday of the month, the issue's first date should be a Thursday)

## Installation

Follow standard Redmine plugin installation -- (barely) modified from http://www.redmine.org/projects/redmine/wiki/Plugins

1. Copy or clone the plugin directory into #{RAILS_ROOT}/plugins/recurring_tasks -- note the folder name 'recurring_tasks' must be verbatim.
   
   e.g. git clone https://github.com/nutso/redmine-plugin-recurring-tasks.git recurring_tasks
   
   NOTE! This particular clone will tie you to the master branch, which is not recommended for production systems (faster updates and features but less well-tested). Recommend using a specific version of the plugin which will provide a more stable baseline. 

2. Rake the database migration (make a db backup before)

   e.g. bundle exec rake redmine:plugins:migrate RAILS_ENV=production

3. Restart Redmine (or web server)

You should now be able to see the plugin list in Administration -> Plugins.
     
## Configuration
     
1. Set the check for recurrence via Crontab or similar.

   "Pure" crontab example (running the check for recurrence every 6 hours on the 15s) -- replace {path_to_redmine} with your actual path, e.g. /var/www/redmine:
   ```bash
   15 */4 * * * /bin/sh "cd {path_to_redmine} && bundle exec rake RAILS_ENV=production redmine:recur_tasks" >> log/cron_rake.log 2>&1
   ```
   
   You can also use e.g. cron.daily or cron.hourly to avoid having to figure out the precise cron syntax for the schedule; Ruby gems Rufus Scheduler and Whenever can also be used; the key point is that something needs to call recur_tasks on a regular basis.

   More information on Rufus Scheduler config at [#72](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/72)
   
2. Decide which role(s) should have the ability to view/add/edit/delete issue recurrence and configure accordingly in Redmine's permission manager (Administration > Roles and Permissions) 
   * View issue recurrence
   * Add issue recurrence
   * Edit issue recurrence
   * Delete issue recurrence (additionally requires the user to be a project member or administrator) 

3. Within the Administration/Plugins/Recurring Tasks configuration page in Redmine, you have the following global configuration options:
   * _Attribute issue journals to user id (optional)_<br />
     If blank, no journal notes will be added on recurrence; otherwise, this should be the numeric Redmine user id to which all recurring
     journal entries will be tied to. This can be helpful if you want to create a placeholder user account and see all recurrence history within Redmine.
   * _Display top menu?_<br />
     Defaults to yes for historical purposes; whether (for Redmine administrators) and Recurring tasks menu option should be displayed on the top menu.
   * _Reopen issue on recurrence?_<br />
     Defaults to no for historical purposes; whether to re-open an issue (yes) or clone to a new issue (no) when the issue is due to recur

## Upgrade or Migrate Plugin

Please check the Release Notes (ReleaseNotes.md) for substantive or breaking changes.

### Option 1: Git Pull
1. If you installed via git clone, you can just change to 
   the recurring_tasks directory and do a git pull to get the update

2. Run database migrations (make a db backup before)

   bundle exec rake redmine:plugins:migrate RAILS_ENV=production

3. Restart Redmine (or web server)

### Option 2: Remove and Re-install Plugin
1. Follow Remove or Uninstall Plugin instructions below
2. Follow Installation instructions above
   
## Remove or Uninstall Plugin

Follow standard Redmine plugin un-installation -- (barely) modified from http://www.redmine.org/projects/redmine/wiki/Plugins

1. Downgrade the database (make a db backup before)

   bundle exec rake redmine:plugins:migrate NAME=recurring_tasks VERSION=0 RAILS_ENV=production

2. Remove the plugin from the plugins folder (#{RAILS_ROOT}/plugins)

3. Restart Redmine (or web server)

## Running the tests

1. Copy Redmine to `redmine/`:
   - `curl -O http://www.redmine.org/releases/redmine-3.1.1.tar.gz`
   - `tar -xf redmine-3.1.1.tar.gz`
   - `rm redmine-3.1.1.tar.gz`
   - `mv redmine-3.1.1 redmine`
2. Symlink the plugin into the plugins folder:
   - `ln -s ../.. redmine/plugins/recurring_tasks`
3. Setup a default database
   - `ln -s ../../test/database.yml redmine/config/database.yml`
   - `cd redmine`
   - `rake db:create`
   - `rake db:migrate RAILS_ENV=test`
4. Install required gems by Redmine
   - `bundle`
5. Go back to the plugin folder
   - `cd ..`
6. And run the tests
   - `rake`
