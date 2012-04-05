#
#  Copyright (C) 2001, 2002 MIT
#
#  This file is part of dotLRN.
#
#  dotLRN is free software; you can redistribute it and/or modify it under the
#  terms of the GNU General Public License as published by the Free Software
#  Foundation; either version 2 of the License, or (at your option) any later
#  version.
#
#  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
#  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
#  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
#  details.
#

# www/calendar-portlet.tcl
ad_page_contract {
    The display logic for the calendar portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @cvs_id $Id$
} {
    {view ""}
    {page_num ""}
    {date ""}
    {period_days:integer ""}
    {julian_date ""}
} -properties {
    
}  -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

#if we get a value for the period_days from the user, we set that as a cookie
if { $period_days ne "" } {
  if {! [string is integer $period_days] || ![ad_var_type_check_integer_p $period_days]} {
    set period_days 7
  } elseif { $period_days > 9000 || $period_days < 1} {
    set period_days 7
  }
  ad_set_cookie -max_age "inf" CalendarPortletPeriodDays $period_days
} else {
  set period_days [ad_get_cookie CalendarPortletPeriodDays 7]
  if {![string is integer $period_days ] || ![ad_var_type_check_integer_p $period_days]} { set period_days 7 
  } elseif { $period_days > 9000 || $period_days < 1} {
    set period_days 7
  }
}

if {![info exists period_days]} {
    set period_days [parameter::get -parameter ListView_DefaultPeriodDays -default 7]
}

# get stuff out of the config array
array set config $cf
#set view $config(default_view)
set view "list"
set list_of_calendar_ids $config(calendar_id)

##fix to get also the global calendar into the portlet
set user_id [ad_conn user_id]
set calendar_ids [join $list_of_calendar_ids ", "]
set list_of_calendar_ids [db_list [::calendar::ical sql select_calendar_ids_from_calendar_ids] {}]
##end fix

set base_url [ad_conn url]
#Calendar admin button in portlet: set link#
if { [string match -nocase "*/one-community*" $base_url]} {
    set cal_admin_url [string trimright $base_url ?one-community?page_num=0?]
} else {
    set cal_admin_url $base_url
}


set scoped_p $config(scoped_p)

if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

if {[llength $list_of_calendar_ids] > 1} {
    set force_calendar_id [calendar::have_private_p -return_id 1 -calendar_id_list $list_of_calendar_ids -party_id [ad_conn user_id]]
} else {
    set force_calendar_id [lindex $list_of_calendar_ids 0]
}

# permissions
set create_p [ad_permission_p $force_calendar_id cal_item_create]
set edit_p [ad_permission_p $force_calendar_id cal_item_edit]
set admin_p [ad_permission_p $force_calendar_id calendar_admin]

# set up some vars
set date [ns_queryget date]
if {[empty_string_p $date]} {
    set date [dt_sysdate]
}
set current_date $date
set date_format "YYYY-MM-DD HH24:MI"

set item_template "<a href=\${url_stub}cal-item-view?show_cal_nav=0&return_url=[ns_urlencode "../"]&action=edit&cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"

if {$create_p} {
    set hour_template "<a href=calendar/cal-item-new?date=$current_date&start_time=\$day_current_hour>\$localized_day_current_hour</a>"
    set item_add_template "<a href=calendar/cal-item-new?start_time=&time_p=1&end_time=&julian_date=\$julian_date title=\"[_ calendar.Add_Item]\">+</a>"
} else {
    set hour_template "\$localized_day_current_hour"
    set item_add_template ""
}

set url_stub_callback "calendar_portlet_display::get_url_stub" 

if { $view == "day" } {
    if {[catch {set yest [clock format [clock scan "1 day ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
	set previous_link ""
    } else {
	if {[catch {clock scan $yest}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"?page_num=$page_num&date=\$yesterday\"><img border=0 src=\"[dt_left_arrow]\" alt=\"back one day\"></a>"
	}
    }

    if {[catch {set tomor [clock format [clock scan "1 day" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_link ""
    } else {
	if {[catch {clock scan $tomor}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"?page_num=$page_num&date=\$tomorrow\"><img border=0 src=[dt_right_arrow] alt=\"forward one day\"></a>"
	}
    }
}

if {$view == "week"} {
    if {[catch {set last_w [clock format [clock scan "1 week ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set previous_link ""
    } else {
	if {[catch {clock scan $last_w}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=\"?date=\$last_week&view=week&page_num=$page_num\"><img border=0 src=[dt_left_arrow] alt=\"back one week\"></a>"
	}
    }

    if {[catch {set next_w [clock format [clock scan "1 week" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_link ""
    } else {
	if {[catch {clock scan $next_w}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=\"?date=\$next_week&view=week&page_num=$page_num\"><img border=0 src=[dt_right_arrow] alt=\"forward one week\"></a>"
	}
    }
    set prev_week_template "<a href=\"?date=\[ad_urlencode \[dt_julian_to_ansi \[expr \$first_weekday_julian - 7\]\]\]&view=week&page_num=$page_num\"><img border=0 src=[dt_left_arrow] alt=\"back one week\"></a>" 
    set next_week_template "<a href=\"?date=\[ad_urlencode \[dt_julian_to_ansi \[expr \$first_weekday_julian + 7\]\]\]&view=week&page_num=$page_num\"><img border=0 src=[dt_right_arrow] alt=\"forward one week\"></a>" 
}

if {$view == "month"} {
    if {[catch {set prev_m [clock format [clock scan "1 month ago" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set previous_link ""
    } else {
	if {[catch {clock scan $prev_m}]} {
	    set previous_link ""
	} else {
	    set previous_link "<a href=?view=month&date=\$ansi_date&page_num=$page_num><img border=0 src=[dt_left_arrow] alt=\"back one month\"></a>"
	}
    }
	
    if {[catch {set next_m [clock format [clock scan "1 month" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_link ""
    } else {
	if {[catch {clock scan $next_m}]} {
	    set next_link ""
	} else {
	    set next_link "<a href=?view=month&date=\$ansi_date&page_num=$page_num><img border=0 src=[dt_right_arrow] alt=\"forward one month\"></a>"
	}
    }
    if { [info exists previous_link] } { set prev_month_template $previous_link }
    if { [info exists next_link] } { set next_month_template $next_link }
}

if {$view == "list"} {
    set sort_by [ns_queryget sort_by]

    set thirty_days [expr 60*60*24*30]

    set start_date [ns_fmttime [expr [ns_time] - $thirty_days] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr [ns_time] + $thirty_days] "%Y-%m-%d 00:00"]

    set url_template "?view=list&sort_by=\$order_by&page_num=$page_num" 
}

template::head::add_css -href "/resources/calendar/calendar.css"
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

ad_return_template
