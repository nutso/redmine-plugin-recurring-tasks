require_relative '../test_helper.rb'

class RecurringTaskTest < ActiveSupport::TestCase
  plugin_fixtures :issues, :recurring_tasks
  fixtures :projects, :users, :roles, :trackers, :projects_trackers,
           :issue_statuses, :enumerations, :enabled_modules

  def setup
    RecurringTask.any_instance.stubs :puts
  end

  def test_daily_recurrence
    task = RecurringTask.find fixture(:fixed_daily_recurrence)

    assert_difference -> { Issue.count }, 2 do
      task.recur_issue_if_needed!
    end
  end

  def test_working_day_recurrence
    task = RecurringTask.find fixture(:fixed_working_day_recurrence)
    issue = Issue.find fixture(:basic_issue)
    issue.update start_date: Date.today.beginning_of_week-3.weeks,
                 due_date: Date.today.beginning_of_week-3.weeks+1.day

    Timecop.freeze(Date.today.beginning_of_week) do
      assert_difference -> { Issue.count }, 15 do
        task.recur_issue_if_needed!
      end
    end
  end
end
