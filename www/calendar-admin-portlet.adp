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


<ul>
<li> <a href="@url@cal-item-new?calendar_id=@calendar_id@" title="#calendar-portlet.Create_a_new_Event#">#calendar-portlet.Create_a_new_Event#</a></li>
<li> <a href="@url@calendar-item-types?calendar_id=@calendar_id@" title="#calendar-portlet.lt_Manage_Calendar_Event#">#calendar-portlet.lt_Manage_Calendar_Event#</a></li>
<li> <form name="PeriodDays" action="">
     <p>
     #calendar-portlet.Parameter_Period_Days#
     <input name="period_days" type="text" size="3" maxlength="3" id="period_days" value="@period_days@">
     </form>
</ul>
