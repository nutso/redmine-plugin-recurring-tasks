module RecurringTasksHelper
  def show_error msg
    logger.error msg
    render_error :message => msg    
  end
  
  def delete_button recurring_task, project
    if User.current.allowed_to?(:delete_issue_recurrence, project)
      button_to(l(:button_delete), {:action => 'destroy', :id => recurring_task}, :method => :delete, :class => 'icon icon-del', :confirm => l(:text_are_you_sure))
    end
  end
end
