class RecurringTask < ActiveRecord::Base
  unloadable

  belongs_to :issue, :foreign_key => 'current_issue_id'
  has_one :project, :through => :issue

  attr_accessible :id, :current_issue_id, :interval_number, :interval_modifier, :interval_unit, :fixed_schedule, :recur_subtasks# list all fields that you want to be accessible here
  
  # these are the flags used in the database to denote the interval
  # the actual text displayed to the user is controlled in the language file
  INTERVAL_DAY = 'd'
  INTERVAL_WEEK = 'w'
  INTERVAL_MONTH = 'm'
  INTERVAL_YEAR = 'y'

  #41  
  # similar flags for denoting more complex recurrence schemes
  # they are modyfing how due dates are scheduled when INTERVAL_MONTH is in
  # effect
  MONTH_MODIFIER_DAY_FROM_FIRST = 'mdff'
  MONTH_MODIFIER_DAY_TO_LAST = 'mdtl'
  MONTH_MODIFIER_DOW_FROM_FIRST = 'mdowff'
  MONTH_MODIFIER_DOW_TO_LAST = 'mdowtl'
  
  
  # must come before validations otherwise uninitialized
  # INTERVAL_UNITS_LOCALIZED = [l(:interval_day), l(:interval_week), l(:interval_month), l(:interval_year)] #41
  INTERVAL_UNITS_LOCALIZED = {
    INTERVAL_DAY => l(:interval_day),
    INTERVAL_WEEK => l(:interval_week),
    INTERVAL_MONTH => l(:interval_month),
    INTERVAL_YEAR => l(:interval_year)
  }
  MONTH_MODIFIERS_LOCALIZED = {
    MONTH_MODIFIER_DAY_FROM_FIRST => l(:month_modifier_day_from_first),
    MONTH_MODIFIER_DAY_TO_LAST => l(:month_modifier_day_to_last),
    MONTH_MODIFIER_DOW_FROM_FIRST => l(:month_modifier_dow_from_first),
    MONTH_MODIFIER_DOW_TO_LAST => l(:month_modifier_dow_to_last)
  }


  # pulled out validates_presence_of separately
  # for older Rails compatibility
  # validates_presence_of :interval_localized_name #41
  validates_presence_of :interval_unit
  validates_presence_of :interval_modifier, :if => "interval_unit == RecurringTask::INTERVAL_MONTH"

  validates_presence_of :interval_number
  
  #41
  # validates_inclusion_of :interval_localized_name, :in => RecurringTask::INTERVAL_UNITS_LOCALIZED, :message => "#{l(:error_invalid_interval)} '%{value}' (Validation)"
  validates_inclusion_of :interval_unit,
    :in => RecurringTask::INTERVAL_UNITS_LOCALIZED.keys,
    :message => "#{l(:error_invalid_interval)} '%{value}' (Validation)"
  validates_inclusion_of :interval_modifier,
    :in => RecurringTask::MONTH_MODIFIERS_LOCALIZED.keys,
    :message => "#{l(:error_invalid_modifier)} '%{value}' (Validation)",
    :if => "interval_unit == RecurringTask::INTERVAL_MONTH"
  
  validates_numericality_of :interval_number, :only_integer => true, :greater_than => 0
  # cannot validate presence of issue if want to use other features; requiring presence of fixed_schedule requires it to be true

  validates_associated :issue # just in case we build in functionality to add an issue at the same time, verify the issue is ok  
  
  # text for the interval name
  def interval_localized_name
    if new_record?
      @interval_localized_name
    else
      #41
      if INTERVAL_UNITS_LOCALIZED.has_key?(interval_unit)
        INTERVAL_UNITS_LOCALIZED[interval_unit]
#      case interval_unit
#      when INTERVAL_DAY
#        l(:interval_day)
#      when INTERVAL_WEEK
#        l(:interval_week)
#      when INTERVAL_MONTH
#        l(:interval_month)
#      when INTERVAL_YEAR
#        l(:interval_year)
      else
        raise "#{l(:error_invalid_interval)} #{interval_unit} (interval_localized_name)"
      end
    end
  end
 
#41 
  # interval database name for the localized text
#  def interval_localized_name=(value)
#    @interval_localized_name = value
#    interval_unit= RecurringTask.get_interval_from_localized_name(value)
#  end  
  
  # used for migration #2
#  def self.get_interval_from_localized_name(value)
#    case value
#      when l(:interval_day)
##        INTERVAL_DAY
 #     when l(:interval_week)
 #       INTERVAL_WEEK
 #     when l(:interval_month)
 #       INTERVAL_MONTH
 #     when l(:interval_year)
 #       INTERVAL_YEAR
 #     else
 #       raise "#{l(:error_invalid_interval)} #{value} (interval_localized_name=)"
 #     end
 # end
  # used for migration #002
  def self.get_interval_from_localized_name(value)
    retval = INTERVAL_UNITS_LOCALIZED.key(value)
    if retval.nil?
      raise "#{l(:error_invalid_interval)} #{value} (interval_localized_name=)"
    end
    retval
  end

 
#41
   # text for the interval modifier
  def interval_localized_modifier
    if new_record?
      @interval_localized_modifier
    else
      modifiers_names = get_modifiers_descriptions
      if modifiers_names.has_key?(interval_modifier)
        modifiers_names[interval_modifier]
       else
        raise "#{l(:error_invalid_modifier)} #{interval_modifier} (interval_localized_modifier)"
      end
    end
  end


#41  
  # time interval value of the recurrence pattern
#  def recurrence_pattern
#    case interval_unit
#    when INTERVAL_DAY
###      interval_number.days
 #   when INTERVAL_WEEK
 #     interval_number.weeks
 ##   when INTERVAL_MONTH
  #    interval_number.months
  #  when INTERVAL_YEAR
  #    interval_number.years
  #  else
  #    raise "#{l(:error_invalid_interval)} #{interval_unit} (recurrence_pattern)"
  #  end
 # end
  
  #41
  def get_modifiers_descriptions
    prev_date = previous_date_for_recurrence
    days_to_eom = (prev_date.end_of_month.mday - prev_date.mday + 1).to_i
    #print days_to_eom, " ", prev_date.end_of_month
    values = {
      :days_from_bom => prev_date.mday.ordinalize,
      :days_to_eom => days_to_eom.ordinalize,
      :day_of_week => prev_date.strftime("%A"),
      :dows_from_bom => ((prev_date.mday - 1) / 7 + 1).ordinalize,
      :dows_to_eom => (((prev_date.end_of_month.mday - prev_date.mday).to_i / 7) + 1).ordinalize,
    }
    Hash[MONTH_MODIFIERS_LOCALIZED.map{|k,v| [k, v % values]}]
  end
  
  # retrieve all recurring tasks given a project
  def self.all_for_project project
    if project.nil? then all else RecurringTask.includes(:issue).where("issues.project_id" => project.id) end
  end
  
  # next due date for the task, if there is one (relative tasks won't have a next schedule until the current issue is closed)
  def next_scheduled_recurrence
    prev_date = previous_date_for_recurrence
    if prev_date.nil? 
      logger.error "Previous date for recurrence was nil for recurrence #{id}"
      Date.today
    else 
      # previous_date_for_recurrence + recurrence_pattern #41
      case interval_unit
      when INTERVAL_DAY
        (prev_date + interval_number.days).to_date
      when INTERVAL_WEEK
        (prev_date + interval_number.weeks).to_date
      when INTERVAL_MONTH
        case interval_modifier
        when MONTH_MODIFIER_DAY_FROM_FIRST
          (prev_date + interval_number.months).to_date
        when MONTH_MODIFIER_DAY_TO_LAST
          days_to_last = prev_date.end_of_month - prev_date
          ((prev_date + interval_number.months).end_of_month - days_to_last).to_date
        when MONTH_MODIFIER_DOW_FROM_FIRST
          source_dow = prev_date.days_to_week_start
          target_bom = (prev_date + interval_number.months).beginning_of_month
          target_bom_dow = target_bom.days_to_week_start
          week = ((prev_date.mday - 1) / 7) + ((source_dow >= target_bom_dow) ? 0 : 1)
          (target_bom + week.weeks + source_dow - target_bom_dow).to_date
        when MONTH_MODIFIER_DOW_TO_LAST
          source_dow = prev_date.days_to_week_start
          target_eom = (prev_date + interval_number.months).end_of_month
          target_eom_dow = target_eom.days_to_week_start
          week = ((prev_date.end_of_month - prev_date).to_i / 7) + ((source_dow > target_eom_dow) ? 1 : 0)
          (target_eom - week.weeks + source_dow - target_eom_dow).to_date
        else
          raise "#{l(:error_invalid_modifier)} #{interval_modifier} (next_scheduled_recurrence)"
        end
      when INTERVAL_YEAR
        (prev_date + interval_number.years).to_date
      else
        raise "#{l(:error_invalid_interval)} #{interval_unit} (next_scheduled_recurrence)"
      end
      
    end
  end
  
  # whether a recurrence needs to be added
  def need_to_recur?
    # ensuring we don't have an infinite loop
    # if the setting is to reopen issues on recurrence, then if the issue is open, no recurrence is needed 
    return false if(Setting.plugin_recurring_tasks['reopen_issue'] == "1" && !issue.closed?)

    # 41
    # if(fixed_schedule and (previous_date_for_recurrence + recurrence_pattern) <= (Time.now.to_date + 1.day)) then true else issue.closed? end
    if fixed_schedule
      previous_date_for_recurrence <= Time.now.to_date # TODO add a day?
    else
      issue.closed?
    end
      
  end
  
  # check whether a recurrence is needed, and add one if not
  def recur_issue_if_needed!
    if issue.nil?
      puts "Recurring a deleted issue is not supported."
      return false
    end    
    
    return true unless need_to_recur?
    
    # Add more than one recurrence to 'catch up' if warranted (issue #10)
    
    # calculate the original number of days between start and due date
    timespan = 0 # default to same day if either a start or due date is not provided  
    begin
      timespan = issue.due_date - issue.start_date
    rescue => ex
    end
    
    old_current_user = User.current
    
    while need_to_recur?
      new_issue = issue # default to existing issue
      
      if Setting.plugin_recurring_tasks['journal_attributed_to_user'].blank?
        User.current = issue.author
      else
        defined_user = User.find(Setting.plugin_recurring_tasks['journal_attributed_to_user'])
        # if a journal user has been defined, create a journal
        issue.init_journal(defined_user, l(:label_recurring_task))
        User.current = defined_user
      end

      if Setting.plugin_recurring_tasks['reopen_issue'] != "1"
        # duplicate issue; cloning comes after setting the user so the author is set correctly (#89)
        new_issue = issue.copy nil, :subtasks => recur_subtasks?
        new_issue.save!
      end

      if recur_subtasks?
        new_issue.reload.children.each do |subtask|
          subtask_offset = (next_scheduled_recurrence - timespan) - issue.start_date
          subtask_timespan = subtask.due_date - subtask.start_date rescue 0
          subtask.start_date = subtask.start_date + subtask_offset
          subtask.due_date = subtask.start_date + subtask_timespan
          subtask.done_ratio = 0
          subtask.status = recurring_issue_default_status
          subtask.closed_on = nil
          subtask.save!
        end

        new_issue.reload
      end

      new_issue.due_date = next_scheduled_recurrence #41 previous_date_for_recurrence + recurrence_pattern
      new_issue.start_date = new_issue.due_date - timespan
      new_issue.done_ratio = 0
      new_issue.status = recurring_issue_default_status
      new_issue.closed_on = nil
      new_issue.save!

      puts "#{l(:recurring_task_created)} #{issue.id}: #{issue.subj_date} => #{new_issue.id}: #{new_issue.subj_date}"
    
      self.issue = new_issue
      save!  
    end
    
    User.current = old_current_user
  end
  
  def recurring_issue_default_status
    # issue status is NOT automatically new, default is whatever the default status for new issues is
     
    # Redmine 3
    return issue.tracker.default_status if issue.tracker.respond_to?(:default_status)
    # Redmine 2
    IssueStatus.default
  end
  
  #41
  def recurrence_to_s
    modifier = (interval_unit == INTERVAL_MONTH) ? " #{interval_localized_modifier}" : ""
    schedule = fixed_schedule ? l(:label_recurs_fixed) : l(:label_recurs_dependent)
    "#{l(:label_recurrence_pattern)} #{interval_number} #{interval_localized_name.pluralize(interval_number)}#{modifier}, #{schedule}"
  end

  
  def to_s
    i = "No issue associated " # TODO localize
    if !(issue.nil?)
      i = issue.subj_date
    end
    "#{i} (#{l(:label_recurrence_pattern)} #{interval_number} #{interval_unit}s " + (:fixed_schedule ? l(:label_recurs_fixed) : l(:label_recurs_dependent)) + ")"
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
    if issue.nil? 
      logger.error "Issue is nil for recurrence #{id}."
      Date.today
    elsif fixed_schedule and !issue.due_date.nil? 
      issue.due_date
    elsif !issue.respond_to?('closed_on') # closed_on introduced in Redmine 2.3, ref http://www.redmine.org/issues/824
      issue.updated_on
    elsif issue.closed_on.nil? 
      issue.updated_on
    else 
      issue.closed_on 
    end
  end
end
