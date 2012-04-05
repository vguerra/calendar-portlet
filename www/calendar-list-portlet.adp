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

<if @config.shaded_p@ ne "t">
  <include src="/packages/calendar/www/view-list-display" 
  start_date=@start_date@ 
  end_date=@end_date@ 
  date=@current_date@ 
  period_days=@period_days@
  item_template="@item_template;noquote@"
  page_num=@page_num@
  calendar_id_list=@list_of_calendar_ids@ 
  url_template="@url_template;noquote@" 
  url_stub_callback="@url_stub_callback;noquote@" 
  sort_by=@sort_by@
  frmdays="frmdays_list_portlet"> 
</if>
<else>
  <small>
    #new-portal.when_portlet_shaded#
  </small>
</else>