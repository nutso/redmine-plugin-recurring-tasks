module RecurringTasks
  class Hooks < Redmine::Hook::ViewListener
    # view issue
    render_on :view_issues_show_description_bottom,
      :partial => 'issues/show_recurrence'
  end
end