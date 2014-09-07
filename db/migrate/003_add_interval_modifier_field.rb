class AddIntervalModifierField < ActiveRecord::Migration
  def change
    change_table :recurring_tasks do |t|
      t.column :interval_modifier, :string
    end
  end
end
