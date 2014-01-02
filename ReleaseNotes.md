# Recurring Tasks Redmine Plugin -- Release Notes

## Known Issues

### Master (Stable)

* (Confirmed) Deleting an issue neither generates a warning nor deletes the recurrence
* (Reported) Incompatibility with Redmine Stable 2.4 (#20)
* (Confirmed) No ability to view historic recurrences

### Develop

* Update recurrence does not save properly

## Resolved in Develop (Next Version)

* After deleting an issue that still has a recurrence, recurrence views generate errors
* Menu captions not localized (#21)
* Changing the interval_day, interval_week, interval_month, or interval_year strings in the locale file, or changing locales, after adding recurrences generates an error

## Version 1.2.5

* resolved nil reference for fixed schedule recurrences with no due date (#16)
* includes german translation contributed by @skolarianer

## Version 1.2.0

* more intuitive management within the issues themselves
* add link to add recurrence when viewing an issue (#7)
* display existing recurrence if application when viewing an issue (#6)

## Version 1.1.0

* Project-specific recurring tasks view (#11)
* Better permissions (managed under issues) (#12)

## Version 1.0.2

* Show next scheduled recurrence when displaying a recurring task (#9)
* Add more than one recurrence to 'catch up' if warranted when recurring (#10)
* Localized date format display

## Version 1.0.1

* Added missing translations
* Fixed missing routes (#1)

## Version 1.0.0

* Initial functionality to configure recurring tasks. 
* Any task can be set to recur on a fixed (e.g. every Monday) 
  or flexible (e.g. 2 days after task was last completed) schedule