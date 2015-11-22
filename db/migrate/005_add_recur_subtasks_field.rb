class AddRecurSubtasksField < ActiveRecord::Migration
  def change
    change_table :recurring_tasks do |t|
      t.column :recur_subtasks, :boolean
    end
  end
end
