<?xml version="1.0"?>

<queryset>

  <fullquery name="calendar-portlet::after_upgrade.update_portal_datasources">
    <querytext>
      update portal_datasources
      set css_dir = '/resources/calendar'
      where name like '%calendar%'
    </querytext>
  </fullquery>

  <fullquery name="calendar-portlet::after_upgrade.get_ds_id">
    <querytext>
      select datasource_id from portal_datasources 
      where name = 'calendar_portlet'
    </querytext>
  </fullquery>	
		
  <fullquery name="calendar-portlet::after_upgrade.update_default_view_param">
    <querytext>
      update portal_datasource_def_params 
      set value = 'day'
      where datasource_id = :datasource_id and key = 'default_view'
    </querytext>
  </fullquery>

  <fullquery name="calendar-portlet::after_upgrade.update_default_view_elements">
    <querytext>
      update portal_element_parameters pep
      set value = 'day'
      from portal_element_map pem
      where pep.key = 'default_view' and 
      pem.datasource_id = :datasource_id and
      pem.element_id = pep.element_id
    </querytext>
  </fullquery>

</queryset>
