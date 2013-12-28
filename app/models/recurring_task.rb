class RecurringTask < ActiveRecord::Base
  unloadable

  belongs_to :issue, :foreign_key => 'current_issue_id'
  
  # must come before validations otherwise unitialized
  INTERVAL_UNITS = [l(:interval_day), l(:interval_week), l(:interval_month), l(:interval_year)]

  validates :interval_unit, presence: true, inclusion: { in: RecurringTask::INTERVAL_UNITS, message: "#{l(:error_invalid_interval)} %{value}" }
  validates :interval_number, presence: true, numericality: {only_integer: true, greater_than: 0}
  # cannot validate presence of issue if want to use other features
  # validates :issue, presence: true
  # validates :fixed_schedule # requiring presence requires true

  validates_associated :issue # just in case we build in functionality to add an issue at the same time, verify the issue is ok  
  
  # time interval value of the recurrence pattern
  def recurrence_pattern
    case interval_unit
    when l(:interval_day)
      interval_number.days
    when l(:interval_week)
      interval_number.weeks
    when l(:interval_month)
      interval_number.months
    when l(:interval_year)
      interval_number.years
    else
      logger.error "Unsupported interval unit: #{interval_unit}"
    end
  end
  
  # retrieve all recurring tasks given a project id
  def all_for_project project_id
    # TODO implement
  end
  
  # next due date for the task, if there is one (relative tasks won't have a next schedule until the current issue is closed)
  def next_scheduled_recurrence
    previous_date_for_recurrence + recurrence_pattern unless previous_date_for_recurrence.nil?
  end
  
  # whether a recurrence needs to be added
  def need_to_recur?
    if(fixed_schedule and (issue.due_date + recurrence_pattern) <= (Time.now.to_date + 1.day)) then true else issue.closed? end
  end
  
  # check whether a recurrence is needed, and add one if not
  def recur_issue_if_needed!
    return true unless need_to_recur?
    
    # Add more than one recurrence to 'catch up' if warranted (issue #10)
    
    while need_to_recur?
      new_issue = issue.copy
      new_issue.due_date = previous_date_for_recurrence + recurrence_pattern
      new_issue.start_date = new_issue.due_date
      new_issue.status = IssueStatus.default # issue status is NOT automatically new, default is whatever the default status for new issues is
      new_issue.save!
      puts "Recurring #{issue.id}: #{issue.subj_date}, created #{new_issue.id}: #{new_issue.subj_date}"
    
      self.issue = new_issue
      save!
    end
  end
  
  def to_s
    i = "No issue associated "
    if !(issue.nil?)
      i = issue.subj_date
    end
    "#{i} (#{l(:label_recurrence_pattern)} #{interval_number} #{interval_unit}s " + (:fixed_schedule ? l(:label_recurs_fixed) : l(:label_recurs_dependent)) + ")"
  end
  
  def to_s_long
    "#{to_s}. #{l(:label_belongs_to_project)} #{:issue.project}. #{l(:label_assigned_to)} #{:issue.assigned_to_id}"
  end
  
  # for each recurring task, check whether to create a new one
  def self.add_recurrences!
    RecurringTask.all.each do |task|
      task.recur_issue_if_needed!
    end # do each
  end # end add_recurrences
  
private
  # the date from which to recur
  # for a fixed schedule, this is the due date
  # for a relative schedule, this is the date closed
  def previous_date_for_recurrence
    if fixed_schedule then issue.due_date else issue.closed_on end
  end
end
