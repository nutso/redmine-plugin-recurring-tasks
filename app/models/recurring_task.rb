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
  
  def recur_issue_if_needed!
    recur = false
    
    # scheduled to recur
    if(fixed_schedule and (issue.due_date + recurrence_pattern) <= (Time.now.to_date + 1.day))
      recur = true
      prev_date = issue.due_date
    # marked complete, ready to recur
    else
      recur = issue.closed?
      prev_date = issue.closed_on
    end
    
    # no recurrence needed
    if(!recur)
      return true
    end

    # recurrence needed
    new_issue = issue.copy
    new_issue.due_date = prev_date + recurrence_pattern
    new_issue.start_date = new_issue.due_date
    new_issue.status = IssueStatus.default # issue status is NOT automatically new, default is whatever the default status for new issues is
    new_issue.save
    
    puts "Recurring #{issue.id}: #{issue.subj_date}, created #{new_issue.id}: #{new_issue.subj_date}"
    
    self.issue = new_issue
    save!
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
end
