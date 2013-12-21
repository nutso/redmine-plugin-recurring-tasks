desc <<-END_DESC
Check for recurrence of recurring tasks

Example:
  rake redmine:recur_tasks RAILS_ENV="production"
END_DESC
require File.expand_path(File.dirname(__FILE__) + "/../../../../config/environment")

namespace :redmine do
  task :recur_tasks => :environment do
    puts "Checking for Redmine recurring tasks."
    RecurringTask.add_recurrences!
  end
end
