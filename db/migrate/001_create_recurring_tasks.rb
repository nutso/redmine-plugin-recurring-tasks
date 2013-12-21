class CreateRecurringTasks < ActiveRecord::Migration
  def change
    create_table :recurring_tasks do |t|
              t.column :current_issue_id, :integer
              t.column :fixed_schedule, :boolean
              t.column :interval_number, :integer
              t.column :interval_unit, :string
    end
  end
end
