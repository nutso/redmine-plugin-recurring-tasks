# After introducing modifiers for monthly recurring tasks it is necessary to set
# default modifier for existing issues. Otherwise validation error will occur.
class SetDefaultModifierForExistingMonthlyIssues < ActiveRecord::Migration
  def up
    RecurringTask.find_all_by_interval_unit(RecurringTask::INTERVAL_MONTH).each do |rt|
      begin
        logger.info "Migrating task ##{rt.id}, interval unit #{rt.interval_unit}"
        rt.interval_modifier = RecurringTask::MONTH_MODIFIER_DAY_FROM_FIRST
        rt.save!()
      rescue => e
        msg = "Migration for recurrence FAILED. You will need to update this manually. ##{rt.id}/'#{rt.interval_unit}' #{e}"
        logger.error msg
        say msg # also display to user
      end
    end
  end
  
  # There is no rolling back - this is a change to the DATA in the database, 
  # not to the structure itself.
  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
