ad_library {
    Automated tests.

    @author Mounir Lallali
    @creation-date 14 December 2005
   
}

namespace eval calendar_portlet::twt {}

ad_proc calendar_portlet::twt::get_start_end_week_date {number_week year} {
    
    set date [clock scan "$number_week weeks" -base [clock scan "01/01/$year"]]
    set st [clock scan "sunday" -base [expr {$date - 436800}]]
    set end [clock scan "saturday" -base $date]
    
    set start_week [clock format $st -format %D]
    set list_date [split $start_week /]
    set start_week "$year-[lindex $list_date 0]-[lindex $list_date 1]"

    set end_week [clock format $end -format %D]
    set list_date [split $end_week /]
    set end_week "$year-[lindex $list_date 0]-[lindex $list_date 1]"
    
    # Coverts date to display format
    set start_week [template::util::date::get_property display_date $start_week]
    set end_week [template::util::date::get_property display_date $end_week]
    
    return [list $start_week $end_week]
}

ad_proc calendar_portlet::twt::go_to_dotlrn_calendar_page_url {} {

    # The admin dotlrn page url
    set dotlrn_admin_page_url "[site_node::get_package_url -package_key dotlrn]admin"
    ::twt::do_request $dotlrn_admin_page_url

    # The calendar dotlrn page url
    set dotlrn_calendar_page_url "/dotlrn/?page_num=1"
    ::twt::do_request $dotlrn_calendar_page_url

    # Add a new user
    tclwebtest::form find ~n "add_user"
    tclwebtest::form submit
    
    tclwebtest::link follow {My Calendar}
}

ad_proc calendar_portlet::twt::follow_calendar_link {} {
    tclwebtest::link follow {My Calendar}
}

ad_proc calendar_portlet::twt::display_day {date} {

    set response 0
    
    # Display a day
    tclwebtest::link follow {Day}
    
    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/?date*view=day*page_num=1" $response_url] } {
	
	if { [catch {tclwebtest::assert text $date } errmsg]} {
	    aa_error "calendar_portlet::twt::display_day failed $errmsg : Didn't display a day"
	} else {
	    aa_log "a Day displayed"
	    set response 1
	}
        } else {
	    aa_error "calendar_portlet::twt::display_day failed, bad response url : $response_url"
        }
    return $response    
}


ad_proc calendar_portlet::twt::display_week {start_date_week end_date_week} {

    set response 0
    
    # Display a week
    tclwebtest::link follow {Week}

    set response_url [tclwebtest::response url]
    
    if { [string match  "*dotlrn/?date*view=week*page_num=1" $response_url] } {
	
	if { [catch {tclwebtest::assert text $start_date_week } errmsg] || [catch {tclwebtest::assert text $end_date_week } errmsg] } {
	    aa_error "calendar_portlet::twt::display_week failed $errmsg : Didn't display a week"
	} else {
	    aa_log "a Week displayed"
	    set response 1
	}
    } else {
	aa_error "calendar_portlet::twt::display_week failed, bad response url : $response_url"
    }
    return $response
}

ad_proc calendar_portlet::twt::display_month {date} {

    set response 0

    # Display a month
    tclwebtest::link follow {Month}

    set month [template::util::date::get_property long_month_name $date]
    set year [template::util::date::get_property year $date]
    set display_date "$month $year"

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/?date*view=month*page_num=1" $response_url] } {

        if { [catch {tclwebtest::assert text $display_date } errmsg]} {
            aa_error "calendar_portlet::twt::display_month failed $errmsg : Didn't display a month"
        } else {
            aa_log "a Month displayed"
            set response 1
        }
    } else {
            aa_error "calendar_portlet::twt::display_month failed, bad response url : $response_url"
    }
    return $response
}


ad_proc calendar_portlet::twt::item_add {item_title item_description item_date} {

    set response 0
    
    tclwebtest::link follow ~u ".*cal-item-new.+"
    
    # Add an Item in the Calendar
    tclwebtest::form find ~n "cal_item"
    tclwebtest::field find ~n "title"
    tclwebtest::field fill $item_title
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $item_description
    tclwebtest::field find ~n "date"
    tclwebtest::field fill $item_date
    tclwebtest::form submit
    
    aa_log "Add Item form submited"

    # Convert date in format mm/dd/yyyy
    set date [template::util::date::today]
    set year [template::util::date::get_property year $date]
    set short_year [string range $year 2 3]
    set month [template::util::date::get_property month $date]
    set day [template::util::date::get_property day $date]
    set item_date "$month/$day/$short_year"

    set response_url [tclwebtest::response url]
    
    if { [string match  "*cal-item-view*" $response_url] } {
	
	if { [catch {tclwebtest::assert text $item_title} errmsg] || [catch {tclwebtest::assert text $item_description} errmsg] || [catch {tclwebtest::assert text $item_date} errmsg]} {
	    aa_error "calendar_portlet::twt::item_add failed $errmsg : Didn't add a New Item"
	} else {
	    aa_log "a New Item added"
	    set response 1
	}
    } else {
	aa_error "calendar_portlet::twt::item_add failed, bad response url : $response_url"
    }
    return $response
}

ad_proc calendar_portlet::twt::item_edit {item_title item_new_title item_new_description item_date} {

    set response 0

    tclwebtest::link follow {Day}

    # Edit en item in the Calendar
    tclwebtest::link follow "$item_title*"       
    tclwebtest::link follow "Edit"
   
    tclwebtest::form find ~n "cal_item"
    tclwebtest::field find ~n "title"
    tclwebtest::field fill $item_new_title
    tclwebtest::field find ~n "description"
    tclwebtest::field fill $item_new_description
    tclwebtest::form submit

    aa_log "Edit Item form submited"

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/calendar/view" $response_url] } {
	
	tclwebtest::link follow {My Calendar}
	
        if { [catch {tclwebtest::assert text $item_new_title} errmsg]} {
            aa_error "calendar_portlet::twt::item_edit failed $errmsg : Didn't Edit an Item"
        } else {
            aa_log "an Item edited"
            set response 1
        }
    } else {
        aa_error "calendar_portlet::twt::item_edit failed, bad response url : $response_url"
    }

    return $response
}

ad_proc calendar_portlet::twt::item_delete {item_title} {

    set response 0

    tclwebtest::link follow {Day}

    # Edit en item in the Calendar
    tclwebtest::link follow "$item_title*"
    tclwebtest::link follow "Delete"
    tclwebtest::link follow  {yes, delete it} 

    aa_log "Delete Item form submited"

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/calendar/view" $response_url] } {

        tclwebtest::link follow {My Calendar}

        if {![catch {tclwebtest::assert text $item_title} errmsg]} {
            aa_error "calendar_portlet::twt::item_delete failed $errmsg : Didn't Delete an Item"
        } else {
            aa_log "an Item deleted"
            set response 1
        }
    } else {
        aa_error "calendar_portlet::twt::item_delete failed, bad response url : $response_url"
    }

    return $response
}

ad_proc calendar_portlet::twt::item_display_list {item_title_1 item_title_2 item_title_3} {

    set response 0

    # Display item list in calendar
    tclwebtest::link follow {List}
    
    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn*view=list*" $response_url] } {
	
        if {[catch {tclwebtest::assert text $item_title_1 } errmsg] || [catch {tclwebtest::assert text $item_title_2 } errmsg] || [catch {tclwebtest::assert text $item_title_3 } errmsg]} {
            aa_error "calendar_portlet::twt::item_display_list failed $errmsg : Didn't Display an Item List"
        } else {
            aa_log "an Item List displayed"
            set response 1
        }
    } else {
        aa_error "calendar_portlet::twt::item_display_list failed, bad response url : $response_url"
    }

    return $response
}

ad_proc calendar_portlet::twt::request_notification {} {

    set response 0
    
    # Subscribe Request notification
    tclwebtest::link follow "list"
    tclwebtest::link follow {request notification}
    
    tclwebtest::form find ~n subscribe
    tclwebtest::form submit

    aa_log "Confirm Request notification"

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/calendar/view" $response_url] } {

	if {[catch {tclwebtest::assert text unsubscribe } errmsg]} {
	    aa_error "calendar_portlet::twt::request_notification failed $errmsg : Didn't Request a Notification for Calendar"
	} else {
	    aa_log "Calendar Notification requested"
	    set response 1
	}
    } else {
        aa_error "calendar_portlet::twt::request_notification failed, bad response url : $response_url"
    }
    
    return $response
}

ad_proc calendar_portlet::twt::unsubscribe {} {

    set response 0

    # Unsubscribe request notification
    tclwebtest::link follow "list"
    tclwebtest::link follow {unsubscribe}

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/calendar/view" $response_url] } {

        if {![catch {tclwebtest::assert text unsubscribe } errmsg]} {
            aa_error "calendar_portlet::twt::unsubscribe failed $errmsg : Didn't unsubscribe a Notification for Calendar"
        } else {
            aa_log "Calendar Notification unsubscribed"
            set response 1
        }
    } else {
        aa_error "calendar_portlet::twt::unsubscribe failed, bad response url : $response_url"
    }

    return $response
}

ad_proc calendar_portlet::twt::display_date {date} {

    set response 0

    set given_date [template::util::date::get_property linear_date_no_time $date]
    set given_date  "[join  $given_date {} ]"
    set display_date [template::util::date::get_property display_date $date]

    # Get date to go
    tclwebtest::form find ~a {/dotlrn/} ~m get
    tclwebtest::field find ~n date
    tclwebtest::field fill $given_date    
    tclwebtest::form submit
    aa_log "Get date form submited"

    set response_url [tclwebtest::response url]

    if { [string match  "*dotlrn/\?date*view=day*page*num=1*" $response_url] } {

        if { [catch {tclwebtest::assert text $display_date } errmsg]} {
            aa_error "calendar_portlet::twt::display_day failed $errmsg : Didn't display a day"
        } else {
            aa_log "a Day displayed"
            set response 1
        }
    } else {
            aa_error "calendar_portlet::twt::display_day failed, bad response url : $response_url"
    }
    return $response
}
