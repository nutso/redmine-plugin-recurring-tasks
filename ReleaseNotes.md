# Recurring Tasks Redmine Plugin -- Release Notes

## Features Requested and Known Issues

Reference open issues in GitHub: https://github.com/nutso/redmine-plugin-recurring-tasks/issues

## Next Version (Version 2.0.0)

In work
* Clarify how recurrences are calculated for non-fixed ([#64](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/64))

Done
* Recurred issue start date is set to original offset as original issue, i.e. if the original issue was set to take one month to complete, the recurred issue will have the same timespan 
  ([#76](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/76))
* Display localized date in partial contributed by @guite ([#81](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/81))
* Assign the issue author based on a) configured recurring user, or b) previous issue author to avoid permissions issues conflict with Luxury Buttons plugin 
  ([#61](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/61)) and ([#86](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/86)
* Table view of all recurring tasks for project or system is now sortable ([#77](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/77))
* Handle when a recurring issue does not have a start date, due date, or either ([#90](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/90))
* Set issue author to configured user if specified in plugin
* Option to recur subtasks on a per-recurrence basis ([#96](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/96)) -- contributed by @bartj3

## Version 1.6.0 (14 June 2015)

* Configurable option to hide the "Recurring issues" link in the admin menu ([#54](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/54))
* Option to re-open recurring issues instead of creating a new issue, so all comments/information are stored in a single place ([#45](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/45)); 
  ([#74](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/74)). 

## Version 1.5.0 (13 June 2015)

* Backwards-compatibility to Redmine 2.2 by testing if issue.closed_on? method exists ([#49](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/36))
* Redmine 3.0 support contributed by @lammel ([#65](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/65))
* French translation updated by @jbeauvois ([#66](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/66)
* Better documentation of plugin permissions
* Reversible migrations so can uninstall fully ([#53](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/53))
* Highlighting to user that adding recurrence via issues page is the best way ([#52](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/52))
* Stable support for both Redmine 2.x and Redmine 3.x ([#71](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/71)); ([#67](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/67)) and ([#69](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/69))

## Version 1.4.0 (07 Sep 2014)

* NOTE: Version number in 1.4.0 is incorrectly labelled as 1.3.0. ([#58](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/58))
* French translation updated by @fidergo-stephane-gourichon ([#46](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/46))
* Recur on day x of every n months ([#26](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/26)) -- contributed by @cryptogopher ([#41](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/41))

## Version 1.3.0 (01 Mar 2014)

* Russian translation contributed by @box789 ([#30](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/30))
* French translation contributed by @jbeauvois ([#35](https://github.com/nutso/redmine-plugin-recurring-tasks/pull/35))
* Backward Rails syntax compatibility ([#29](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/29)), [#34](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/34))
* Deleting the source issue for a recurrence deletes the recurrence ([#33](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/33))
* Recurrence checks for nil issue before attempting to recur ([#33](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/33))

## Version 1.2.9 (07 Jan 2014)

* Set done_ratio to zero for recurred issues ([#26](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/26))
* Updated German translation file from @skolarianer ([#27](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/27))

## Version 1.2.8 (05 Jan 2014)

* Using validates_presence_of instead of validates :x, presence: true for backward Rails compatibility ([#20](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/20))
* Using validates_inclusion_of and validates_numericality_of instead of stand-alone validates for backward Rails compatibility ([#20](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/20))
* Creating a new recurrence sets interval_unit properly from localized name

## Version 1.2.7 (04 Jan 2014)

* Changed to more traditional :through => :issue instead of through: :issue for backward Rails compatibility ([#20](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/20))

## Version 1.2.6 (04 Jan 2014)

* After deleting an issue that still has a recurrence, recurrence views generate errors
* Menu captions not localized ([#21](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/21))
* Changing the interval_day, interval_week, interval_month, or interval_year strings in the locale file, or changing locales, after adding recurrences generates an error

## Version 1.2.5 (30 Dec 2013)

* resolved nil reference for fixed schedule recurrences with no due date ([#16](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/16))
* includes german translation contributed by @skolarianer

## Version 1.2.0 (29 Dec 2013)

* more intuitive management within the issues themselves
* add link to add recurrence when viewing an issue (([#7](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/7)))
* display existing recurrence if application when viewing an issue ([#6](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/6))

## Version 1.1.0 (28 Dec 2013)

* Project-specific recurring tasks view ([#11](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/11))
* Better permissions (managed under issues) ([#12](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/12))

## Version 1.0.2 (26 Dec 2013)

* Show next scheduled recurrence when displaying a recurring task ([#9](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/9))
* Add more than one recurrence to 'catch up' if warranted when recurring ([#10](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/10))
* Localized date format display

## Version 1.0.1 (25 Dec 2013)

* Added missing translations
* Fixed missing routes ([#1](https://github.com/nutso/redmine-plugin-recurring-tasks/issues/1))

## Version 1.0.0 (21 Dec 2013)

* Initial functionality to configure recurring tasks. 
* Any task can be set to recur on a fixed (e.g. every Monday) 
  or flexible (e.g. 2 days after task was last completed) schedule
