# Previous to this migration, the value for recurring_tasks.interval_units
# was pulled from the localization file.
# This made the values more user-friendly when looking at the database directly
# however caused issues when the text changed, or locale changed.
# Here we are switching to just flags to denote the type of unit instead of text.
class StandardizeRecurrenceUnitsNonlocalized < ActiveRecord::Migration
  def up
    # TODO confirm with user until it's reversible
    
    RecurringTask.all.each do |rt|
      begin
        rt.interval_localized_name = rt.interval_unit
      rescue
        # TODO note error
      end
    end
  end
  
  # There is no rolling back - this is a change to the DATA in the database, 
  # not to the structure itself.
  # There is no guarantee that the current localized translation was the value
  # previously in the database.
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end