--
--  Copyright (C) 2001, 2002 MIT
--
--  This file is part of dotLRN.
--
--  dotLRN is free software; you can redistribute it and/or modify it under the
--  terms of the GNU General Public License as published by the Free Software
--  Foundation; either version 2 of the License, or (at your option) any later
--  version.
--
--  dotLRN is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
--  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
--  details.
--

--
-- /calendar-portlet/sql/oracle/calendar-full-portlet-create.sql
--

-- Creates calendar portlet

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)
-- @author Ben Adida (ben@openforce)
-- @creation-date 2002-02-10

-- @author dan chak (chak@openforce.net)
-- ported to postres 2002-07-09

-- $Id$

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html

create function inline_0()
returns integer as '
declare
  ds_id portal_datasources.datasource_id%TYPE;
begin
  ds_id := portal_datasource__new(
         ''calendar_full_portlet'',
         ''Displays the calendar '',
         ''/resources/calendar''
  );

  
  --  the standard 4 params

  -- shadeable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''shadeable_p'',
	''t''
);	


  -- hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''hideable_p'',
	''t''
);	

    perform portal_datasource__set_def_param(
        ds_id,
        ''t'',
        ''f'',
        ''scoped_p'',
        ''t''
    );

  -- user_editable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''user_editable_p'',
	''f''
);	

  -- shaded_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''shaded_p'',
	''f''
);	

  -- link_hideable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''link_hideable_p'',
	''t''
);	


  -- calendar-specific params

  -- calendar_id must be configured 
  perform portal_datasource__set_def_param (
	  ds_id,
	  ''t'',
	  ''f'',
	  ''calendar_id'',
	  ''''
);


  -- default_view see cal-table-create__sql
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''default_view'',
	''day''
);	


  -- default_view see cal-table-create__sql
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''group_calendar_id'',
	NULL
);	

-- XXX community calendars

   return 0;

end;' language 'plpgsql';
select inline_0();
drop function inline_0();



create function inline_0()
returns integer as '
declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl__new (
		''portal_datasource'',
		''calendar_full_portlet'',
		''calendar_full_portlet''
	);

   return 0;

end;' language 'plpgsql';
select inline_0();
drop function inline_0();



create function inline_0()
returns integer as '
declare
	foo integer;
begin

	-- add all the hooks
	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''GetMyName'',
	       ''calendar_full_portlet::get_my_name'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''GetPrettyName'',
	       ''calendar_full_portlet::get_pretty_name'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''Link'',
	       ''calendar_full_portlet::link'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''AddSelfToPage'',
	       ''calendar_full_portlet::add_self_to_page'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''Show'',
	       ''calendar_full_portlet::show'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''Edit'',
	       ''calendar_full_portlet::edit'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_full_portlet'',
	       ''RemoveSelfFromPage'',
	       ''calendar_full_portlet::remove_self_from_page'',
	       ''TCL''
	);

   return 0;

end;' language 'plpgsql';
select inline_0();
drop function inline_0();



create function inline_0()
returns integer as '
declare
	foo integer;
begin

	-- Add the binding
	perform acs_sc_binding__new (
	    ''portal_datasource'',
	    ''calendar_full_portlet''
	);

   return 0;

end;' language 'plpgsql';
select inline_0();
drop function inline_0();
