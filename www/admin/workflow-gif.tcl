ad_page_contract {
    Generates a GIF image displaying the workflow
    
    @author Lars Pind (lars@pinds.com)
    @creation-date 22 August 2000
    @cvs-id $Id: workflow-gif.tcl,v 1.2 2001/11/19 18:29:29 neophytosd Exp $
} {
    tmpfile:notnull
} -validate {
    tmpfile_valid -requires { tmpfile:notnull } {
	if { ![string equal $tmpfile [ad_get_client_property wf wf_net_tmpfile]] } {
	    ad_complain "Bad tmpfile argument"
	}
    }
}

ns_returnfile 200 image/gif $tmpfile
file delete $tmpfile


