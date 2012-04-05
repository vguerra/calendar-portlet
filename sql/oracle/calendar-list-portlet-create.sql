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

-- $Id$

declare
  ds_id portal_datasources.datasource_id%TYPE;
begin
  ds_id := portal_datasource.new(
    name             => 'calendar_list_portlet',
    description      => 'Displays the calendar list as a schedule',
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

    portal_datasource.set_def_param(
        datasource_id => ds_id,
        config_required_p => 't',
        configured_p => 'f',
        key => 'scoped_p',
        value => 't'
    );

  -- user_editable_p 
  portal_datasource.set_def_param (
	datasource_id => ds_id,
	config_required_p => 't',
	configured_p => 't',
	key => 'user_editable_p',
	value => 'f'
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
		impl_name => 'calendar_list_portlet',
		impl_pretty_name => 'Calendar List POrtlet',
		impl_owner_name => 'calendar_list_portlet'
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
	       'calendar_list_portlet',
	       'GetMyName',
	       'calendar_list_portlet::get_my_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'GetPrettyName',
	       'calendar_list_portlet::get_pretty_name',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'Link',
	       'calendar_list_portlet::link',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'AddSelfToPage',
	       'calendar_list_portlet::add_self_to_page',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'Show',
	       'calendar_list_portlet::show',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'Edit',
	       'calendar_list_portlet::edit',
	       'TCL'
	);

	foo := acs_sc_impl.new_alias (
	       'portal_datasource',
	       'calendar_list_portlet',
	       'RemoveSelfFromPage',
	       'calendar_list_portlet::remove_self_from_page',
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
	    impl_name => 'calendar_list_portlet'
	);
end;
/
show errors

