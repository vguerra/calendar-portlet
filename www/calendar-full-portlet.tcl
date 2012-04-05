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

# www/calendar-full-portlet.tcl
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
    
} -validate {
    valid_date -requires { date } {
        if {![string equal $date ""]} {
            if {[catch {set date [clock format [clock scan $date] -format "%Y-%m-%d"]} err]} {
                ad_complain "Your input ($date) was not valid. It has to be in the form YYYYMMDD."
            }
        }
    }
}

# if we get a value for the period_days from the user, we set that as a cookie
if { $period_days != "" } {
  if {! [string is integer $period_days] || ![ad_var_type_check_integer_p $period_days] } {
    set period_days 30
  } elseif { $period_days > 9000 || $period_days < 1} {
    set period_days 30
  }
  ad_set_cookie -max_age "inf" CalendarFullPortletPeriodDays $period_days
} else {
   set period_days [ad_get_cookie CalendarFullPortletPeriodDays 30]
   if {![string is integer $period_days ] || ![ad_var_type_check_integer_p $period_days]} { 
     set period_days 30 
   } elseif { $period_days > 9000 || $period_days < 1} {
     set period_days 30
   }
}


# get stuff out of the config array
array set config $cf
if {[empty_string_p $view]} {
    set view $config(default_view)
}
set list_of_calendar_ids $config(calendar_id)

set user_id [ad_conn user_id]
set ad_conn_url [ad_conn url]
set base_url [ad_conn package_url]

set private_calendar [db_list get_private_calendar {
  select calendar_id from calendars 
  where owner_id = :user_id and private_p = 't';}]

set calendar_ids [join $list_of_calendar_ids ", "]
set list_of_calendar_ids [db_list [::calendar::ical sql select_calendar_ids_from_calendar_ids] {}]

lappend list_of_calendar_ids $private_calendar


set scoped_p $config(scoped_p)
if {$scoped_p == "t"} {
    set show_calendar_name_p 1
} else {
    set show_calendar_name_p 0
}

# Styles for calendar
template::head::add_css -href "/resources/calendar/calendar.css"
template::head::add_css -alternate -href "/resources/calendar/calendar-hc.css" -title "highContrast"

# set the period_days for calendar's list view, therefore we need
# to check which instance of calendar is currently displayed
if {[apm_package_installed_p dotlrn]} {
    set site_node [site_node::get_node_id_from_object_id -object_id [ad_conn package_id]]
    set dotlrn_package_id [site_node::closest_ancestor_package -node_id $site_node -package_key dotlrn -include_self]
    set community_id [db_string get_community_id {select community_id from dotlrn_communities_all where package_id=:dotlrn_package_id} -default [db_null]]
} else {
    set community_id ""
}

set calendar_id [lindex $list_of_calendar_ids 0]
db_0or1row select_calendar_package_id {select package_id from calendars where calendar_id=:calendar_id}
if { ![info exists period_days] } {
    if { [exists_and_not_null community_id] } {
        set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays -default 31]
    } else {
        foreach calendar $list_of_calendar_ids {
            # returns 1 if calendar_id is user's personal calendar
            if { [calendar::personal_p -calendar_id $calendar] } {
                db_0or1row select_calendar_package_id {select package_id from calendars where calendar_id=:calendar}
                set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays -default 31]
                break
            }
        }
    }
}

if {[llength $list_of_calendar_ids] > 1} {
    set force_calendar_id [calendar::have_private_p -return_id 1 -calendar_id_list $list_of_calendar_ids -party_id $user_id]
} else {
    set force_calendar_id [lindex $list_of_calendar_ids 0]
}

# permissions
set create_p [ad_permission_p $force_calendar_id cal_item_create]
set edit_p [ad_permission_p $force_calendar_id cal_item_edit]
set admin_p [ad_permission_p $force_calendar_id calendar_admin]

if {[empty_string_p $view]} {
    set view $config(default_view)
}
#  else {
#     if { [string equal $scoped_p t] && $admin_p } {
#         #This is a user scoped portlet.  Save the current view for next time.
#         ns_log Debug "calendar-full-portlet: Saving view $view for next time."
#         portal::set_element_param $config(element_id) default_view $view
#     }
# }

# set up some vars
if {[empty_string_p $date]} {
    if {[empty_string_p $julian_date]} {
        set date [dt_sysdate]
    } else {
        set date [db_string select_from_julian "select to_date(:julian_date ,'J') from dual"]
    }
}

# global variables
set current_date $date
set date_format "YYYY-MM-DD HH24:MI"
set return_url "[ns_conn url]?[ns_conn query]"

set encoded_return_url [ns_urlencode $return_url]
set add_item_url [export_vars -base "calendar/cal-item-new" {{date $current_date} {time_p 1} return_url}]

set item_template "<a href=\${url_stub}cal-item-view?show_cal_nav=0&return_url=$encoded_return_url&action=edit&cal_item_id=\$item_id>\[ad_quotehtml \$item\]</a>"

if {$create_p} {
    set hour_template "<a href=calendar/cal-item-new?date=$current_date&start_time=\$day_current_hour&return_url=$encoded_return_url>\$localized_day_current_hour</a>"
    set item_add_template "<a href=calendar/cal-item-new?start_time=&time_p=1&end_time=&julian_date=\$julian_date&return_url=$encoded_return_url title=\"[_ calendar.Add_Item]\">+</a>"
  set publish_calendar $force_calendar_id
} else {
    set hour_template "\$localized_day_current_hour"
    set item_add_template ""
  set publish_calendar read
}

set url_stub_callback "calendar_portlet_display::get_url_stub" 

if {$view == "day"} {
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
        set prev_month_template ""
    } else {
	if {[catch {clock scan $prev_m}]} {
	    set prev_month_template ""
	} else {
	    set prev_month_template "<a href=?view=month&date=\[ad_urlencode \$prev_month\]&page_num=$page_num><img border=0 src=[dt_left_arrow] alt=\"back one month\"></a>"
	}
    }
	
    if {[catch {set next_m [clock format [clock scan "1 month" -base [clock scan $date]] -format "%Y-%m-%d"]}]} {
        set next_month_template ""
    } else {
	if {[catch {clock scan $next_m}]} {
	    set next_month_template ""
	} else {
	    set next_month_template "<a href=?view=month&date=\[ad_urlencode \$next_month\]&page_num=$page_num><img border=0 src=[dt_right_arrow] alt=\"forward one month\"></a>"
	}
    }
}


if {$view == "list"} {
    set sort_by [ns_queryget sort_by]


    set start_date [ns_fmttime [expr [ns_time]] "%Y-%m-%d 00:00"]
    set end_date [ns_fmttime [expr {[ns_time] + 60*60*24*$period_days}] "%Y-%m-%d 00:00"]

    set url_template "?view=list&sort_by=\$order_by&page_num=$page_num" 
}

set export [ns_queryget export]

if { [lsearch [list csv vcalendar] $export] != -1 } {
    set package_id [ad_conn package_id]
    if { [string equal $view list] } {
        calendar::export::$export -calendar_id_list $list_of_calendar_ids -view $view -date $date -start_date $start_date -end_date $end_date $user_id $package_id
    } else {
        calendar::export::$export -calendar_id_list $list_of_calendar_ids -view $view -date $date $user_id $package_id
    }
    ad_script_abort
} else {
    ad_return_template 
}
