require 'issues_patch'

Redmine::Plugin.register :recurring_tasks do
  name 'Recurring Tasks'
  author 'Teresa N.'
  author_url 'https://github.com/nutso/'
  url 'https://github.com/nutso/redmine-plugin-recurring-tasks'
  description 'Allows you to set a task to recur on a regular schedule, or when marked complete, regenerate a new task due in the future. Plugin is based -- very loosely -- on the periodic tasks plugin published by Tanguy de Courson'
  version '1.0.2'
  
  menu :top_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => 'Recurring Tasks'
  
  # TODO project-specific recurring tasks view (#11)
  # menu :project_menu, :periodic_tasks, { :controller => 'periodic_tasks', :action => 'index' }, :caption => 'Periodic Task', :after => :settings, :param => :project_id
  
  # TODO better permissions (#12)
  # This doesn't seem to do the trick
  # Modeled after #{redmine root}/lib/redmine.rb permissions setup
  project_module :issue_tracking do
    permission :view_issues,   {:recurring_tasks => [:index, :show]}, :read => true
    permission :add_issues,    {:recurring_tasks => [:new, :create]}
    permission :edit_issues,   {:recurring_tasks => [:edit, :update]}
    permission :delete_issues, {:recurring_tasks => [:destroy]}, :require => :member
  end
  
  #  project_module :recurring_tasks do
  #    permission :recurring_tasks, {:recurring_tasks => [:index, :edit]}
  #  end


  # Send patches to models and controllers
  Rails.configuration.to_prepare do
    Issue.send(:include, RecurringTasks::IssuePatch)
  end
end