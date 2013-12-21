module RecurringTasks
  module IssuePatch
    def self.included(base)
      base.class_eval do
        # adding a property to issues that shows subject (date) that can be used in selecting issues
        def subj_date
          "#{self.subject} (#{self.due_date})"
        end #subj_date
      end # base.class_eval
    end # self.included
  end # issues patch
end # recurring task
