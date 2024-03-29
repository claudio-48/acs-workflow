<?xml version="1.0"?>

<queryset>
   <rdbms><type>postgresql</type><version>7.1</version></rdbms>

<fullquery name="create_workflow">      
      <querytext>

	select workflow__create_workflow(
            :workflow_key,
            :workflow_name, 
            :workflow_name, 
     	    :description,
  	    :workflow_cases_table,
	    'case_id'
        );

      </querytext>
</fullquery>

 
<fullquery name="constraints">      
      <querytext>

        select c.conname::text
        from pg_trigger t, pg_constraint c
        where t.tgconstraint > 0
          and c.oid          = t.tgconstraint

      </querytext>
</fullquery>

</queryset>
