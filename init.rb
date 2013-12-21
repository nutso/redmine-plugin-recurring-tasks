require 'issues_patch'

Redmine::Plugin.register :recurring_tasks do
  name 'Recurring Tasks'
  author 'Teresa N.'
  description 'Allows you to set a task to recur on a regular schedule, or when marked complete, regenerate a new task due in the future. Plugin is based -- very loosely -- on the periodic tasks plugin published by Tanguy de Courson'
  version '0.0.1'
  
  menu :top_menu, :recurring_tasks, { :controller => 'recurring_tasks', :action => 'index' }, :caption => 'Recurring Tasks'
  
  # TODO Support project-specific recurring tasks view
  # menu :project_menu, :periodic_tasks, { :controller => 'periodic_tasks', :action => 'index' }, :caption => 'Periodic Task', :after => :settings, :param => :project_id
  
  # TODO not sure we need separate permissions ... is there a way to inherit from Issue permissions?
  
  #  project_module :recurring_tasks do
  #    permission :recurring_tasks, {:recurring_tasks => [:index, :edit]}
  #  end


  # Send patches to models and controllers
  Rails.configuration.to_prepare do
    Issue.send(:include, RecurringTasks::IssuePatch)
  end
end