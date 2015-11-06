class AddRecurDescendantsField < ActiveRecord::Migration
  def change
    change_table :recurring_tasks do |t|
      t.column :recur_descendants, :boolean
    end
  end
end
