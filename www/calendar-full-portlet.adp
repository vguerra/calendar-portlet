<%

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

%>
<if @config.shaded_p@ false>

  <include src="/packages/calendar/www/navbar"
    date="@date@"
    period_days="@period_days@"
    base_url="@ad_conn_url@"
    page_num="@page_num@"
    view="@view@">
<div>
  <div id="viewadp-mini-calendar">

	<include src="/packages/calendar/www/mini-calendar" 
          view="@view@" 
          date="@date@" 
          page_num="@page_num@">
 
    <if @create_p@ or @admin_p@>
				<ul class="cal-button calendar-tools compact">
		</if>
		<if @create_p@> 
			<li><a href="@add_item_url@" title="#calendar-portlet.Add_an_item#" class="button">#calendar-portlet.Add_an_item#</a></li>
		</if>
		<if @admin_p@>
			<li><a href="calendar/calendar-item-types?calendar_id=@force_calendar_id@" title="#calendar-portlet.Manage_Item_Types#" class="button">#calendar-portlet.Manage_Item_Types#</a></li>
		</if>
    <if @create_p@ or @admin_p@>
				</ul>
		</if>   
	</div>

  <div id="viewadp-cal-table">


 <switch @view@>
   <case value="day">
     <include src="/packages/calendar/www/view-one-day-display" 
     date="@date@" 
     start_display_hour=7 
     end_display_hour=22
     page_num=@page_num@
     hour_template="@hour_template;noquote@" 
     item_template="@item_template;noquote@"
     calendar_id_list=@list_of_calendar_ids@ 
     item_add_template="@item_add_template;noquote@"
     prev_nav_template="@previous_link;noquote@"
     next_nav_template="@next_link;noquote@"
     base_url="@base_url@calendar/"
     url_stub_callback="@url_stub_callback;noquote@" 
     return_url="@encoded_return_url;noquote@">
   </case>

  <case value="list">
     <include src="/packages/calendar/www/view-list-display" 
     start_date=@start_date@ 
     end_date=@end_date@ 
     date=@current_date@ 
     period_days=@period_days@
     item_template="@item_template;noquote@"
     calendar_id_list=@list_of_calendar_ids@ 
     url_template="@url_template;noquote@" 
     url_stub_callback="@url_stub_callback;noquote@" 
     page_num=@page_num@
     return_url="@encoded_return_url;noquote@">
<a href="/ical/@publish_calendar@/dotlrn.ics?user_id=@user_id@&period_days=@period_days@&calendar_id_list=@list_of_calendar_ids@"><img border="0" src="/dotlrn
/calendar/resources/ical12x12.gif"> #calendar-portlet.Download_subscribe#</a>
  </case>
  
  <case value="week">
     <include src="/packages/calendar/www/view-week-display" 
     date="@current_date@"
     calendar_id_list=@list_of_calendar_ids@ 
     base_url="@base_url@calendar/"
     item_template="@item_template;noquote@"
     page_num=@page_num@
     prev_week_template="@prev_week_template;noquote@"
     next_week_template="@next_week_template;noquote@"
     return_url="@encoded_return_url;noquote@"
     url_stub_callback="@url_stub_callback;noquote@"
     export=@export@>
 </case>

  <case value="month">
     <include src="/packages/calendar/www/view-month-display"
     date=@current_date@
     calendar_id_list=@list_of_calendar_ids@ 
     item_template="@item_template;noquote@"
     base_url="@base_url@calendar/"
     page_num=@page_num@
     prev_month_template="@prev_month_template;noquote@"
     next_month_template="@next_month_template;noquote@"
     url_stub_callback="@url_stub_callback;noquote@"
     show_calendar_name_p="@show_calendar_name_p;noquote@"
     return_url="@encoded_return_url;noquote@"
     export=@export@>
  </case>
 </switch>
     </div>
</div>
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>
