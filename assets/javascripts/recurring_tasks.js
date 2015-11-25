$(document).on('change', 'select#recurring_task_interval_unit', onUnitChanged);

$(document).ready(function() {
  updateIntervalModifier($('select#recurring_task_interval_unit').val());
});

function onUnitChanged(event) {
  updateIntervalModifier($(this).val());
}

function updateIntervalModifier(unit) {
  if (unit == 'd') {
    $('.day_interval_modifier select').prop('disabled', false);
    $('.day_interval_modifier').show();
  } else {
    $('.day_interval_modifier select').prop('disabled', true);
    $('.day_interval_modifier').hide();
  }

  if (unit == 'm') {
    $('.month_interval_modifier select').prop('disabled', false);
    $('.month_interval_modifier').show();
  } else {
    $('.month_interval_modifier select').prop('disabled', true);
    $('.month_interval_modifier').hide();
  }
}

