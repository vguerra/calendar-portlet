ad_library {
    Automated tests.
    @author Mounir Lallali
    @creation-date 14 December 2005

}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_display_day {

    Test Display a Day in Calendar

    @author Mounir Lallali
} {
    aa_run_with_teardown -test_code {

	tclwebtest::cookies clear
	# Login user
	array set user_info [twt::user::create -admin]
	twt::user::login $user_info(email) $user_info(password)

	calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set date [template::util::date::today]
	set date [template::util::date::get_property display_date $date]
	
	set response [calendar_portlet::twt::display_day $date]
	aa_display_result -response $response -explanation {Webtest for displaying a current day in the calendar}
	
	twt::user::logout
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_display_week {

    Test Display a Week in Calendar
    
    @author Mounir Lallali
} {
    aa_run_with_teardown -test_code {
	
	tclwebtest::cookies clear
	# Login user
	array set user_info [twt::user::create -admin]
	twt::user::login $user_info(email) $user_info(password)
	
	calendar_portlet::twt::go_to_dotlrn_calendar_page_url
	
	# Get Start and End date Week
        set date [template::util::date::today]
	set year [template::util::date::get_property year $date]
	set number_week [expr [clock format [clock scan now] -format %W]-1]	
	
	set start_end_date_week [calendar_portlet::twt::get_start_end_week_date $number_week $year] 

        set start_date_week [lindex $start_end_date_week 0]
	set end_date_week [lindex $start_end_date_week 1]

	# Display week
	set response [calendar_portlet::twt::display_week $start_date_week $end_date_week ]
	aa_display_result -response $response -explanation {Webtest for displaying a current week in the calendar}
	
	twt::user::logout
    }
}


aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_display_month {

    Test Display a Month in Calendar

    @author Mounir Lallali
} {
    aa_run_with_teardown -test_code {

        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)

        calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set date [template::util::date::today]

        set response [calendar_portlet::twt::display_month $date]
        aa_display_result -response $response -explanation {Webtest for displaying a current month in the calendar}

        twt::user::logout
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_item_add {

    Test Add an Item in Calendar
    
    @author Mounir Lallali
} {
        
    aa_run_with_teardown -test_code {

	tclwebtest::cookies clear
	# Login user
	array set user_info [twt::user::create -admin]
	twt::user::login $user_info(email) $user_info(password)
	
	calendar_portlet::twt::go_to_dotlrn_calendar_page_url

	set item_title [ad_generate_random_string]
	set item_description [ad_generate_random_string]
	
	set date [template::util::date::today]
	set item_date [template::util::date::get_property linear_date_no_time $date]

	set response [calendar_portlet::twt::item_add $item_title $item_description $item_date]
	aa_display_result -response $response -explanation {Webtest for addting an item in the calendar}
	
	twt::user::logout
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_item_edit {

    Test Edit an Item in Calendar
    
    @author Mounir Lallali
} {
    
    aa_run_with_teardown -test_code {
	
        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)
	
	calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set item_title [ad_generate_random_string]
        set item_description [ad_generate_random_string]
	
        set date [template::util::date::today]
        set item_date [template::util::date::get_property linear_date_no_time $date]

	calendar_portlet::twt::item_add $item_title $item_description $item_date
	
	set item_new_title [ad_generate_random_string]
        set item_new_description [ad_generate_random_string]
	
        set response [calendar_portlet::twt::item_edit $item_title $item_new_title $item_new_description $item_date]
        aa_display_result -response $response -explanation {Webtest for editing an item in the calendar}
	
        twt::user::logout
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_item_delete {

    Test Delete an Item in Calendar

    @author Mounir Lallali
} {

    aa_run_with_teardown -test_code {

        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)

	calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set item_title [ad_generate_random_string]
        set item_description [ad_generate_random_string]

        set date [template::util::date::today]
        set item_date [template::util::date::get_property linear_date_no_time $date]

        calendar_portlet::twt::item_add $item_title $item_description $item_date

        set item_new_title [ad_generate_random_string]
        set item_new_description [ad_generate_random_string]

        set response [calendar_portlet::twt::item_delete $item_title]
        aa_display_result -response $response -explanation {Webtest for deleting an item in the calendar}

        twt::user::logout
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_calendar_portlet_item_display_list {

    Test Display an Item List in Calendar

    @author Mounir Lallali
} {

    aa_run_with_teardown -test_code {

        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)

	calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set item_title_1 [ad_generate_random_string]
        set item_description_1 [ad_generate_random_string]
	
        set item_title_2 [ad_generate_random_string]
        set item_description_2 [ad_generate_random_string]

        set item_title_3 [ad_generate_random_string]
        set item_description_3 [ad_generate_random_string]

        set date [template::util::date::today]
        set item_date [template::util::date::get_property linear_date_no_time $date]

        calendar_portlet::twt::item_add $item_title_1 $item_description_1 $item_date
	calendar_portlet::twt::follow_calendar_link        

	calendar_portlet::twt::item_add $item_title_2 $item_description_2 $item_date
	calendar_portlet::twt::follow_calendar_link
	
	calendar_portlet::twt::item_add $item_title_3 $item_description_3 $item_date

        set response [calendar_portlet::twt::item_display_list $item_title_1 $item_title_2 $item_title_3]
        aa_display_result -response $response -explanation {Webtest for displaying an item list in the calendar}

        twt::user::logout
    }
}


aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_request_notification {

    Test Request a Notification for Calendar
    
    @author Mounir Lallali
} {
    
    aa_run_with_teardown -test_code {
	
        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)
	
        calendar_portlet::twt::go_to_dotlrn_calendar_page_url

	set item_title [ad_generate_random_string]
        set item_description [ad_generate_random_string]

        set date [template::util::date::today]
        set item_date [template::util::date::get_property linear_date_no_time $date]

        calendar_portlet::twt::item_add $item_title $item_description $item_date

	set response [calendar_portlet::twt::request_notification]
        aa_display_result -response $response -explanation {Webtest for requesting a notification for calendar}
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_unsubscribe {

    Test Unsubscribe a Notification for Calendar

    @author Mounir Lallali
} {

    aa_run_with_teardown -test_code {

        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)

        calendar_portlet::twt::go_to_dotlrn_calendar_page_url

        set item_title [ad_generate_random_string]
        set item_description [ad_generate_random_string]

        set date [template::util::date::today]
        set item_date [template::util::date::get_property linear_date_no_time $date]

        calendar_portlet::twt::item_add $item_title $item_description $item_date

        calendar_portlet::twt::request_notification
	set response [calendar_portlet::twt::unsubscribe]
        aa_display_result -response $response -explanation {Webtest for unsubscribing a notification for calendar}
    }
}

aa_register_case -cats {web smoke} -libraries tclwebtest tclwebtest_display_date {

    Test Display a Date in The Calendar

    @author Mounir Lallali
} {

    aa_run_with_teardown -test_code {

        tclwebtest::cookies clear
        # Login user
        array set user_info [twt::user::create -admin]
        twt::user::login $user_info(email) $user_info(password)

        calendar_portlet::twt::go_to_dotlrn_calendar_page_url
	set date [template::util::date::today]
     
	set response [calendar_portlet::twt::display_date $date]
        aa_display_result -response $response -explanation {Webtest for unsubscribing a notification for calendar}

    }
}