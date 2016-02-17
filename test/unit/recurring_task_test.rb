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

  def test_removes_closed_on
    task = RecurringTask.find fixture(:fixed_daily_recurrence)
    task.issue.status = IssueStatus.find_by(name: "Closed")
    task.issue.save

    assert_not_nil task.issue.closed_on
    task.recur_issue_if_needed!
    assert_nil task.issue.closed_on
  end
end
