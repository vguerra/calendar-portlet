<?xml version="1.0"?>

<queryset>
<rdbms><type>oracle</type><version>8.1.6</version></rdbms>

<fullquery name="select_day_items">
<querytext>
    select   
      to_char(start_date, 'HH24:MI') as pretty_start_date,
      to_char(end_date, 'HH24:MI') as pretty_end_date,
      nvl(e.name, a.name) as name,
      e.event_id as item_id,
      c.calendar_name as calendar_name
    from
      acs_activities a,
      acs_events e,
      timespans s,
      time_intervals t,
      cal_items ci,
      calendars c
    where    
      e.timespan_id = s.timespan_id
      and  s.interval_id = t.interval_id
      and  e.activity_id = a.activity_id
      and  start_date between
        to_date(:current_date,:date_format) and
        to_date(:current_date,:date_format) + (24 - 1/3600)/24
      and e.event_id = ci.cal_item_id
      and c.calendar_id = ci.on_which_calendar
      and c.calendar_id in ($list_of_calendar_ids)
    UNION
    select 
      pretty_start_date,
      pretty_end_date,
      to_char(NULL) as name,
      0 as item_id,
      to_char(NULL) as calendar_name
    from hours_of_the_day
    order by pretty_start_date

</querytext>
</fullquery>


</queryset>
