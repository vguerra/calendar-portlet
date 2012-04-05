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

    Procedures to support the (normal, narrow) calendar portlet a.k.a.
    "Day Summary". Not to be confused with the "full" calendar portlet.

    @author arjun@openforce.net
    @cvs-id $Id$

}

namespace eval calendar_portlet {

    ad_proc -private my_package_key {
    } {
        return "calendar-portlet"
    }

    ad_proc -private get_my_name {
    } {
        return "calendar_portlet"
    }

    ad_proc -public get_pretty_name {
    } {
        return [parameter::get_from_package_key \
                    -package_key [my_package_key] \
                    -parameter pretty_name]
    }

    ad_proc -public link {
    } {
	return ""
    }

    ad_proc -public add_self_to_page {
	{-portal_id:required}
	{-calendar_id:required}
        {-page_name ""}
        {-pretty_name ""}
        {-force_region ""}
	{-scoped_p ""}
	{-param_action "overwrite"}
    } {
	Adds a (normal) calendar PE to the given page or appends a
        calendar_id to the current calendar portlet

	@param portal_id The page to add self to
	@param calendar_id The new calendar_id to add

	@return element_id The new element's id
    } {
        
        # allow overrides of pretty_name and force_region
        if {[empty_string_p $pretty_name]} {
            set pretty_name [get_pretty_name]
        }

        if {[empty_string_p $force_region]} {
            set force_region [parameter::get_from_package_key \
                                  -package_key [my_package_key] \
                                  -parameter "force_region"
            ]
        }

        set extra_params ""
        if {![empty_string_p $scoped_p]} {
            set extra_params [list scoped_p $scoped_p]
        }
        
        return [portal::add_element_parameters \
                    -portal_id $portal_id \
                    -page_name $page_name \
                    -portlet_name [get_my_name] \
                    -pretty_name $pretty_name \
                    -force_region $force_region \
                    -key calendar_id \
                    -value $calendar_id \
                    -param_action $param_action \
                    -extra_params $extra_params
        ]
    }

    ad_proc -public remove_self_from_page {
	{-portal_id:required}
        {-calendar_id:required}
    } {
        Removes a calendar PE from the given page or just
        the given calendar_id

	  @param portal_id The page to remove self from
	  @param calendar_id
    } {
        portal::remove_element_parameters \
            -portal_id $portal_id \
            -portlet_name [get_my_name] \
            -key calendar_id \
            -value $calendar_id
    }

    ad_proc -public show {
	 cf
    } {
    } {
        portal::show_proc_helper \
            -package_key [my_package_key] \
            -config_list $cf
    }

}
