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
-- /calendar-portlet/sql/oracle/calendar-portlet-create.sql
--

-- Creates calendar portlet

-- Copyright (C) 2001 MIT
-- @author Arjun Sanyal (arjun@openforce.net)
-- @creation-date 2001-26-10

-- @author dan chak (chak@mit.edu)
-- ported to postgres 2002-07-09

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
         ''calendar_portlet'',
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

  -- user_editable_p 
  perform portal_datasource__set_def_param (
	ds_id,
	''t'',
	''t'',
	''user_editable_p'',
	''t''
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


    perform portal_datasource__set_def_param(
        ds_id,
        ''t'',
        ''f'',
        ''scoped_p'',
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
		''calendar_portlet'',
		''calendar_portlet''
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
	       ''calendar_portlet'',
	       ''GetMyName'',
	       ''calendar_portlet::get_my_name'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''GetPrettyName'',
	       ''calendar_portlet::get_pretty_name'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''Link'',
	       ''calendar_portlet::link'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''AddSelfToPage'',
	       ''calendar_portlet::add_self_to_page'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''Show'',
	       ''calendar_portlet::show'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''Edit'',
	       ''calendar_portlet::edit'',
	       ''TCL''
	);

	foo := acs_sc_impl_alias__new (
	       ''portal_datasource'',
	       ''calendar_portlet'',
	       ''RemoveSelfFromPage'',
	       ''calendar_portlet::remove_self_from_page'',
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
	    ''calendar_portlet''
	);

   return 0;

end;' language 'plpgsql';
select inline_0();
drop function inline_0();



create table hours_of_the_day (
    hour                        integer not null
);

insert into hours_of_the_day values (0);
insert into hours_of_the_day values (1);
insert into hours_of_the_day values (2);
insert into hours_of_the_day values (3);
insert into hours_of_the_day values (4);
insert into hours_of_the_day values (5);
insert into hours_of_the_day values (6);
insert into hours_of_the_day values (7);
insert into hours_of_the_day values (8);
insert into hours_of_the_day values (9);
insert into hours_of_the_day values (10);
insert into hours_of_the_day values (11);
insert into hours_of_the_day values (12);
insert into hours_of_the_day values (13);
insert into hours_of_the_day values (14);
insert into hours_of_the_day values (15);
insert into hours_of_the_day values (16);
insert into hours_of_the_day values (17);
insert into hours_of_the_day values (18);
insert into hours_of_the_day values (19);
insert into hours_of_the_day values (20);
insert into hours_of_the_day values (21);
insert into hours_of_the_day values (22);
insert into hours_of_the_day values (23);


\i calendar-full-portlet-create.sql
\i calendar-admin-portlet-create.sql
\i calendar-list-portlet-create.sql
