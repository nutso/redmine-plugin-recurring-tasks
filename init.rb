require 'issues_patch'

Redmine::Plugin.register :recurring_tasks do
  name 'Recurring Tasks (Issues)'
  author 'Teresa N.'
  author_url 'https://github.com/nutso/'
  url 'https://github.com/nutso/redmine-plugin-recurring-tasks'
  description 'Allows you to set a task to recur on a regular schedule, or when marked complete, regenerate a new task due in the future. Plugin is based -- very loosely -- on the periodic tasks plugin published by Tanguy de Courson'
  version '1.0.3'
  
  Redmine::MenuManager.map :top_menu do |menu|
    menu.push :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => 'Recurring Issues', :if => Proc.new { User.current.admin? } # TODO localize string
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
  menu :project_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => 'Recurring Issues', :after => :new_issue, :param => :project_id # TODO localize string
  
  # Send patches to models and controllers
  Rails.configuration.to_prepare do
    Issue.send(:include, RecurringTasks::IssuePatch)
  end
end