module RecurringTasks
  module IssuePatch
    def self.included(base)
      base.class_eval do
        has_many :recurring_tasks, :foreign_key => 'current_issue_id', :dependent => :delete_all # cascading delete
        
        # adding a property to issues that shows subject (date) that can be used in selecting issues
        def subj_date
          "#{self.subject} (#{format_date self.due_date})"
        end #subj_date
        
        # whether this issue recurs
        def recurs?
          !(recurring_tasks.nil? || recurring_tasks.length <= 0)
          # TODO determine if it was a historically recurring task
        end
      end # base.class_eval
    end # self.included
  end # issues patch
end # recurring task
