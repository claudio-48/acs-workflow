ad_page_contract {
    Displays the user's task list.

    @author Lars Pind (lars@pinds.com)
    @creation-date 13 July 2000
    @cvs-id $Id: index.tcl,v 1.2 2006/04/07 22:47:07 cvs Exp $
} -properties {
    context
    admin_p
}

# branch one comment
# commento git main

set user_id [auth::require_login]
set admin_p [permission::permission_p -object_id [ad_conn package_id] -privilege "admin"]

set context [list]

ad_return_template
