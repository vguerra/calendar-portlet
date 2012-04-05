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

ad_library {

    Procedures to support the calendar admin portlet

    @creation-date Jan 2002
    @author arjun@openforce.net
    @author ben@openforce.net
    @cvs-id $Id$
}

namespace eval calendar_admin_portlet {

    ad_proc -private my_package_key {
    } {
        return "calendar-portlet"
    }

    ad_proc -private get_my_name {
    } {
        return "calendar_admin_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return "#calendar-portlet.admin_pretty_name#"
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
	{-calendar_id:required}
    } {
	Adds a admin calendar PE to the given portal

	@param portal_id The page to add self to
	@param calendar_id The new calendar_id to add

	@return element_id The new element's id
    } {
        return [portal::add_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key calendar_id \
            -value $calendar_id
        ]
    }

    ad_proc -public remove_self_from_page {
	portal_id
    } {
	  Removes a calendar admin PE
    } {
        portal::remove_element \
            -portal_id $portal_id \
            -portlet_name [get_my_name]
    }

    ad_proc -public show {
	 cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf \
            -template_src "calendar-admin-portlet"
    }

}
