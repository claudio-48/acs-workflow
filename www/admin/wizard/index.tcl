ad_page_contract {
    Simple process wizard.

    @author Matthew Burke (mburke@arsdigita.com)
    @creation-date 29 August 2000
    @cvs-id $Id: index.tcl,v 1.1.1.1 2005/04/27 22:51:00 cvs Exp $
} -properties {
    context
    progress_bar
    workflow_name
    description
}

set workflow_name [ns_quotehtml [ad_get_client_property wf workflow_name]]
set description [ns_quotehtml [ad_get_client_property wf workflow_description]]

set context [list "Simple Process Wizard"]

set progress_bar [wf_progress_bar -name "Simple Process Wizard" [wf_simple_wizard_process_def] 0]

ad_return_template
