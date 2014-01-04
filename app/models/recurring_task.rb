class RecurringTask < ActiveRecord::Base
  unloadable

  belongs_to :issue, :foreign_key => 'current_issue_id'
  has_one :project, through: :issue
  
  before_validation :set_interval
  
  attr_accessible :interval_localized_name
  
  # these are the flags used in the database to denote the interval
  # the actual text displayed to the user is controlled in the language file
  INTERVAL_DAY = 'd'
  INTERVAL_WEEK = 'w'
  INTERVAL_MONTH = 'm'
  INTERVAL_YEAR = 'y'
  
  # must come before validations otherwise unitialized
  INTERVAL_UNITS_LOCALIZED = [l(:interval_day), l(:interval_week), l(:interval_month), l(:interval_year)]

  validates :interval_localized_name, presence: true, inclusion: { in: RecurringTask::INTERVAL_UNITS_LOCALIZED, message: "#{l(:error_invalid_interval)} '%{value}' (Validation)" }
  validates :interval_number, presence: true, numericality: {only_integer: true, greater_than: 0}
  # validates :issue, presence: true # cannot validate presence of issue if want to use other features
  # validates :fixed_schedule # requiring presence requires true

  validates_associated :issue # just in case we build in functionality to add an issue at the same time, verify the issue is ok  
  
  # text for the interval name
  def interval_localized_name
    case interval_unit
    when INTERVAL_DAY
      l(:interval_day)
    when INTERVAL_WEEK
      l(:interval_week)
    when INTERVAL_MONTH
      l(:interval_month)
    when INTERVAL_YEAR
      l(:interval_year)
    else
      logger.error "#{l(:error_invalid_interval)} #{interval_unit} (interval_localized_name)"
      ""
    end  
  end
  
  # interval database name for the localized text
  def interval_localized_name=(value)
    logger.info "setting localized name to #{value}"
    @interval_localized_name = value
    interval_unit = RecurringTask.get_interval_from_localized_name(value)
  end  
  
  # used for migration #2
  def self.get_interval_from_localized_name(value)
    case value
      when l(:interval_day)
        INTERVAL_DAY
      when l(:interval_week)
        INTERVAL_WEEK
      when l(:interval_month)
        INTERVAL_MONTH
      when l(:interval_year)
        INTERVAL_YEAR
      else
        logger.error "#{l(:error_invalid_interval)} #{value} (interval_localized_name=)"
        ""
      end
  end
  
  # time interval value of the recurrence pattern
  def recurrence_pattern
    case interval_unit
    when INTERVAL_DAY
      interval_number.days
    when INTERVAL_WEEK
      interval_number.weeks
    when INTERVAL_MONTH
      interval_number.months
    when INTERVAL_YEAR
      interval_number.years
    else
      logger.error "#{l(:error_invalid_interval)} #{interval_unit} (recurrence_pattern)"
      1.years
    end
  end
  
  def self.find_by_issue issue
    # it's possible there is more than one recurrence associated with an issue
    RecurringTask.where(current_issue_id: issue.id)
  end
  
  # retrieve all recurring tasks given a project
  def self.all_for_project project
    if project.nil? then all else RecurringTask.includes(:issue).where("issues.project_id" => project.id) end
  end
  
  # next due date for the task, if there is one (relative tasks won't have a next schedule until the current issue is closed)
  def next_scheduled_recurrence
    if previous_date_for_recurrence.nil? 
      logger.error "Previous date for recurrence was nil for recurrence #{id}"
      Date.today
    else 
      previous_date_for_recurrence + recurrence_pattern
    end
  end
  
  # whether a recurrence needs to be added
  def need_to_recur?
    if(fixed_schedule and (previous_date_for_recurrence + recurrence_pattern) <= (Time.now.to_date + 1.day)) then true else issue.closed? end
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
  # called before save
  def set_interval
    logger.info "setting interval called"
    if !@interval_localized_name.nil?  
      interval_unit= RecurringTask.get_interval_from_localized_name(@interval_localized_name)
      logger.info "interval set to #{interval_unit}"
    end
  end

  # the date from which to recur
  # for a fixed schedule, this is the due date
  # for a relative schedule, this is the date closed
  def previous_date_for_recurrence
    if issue.nil? 
      logger.error "Issue is nil for recurrence #{id}."
      Date.today
    elsif fixed_schedule and !issue.due_date.nil? 
      issue.due_date 
    elsif issue.closed_on.nil? 
      issue.updated_on
    else 
      issue.closed_on 
    end
  end
end
