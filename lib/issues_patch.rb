module RecurringTasks
  module IssuePatch
    def self.included(base)
      base.class_eval do
        # adding a property to issues that shows subject (date) that can be used in selecting issues
        def subj_date
          begin
            "#{self.subject} (#{format_date self.due_date})"
          rescue
            # TODO log info or whatnot if self is nil ... for some reason it still gets here
            ""
          end
        end #subj_date
        
        # whether this issue recurs
        def recurs?
          !(recurring_tasks.nil? || recurring_tasks.length <= 0)
          # TODO determine if it was a historically recurring task
        end
        
        def recurring_tasks
          RecurringTask.find_by_issue(self)
        end
      end # base.class_eval
    end # self.included
  end # issues patch
end # recurring task
