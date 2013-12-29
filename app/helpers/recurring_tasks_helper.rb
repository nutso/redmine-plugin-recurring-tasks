module RecurringTasksHelper
  def show_error msg
    logger.error msg
    render_error :message => msg    
  end
  
  def delete_button recurring_task
    if User.current.allowed_to?(:delete_issue_recurrence, recurring_task.project)
      button_to(l(:button_delete), {:action => 'destroy', :id => recurring_task, :project_id => recurring_task.project.id}, :method => :delete, :class => 'icon icon-del', :confirm => l(:text_are_you_sure))
    end
  end
  
  def edit_button recurring_task
    if User.current.allowed_to?(:edit_issue_recurrence, recurring_task.project)
      link_to(l(:button_edit), {:action => 'edit', :id => recurring_task, :project_id => recurring_task.project.id}, :class => 'icon icon-edit')
    end
  end
end
