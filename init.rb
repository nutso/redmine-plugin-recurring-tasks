require 'redmine'
require 'issues_patch'

# view hooks
require_dependency 'recurring_tasks/hooks'

Redmine::Plugin.register :recurring_tasks do
  name 'Recurring Tasks (Issues)'
  author 'Teresa N.'
  author_url 'https://github.com/nutso/'
  url 'https://github.com/nutso/redmine-plugin-recurring-tasks'
  description 'Allows you to set a task to recur on a regular schedule, or when marked complete, regenerate a new task due in the future. Supports Redmine 2.x and 3.x'
  version '2.0.0-pre'
  
  # user-accessible global configuration
  settings :default => {
    'show_top_menu' => "1",
    'reopen_issue' => "0",
    'journal_attributed_to_user' => 1
  }, :partial => 'settings/recurring_tasks_settings'

  
  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => :label_recurring_tasks, :if => Proc.new { User.current.admin? && (Setting.plugin_recurring_tasks['show_top_menu'] == "1")}
  end
  
  # Permissions map to issue permissions (#12)
  # Modeled after #{redmine root}/lib/redmine.rb permissions setup
  project_module :issue_tracking do
    permission :view_issue_recurrence,   {:recurring_tasks => [:index, :show]}, :read => true
    permission :add_issue_recurrence,    {:recurring_tasks => [:new, :create]}
    permission :edit_issue_recurrence,   {:recurring_tasks => [:edit, :update]}
    permission :delete_issue_recurrence, {:recurring_tasks => [:destroy]}, :require => :member
  end
  
  # project-specific recurring tasks view (#11)
  menu :project_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => :label_recurring_tasks, :after => :new_issue, :param => :project_id
  
  # Send patches to models and controllers
  Rails.configuration.to_prepare do
    Issue.send(:include, RecurringTasks::IssuePatch)
  end
end