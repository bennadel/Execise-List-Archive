
<!--- 
	Param the key value. This is the record ID of the exercise 
	we are deleting.
--->
<cftry>
	<cfparam name="REQUEST.Attributes.id" type="numeric" default="0" />
	
	<cfcatch>
		<cfset REQUEST.Attributes.id = 0 />
	</cfcatch>
</cftry>


<!--- Query for exercise record that we are looking at.  --->
<cfquery name="REQUEST.Exercise" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		e.id,
		e.name
	FROM
		el_exercise e
	WHERE
		e.id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
	AND
		e.is_deleted = 0
</cfquery>

<!--- 
	Check to see if we found a record. If we did not, then 
	something went wrong. In that case, we cannot recover and
	must send the user back to the search page.
--->
<cfif NOT REQUEST.Exercise.RecordCount>

	<!--- Redirect back to search. --->
	<cflocation
		url="#CGI.script_name#?action=search"
		addtoken="false"
		/>

</cfif>



<!--- 
	Check to see if this page is being submitted. That is, the
	user has confirmed that they do indeed want to delete the 
	exercise in question.
--->
<cfif REQUEST.Attributes.submitted>

	<!--- 
		Delete the exercise. We are not actually physically 
		deleting exercises; we are just flagging them as deleted 
		in case they ever need to be recovered.
	--->
	<cfquery name="REQUEST.Exercise" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
		UPDATE
			el_exercise
		SET
			is_deleted = 1
		WHERE
			id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
	</cfquery>
	
	
	<!--- 
		We have not fully processed the form data. Redirect the 
		user back to the search page.
	--->
	<cflocation
		url="#CGI.script_name#?action=search"
		addtoken="false"
		/>

</cfif>