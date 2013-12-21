module RecurringTasksHelper
  def show_error msg
    logger.error msg
    render_error :message => msg    
  end
end
