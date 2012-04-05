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
    The display logic for the calendar admin portlet

    @author Arjun Sanyal (arjun@openforce.net)
    @author Ben Adida (ben@openforce.net)
    @cvs_id $Id$
} {
    {period_days:optional}
} -properties {
    
}

# get stuff out of the config array
array set config $cf
set view $config(default_view)
set list_of_calendar_ids $config(calendar_id)

set calendar_id [lindex $list_of_calendar_ids 0]
db_0or1row select_calendar_package_id {select package_id from calendars where calendar_id=:calendar_id}

if { ![info exists period_days] } {
    set period_days [parameter::get -package_id $package_id -parameter ListView_DefaultPeriodDays]
} else {
    parameter::set_value -package_id $package_id -parameter ListView_DefaultPeriodDays -value $period_days
}

if {[llength $list_of_calendar_ids] > 1} {
    return -code error "shouldn't be more than one calendar in admin!"
}

set url "calendar/"

ad_return_template
