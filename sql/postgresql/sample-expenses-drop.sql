--
-- acs-workflow/sql/sample-expenses-drop.sql
--
-- Drops the expenses workflow.
--
-- @author Lars Pind (lars@pinds.com)
--
-- @creation-date 2000-05-18
--
-- @cvs-id $Id: sample-expenses-drop.sql,v 1.1.1.1 2005/04/27 22:50:59 cvs Exp $
--

begin;

select workflow__delete_cases('expenses_wf');

drop table wf_expenses_cases;

select workflow__drop_workflow('expenses_wf');

end;


