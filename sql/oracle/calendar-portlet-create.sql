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

-- $Id$

-- This is free software distributed under the terms of the GNU Public
-- License version 2 or higher.  Full text of the license is available
-- from the GNU Project: http://www.fsf.org/copyleft/gpl.html

declare
  ds_id portal_datasources.datasource_id%TYPE;
begin
  ds_id := portal_datasource.new(
    name             => 'calendar_portlet',
    description      => 'Displays the calendar ',
    css_dir          => '/resources/calendar'
  );

  
  --  the standard 4 params

  -- shadeable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'shadeable_p',
	value => 't'
);	


  -- hideable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'hideable_p',
	value => 't'
);	

  -- user_editable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'user_editable_p',
	value => 't'
);	

  -- shaded_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'shaded_p',
	value => 'f'
);	

  -- link_hideable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'link_hideable_p',
	value => 't'
);	


    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 'f',
        key => 'scoped_p',
        value => 't'
    );


  -- calendar-specific params

  -- calendar_id must be configured 
  portal_datasource.set_def_param (
	  datasource_id => ds_id,
	  config_required_p => 't',
	  configured_p => 'f',
	  key => 'calendar_id',
	  value => ''
);


  -- default_view see cal-table-create.sql
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'default_view',
	value => 'day'
);	


  -- default_view see cal-table-create.sql
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'group_calendar_id',
	value => NULL
);	

-- XXX community calendars

end;
/
show errors

declare
	foo integer;
begin
	-- create the implementation
	foo := acs_sc_impl.new (
		impl_contract_name => 'portal_datasource',
		impl_name => 'calendar_portlet',
		impl_pretty_name => 'Calendar Portlet',
		impl_owner_name => 'calendar_portlet'
	);

end;
/
show errors

declare
	foo integer;
begin

	-- add all the hooks
	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'GetMyName',
	       'calendar_portlet::get_my_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'GetPrettyName',
	       'calendar_portlet::get_pretty_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'Link',
	       'calendar_portlet::link',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'AddSelfToPage',
	       'calendar_portlet::add_self_to_page',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'Show',
	       'calendar_portlet::show',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'Edit',
	       'calendar_portlet::edit',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_portlet',
	       'RemoveSelfFromPage',
	       'calendar_portlet::remove_self_from_page',
	       'TCL'
	);

end;
/
show errors

declare
	foo integer;
begin

	-- Add the binding
	acs_sc_binding.new (
	    contract_name => 'portal_datasource',
	    impl_name => 'calendar_portlet'
	);
end;
/
show errors

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


@calendar-full-portlet-create.sql
@calendar-admin-portlet-create.sql
@calendar-list-portlet-create.sql
