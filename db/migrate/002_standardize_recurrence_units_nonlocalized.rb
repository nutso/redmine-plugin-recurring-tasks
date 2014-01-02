# Previous to this migration, the value for recurring_tasks.interval_units
# was pulled from the localization file.
# This made the values more user-friendly when looking at the database directly
# however caused issues when the text changed, or locale changed.
# Here we are switching to just flags to denote the type of unit instead of text.
class StandardizeRecurrenceUnitsNonlocalized < ActiveRecord::Migration
  def up
    RecurringTask.all.each do |rt|
      begin
        logger.info "Migrating task ##{rt.id} from #{rt.interval_unit}"
        rt.interval_unit = RecurringTask.get_interval_localized_name(rt.interval_unit)
        rt.save!(:validate => false)
      rescue => e
        msg = "Migration for recurrence FAILED. ##{rt.id} from #{rt.interval_unit} FAILED. You will need to update this manually. Error: #{e}" # TODO localize
        logger.error msg
        say msg # also display to user
      end
    end
  end
  
  # There is no rolling back - this is a change to the DATA in the database, 
  # not to the structure itself.
  # There is no guarantee that the current localized translation was the value
  # previously in the database.
  def down
    # say "ActiveRecord::IrreversibleMigration"
    raise ActiveRecord::IrreversibleMigration
  end
end