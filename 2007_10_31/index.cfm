
<!--- 
	Check to see which action we are performing. This will 
	determine which files to include.
--->
<cfswitch expression="#REQUEST.Attributes.Action#">

	<cfcase value="delete">
		<cfinclude template="./actions/_delete_query.cfm" />
		<cfinclude template="./actions/_delete.cfm" />
	</cfcase>
	
	<cfcase value="edit">
		<cfinclude template="./actions/_edit_query.cfm" />
		<cfinclude template="./actions/_edit.cfm" />
	</cfcase>
	
	<cfcase value="view">
		<cfinclude template="./actions/_view_query.cfm" />
		<cfinclude template="./actions/_view.cfm" />
	</cfcase>

	<!--- Default action is search page. --->
	<cfdefaultcase>
		<cfinclude template="./actions/_search_query.cfm" />
		<cfinclude template="./actions/_search.cfm" />
	</cfdefaultcase>

</cfswitch>
