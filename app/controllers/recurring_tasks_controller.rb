class RecurringTasksController < ApplicationController
  include RecurringTasksHelper
  unloadable

  # before_filter :authorize, :except => :index # not sure why index is excluded, but this is true for issues ...
  before_filter :find_optional_project # this also checks permissions
  before_filter :find_recurring_task, :except => [:index, :new, :create]
  before_filter :set_interval_units, :except => [:index, :show]
  before_filter :set_recurrable_issues, :except => [:index, :show]
  before_filter :cancel_edit, :only => [:new, :create, :edit, :update] # #41 TODO is this necessary?


  def index
    @recurring_tasks = RecurringTask.all_for_project(@project)
  end

  def show
    # default behavior is fine
  end

  def new
    @recurring_task = RecurringTask.new
    
    if params[:issue_id]
      @recurring_task.issue = Issue.find(params[:issue_id])
    end
  end

  # creates a new recurring task
  def create    
    # params[:recurring_task][:interval_unit] = RecurringTask.get_interval_from_localized_name(params[:recurring_task][:interval_localized_name]) #41
    @recurring_task = RecurringTask.new(params[:recurring_task])
    if @recurring_task.save
      flash[:notice] = l(:recurring_task_created)
      # redirect_to :action => :show, :id => @recurring_task.id #41
      redirect_to :controller => :issues, :action => :show, :id => @recurring_task.issue.id #41
    else
      logger.debug "Could not create recurring task from #{params[:post]}"
      render :new # errors are displayed to user on form
    end
  end

  def edit
    # default behavior is fine
  end
  
  def cancel_edit # #41 TODO is this necessary?
    if params[:commit] == l(:button_cancel)
      redirect_to :back
    end
  rescue ActionController::RedirectBackError
    redirect_to default
  end


  # saves the task and redirects to show
  def update
    logger.info "Updating recurring task #{params[:id]}"
  
    # params[:recurring_task][:interval_unit] = RecurringTask.get_interval_from_localized_name(params[:recurring_task][:interval_localized_name]) #41
    if @recurring_task.update_attributes(params[:recurring_task])
      flash[:notice] = l(:recurring_task_saved)
      # redirect_to :action => :show #41
      redirect_to :controller => :issues, :action => :show, :id => @recurring_task.issue.id # #41
    else
      logger.debug "Could not save recurring task #{@recurring_task}"
      render :edit # errors are displayed to user on form
    end
  end

  def destroy
    logger.info "Destroying recurring task #{params[:id]}"
  
    if @recurring_task.destroy
      flash[:notice] = l(:recurring_task_removed)
      # redirect_to :action => :index #41
      redirect_to :back #41
    else
      flash[:notice] = l(:error_recurring_task_could_not_remove)
      # redirect_to :action => :show, :id => @recurring_task #41
      render :back #41
    end
  end
  
private
  def set_recurrable_issues
    if @project
      @recurrable_issues = @project.issues
    else 
      @recurrable_issues = Issue.all
    end
  end

  def find_recurring_task
    begin
      @recurring_task = RecurringTask.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      show_error "#{l(:error_recurring_task_not_found)} #{params[:id]}"
    end
  end
  
  def set_interval_units
    # @interval_units = RecurringTask::INTERVAL_UNITS_LOCALIZED #41
    @interval_units = RecurringTask::INTERVAL_UNITS_LOCALIZED.collect{|k,v| [v, k]} #41
  end
end
