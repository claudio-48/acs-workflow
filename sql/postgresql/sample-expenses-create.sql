--
-- acs-workflow/sql/sample-expenses-create.sql
--
-- Creates an expenses workflow to play with.
--
-- @author Lars Pind (lars@pinds.com)
--
-- @creation-date 2000-05-18
--
-- @cvs-id $Id: sample-expenses-create.sql,v 1.1.1.1 2005/04/27 22:50:59 cvs Exp $
--

/* This table will hold one row for each case using this workflow. */
create table wf_expenses_cases (
  case_id 		integer primary key
			constraint wf_expenses_cases_case_fk
			references wf_cases on delete cascade
);

create function inline_0 () returns integer as $sql$
declare
    v_workflow_key wf_workflows.workflow_key%TYPE;
    v_attribute_id acs_attributes.attribute_id%TYPE;
begin
    v_workflow_key := workflow__create_workflow(
	'expenses_wf', 
	'Expense Authorization', 
	'Expense authorizations', 
	'Workflow for authorizing employee''s expenses on the company''s behalf', 
	'wf_expenses_cases',
        'case_id'
    );

    /*****
     * Places
     *****/

    perform workflow__add_place(
        'expenses_wf',
        'start',
        'Start place',
        1
    );
    
    perform workflow__add_place(
        'expenses_wf',
        'assignments_done',
        'Tasks have been assigned',
        2
    );

    perform workflow__add_place(
        'expenses_wf',
        'supervisor_to_approve',
        'Supervisor is to approve',
        3
    );

    perform workflow__add_place(
        'expenses_wf',
        'other_to_approve',
        'Other is to approve',
        4
    );

    perform workflow__add_place(
        'expenses_wf',
        'supervisor_approved',
        'Supervisor has approved',
        5
    );

    perform workflow__add_place(
        'expenses_wf',
        'other_approved',
        'Other has approved',
        6
    );

    perform workflow__add_place(
        'expenses_wf',
        'ready_to_buy',
        'Both have approved',
        7
    );

    perform workflow__add_place(
        'expenses_wf',
        'end',
        'End place',
        8
    );

    /*****
     * Roles
     *****/

    perform workflow__add_role(
        'expenses_wf',
        'assignor',
        'Assignor',
        1
    );

    perform workflow__add_role(
        'expenses_wf',
        'supervisor',
        'Supervisor',
        2
    );

    perform workflow__add_role(
        'expenses_wf',
        'other',
        'Other approver',
        3
    );

    perform workflow__add_role(
        'expenses_wf',
        'requestor',
        'Requestor',
        4
    );

    /*****
     * Transitions 
     *****/

    perform workflow__add_transition(
        'expenses_wf',
        'assign',
        'Assign users to approval',
        'assignor',
        1,
        'user'
    );

    perform workflow__add_transition(
        'expenses_wf',
        'and_split',
        'Parallel approval by supervisor and other',
	null,
        2,
        'automatic'
    );

    perform workflow__add_transition(
        'expenses_wf',
        'supervisor_approval',
        'Approve (Supervisor)',
        'supervisor',
        3,
        'user'
    );

    perform workflow__add_transition(
        'expenses_wf',
        'other_approval',
        'Approve (Other)',
        'other',
        4,
        'user'
    );

    perform workflow__add_transition(
        'expenses_wf',
        'and_join',
        'Re-synchronization from approval by supervisor and other',
	null,
        5,
        'automatic'
    );

    perform workflow__add_transition(
        'expenses_wf',
        'buy',
        'Buy stuff',
        'requestor',
        6,
        'user'
    );
        
    /*****
     * Arcs 
     *****/

    perform workflow__add_arc(
        'expenses_wf',
        'start',
        'assign'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'assign',
        'assignments_done',
        null,
        null,
        null
    );

    perform workflow__add_arc(
        'expenses_wf',
        'assignments_done',
        'and_split'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'and_split',
        'supervisor_to_approve',
        null,
        null,
        null
    );

    perform workflow__add_arc(
        'expenses_wf',
        'and_split',
        'other_to_approve',
        null,
        null,
        null
    );

    perform workflow__add_arc(
        'expenses_wf',
        'supervisor_to_approve',
        'supervisor_approval'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'supervisor_approval',
        'supervisor_approved',
        null,
        null,
        null
    );

    perform workflow__add_arc(
        'expenses_wf',
        'other_to_approve',
        'other_approval'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'other_approval',
        'other_approved',
        null,
        null,
        null
    );

    perform workflow__add_arc(
        'expenses_wf',
        'supervisor_approved',
        'and_join'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'other_approved',
        'and_join'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'and_join',
        'ready_to_buy',
        'wf_expenses__guard_both_approved_p',
        null,
        'Both Supervisor and the Other approver approved'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'and_join',
        'end',
        '#',
        null,
        'Either Supervisor or the Other approver did not approve'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'ready_to_buy',
        'buy'
    );

    perform workflow__add_arc(
        'expenses_wf',
        'buy',
        'end',
        null,
        null,
        null
    );

    /*****
     * Attributes
     *****/

    v_attribute_id := workflow__create_attribute(
	'expenses_wf',
	'supervisor_ok',
	'boolean',
	'Supervisor Approval',
	null,
	null,
	null,
	'f',
	1,
	1,
        1,
        'generic'
    );

    perform workflow__add_trans_attribute_map(
        'expenses_wf',
        'supervisor_approval',
        'supervisor_ok',
        1
    );

    v_attribute_id := workflow__create_attribute(
	'expenses_wf',
	'other_ok',
	'boolean',
	'Other Approval',
	null,
	null,
	null,
	'f',
	1,
	1,
        2,
        'generic'
    );

    perform workflow__add_trans_attribute_map(
        'expenses_wf',
        'other_approval',
        'other_ok',
        1
    );

    /*****
     * Assignment
     *****/

    perform workflow__add_trans_role_assign_map(
        'expenses_wf',
        'assign',
        'supervisor'
    );

    perform workflow__add_trans_role_assign_map(
        'expenses_wf',
        'assign',
        'other'
    );

    return 0;

end;$sql$ language 'plpgsql';

select inline_0 ();

drop function inline_0 ();


/* Context stuff */

insert into wf_context_transition_info (
    context_key, workflow_key, transition_key, estimated_minutes
) values (
    'default', 'expenses_wf', 'assign', 5
);

insert into wf_context_transition_info (
    context_key, workflow_key, transition_key, hold_timeout_callback, hold_timeout_custom_arg, estimated_minutes
) values (
    'default', 'expenses_wf', 'supervisor_approval', 'wf_callback.time_sysdate_plus_x', 1/24, 15
);

insert into wf_context_transition_info (
    context_key, workflow_key, transition_key, estimated_minutes
) values (
    'default', 'expenses_wf', 'other_approval', 15
);

insert into wf_context_transition_info (
    context_key, workflow_key, transition_key, estimated_minutes
) values (
    'default', 'expenses_wf', 'buy', 30
);


insert into wf_context_task_panels (
    context_key, workflow_key, transition_key, sort_order, header, template_url
) values (
    'default', 'expenses_wf', 'supervisor_approval', 1, 'Claim Info', 'sample/expenses-claim-info'
);

insert into wf_context_task_panels (
    context_key, workflow_key, transition_key, sort_order, header, template_url
) values (
    'default', 'expenses_wf', 'supervisor_approval', 2, 'Logic and Aids', 'sample/expenses-approval-aids'
);

insert into wf_context_task_panels (
    context_key, workflow_key, transition_key, sort_order, header, template_url
) values (
    'default', 'expenses_wf', 'other_approval', 1, 'Claim Info', 'sample/expenses-claim-info'
);

insert into wf_context_task_panels (
    context_key, workflow_key, transition_key, sort_order, header, template_url
) values (
    'default', 'expenses_wf', 'other_approval', 2, 'Logic and Aids', 'sample/expenses-approval-aids'
);


/* Callbacks for the workflow */


create or replace function wf_expenses__guard_both_approved_p (
	case_id integer,
	workflow_key varchar,
	transition_key varchar,
	place_key varchar,
	direction varchar,
	custom_arg varchar
    )
    returns char as $sql$
    declare
	v_other_ok_p char(1);
	v_supervisor_ok_p char(1);
    begin
	v_other_ok_p := workflow_case__get_attribute_value(
	    case_id,
	    'other_ok'
	);
	if v_other_ok_p = 'f' then
	    return 'f';
	end if;
	v_supervisor_ok_p := workflow_case__get_attribute_value(
	    case_id,
	    'supervisor_ok'
	);
	return v_supervisor_ok_p;
    end;$sql$ language 'plpgsql';


