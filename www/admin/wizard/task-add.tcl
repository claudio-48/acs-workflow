ad_page_contract {

    @author Matthew Burke (mburke@arsdigita.com)
    @creation-date 29 August 2000
    @cvs-id $Id: task-add.tcl,v 1.1.1.1 2005/04/27 22:51:00 cvs Exp $
} -properties {
    workflow_name
    context
}

set workflow_name [ns_quotehtml [ad_get_client_property wf workflow_name]]

set context [list [list "" "Simple Process Wizard"] [list "tasks" "Tasks"] "Add task"]

ad_return_template

