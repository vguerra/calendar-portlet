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

# calendar-portlet/tcl/calendar-portlet-display-procs.tcl

ad_library {

Procedures to support the calendar portlet display

@creation-date April 15, 2002
@author ben@openforce.net
@cvs-id $Id$

}

namespace eval calendar_portlet_display {
    
    ad_proc -public get_url_stub {
        calendar_id
    } {
        return [site_node_object_map::get_url -object_id $calendar_id]
    }
    
}
