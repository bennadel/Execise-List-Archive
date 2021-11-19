
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


<!--- 
	Create the error collection object. This will hold data 
	validation error messages.
--->
<cfset REQUEST.Errors = APPLICATION.ServiceFactory.CreateCFC( "ErrorCollection" ).Init() />


<!--- Query for exercise record that we are looking at.  --->
<cfset REQUEST.Exercise = APPLICATION.ServiceFactory.GetService( "ExerciseService" ).Read( REQUEST.Attributes.id ) />

<!--- 
	Check to see if we found a record. If we did not, then 
	something went wrong. In that case, we cannot recover and
	must send the user back to the search page.
--->
<cfif NOT REQUEST.Exercise.GetID()>

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
		Now that the exericse instance data has been set, it's 
		time to validate the data for persistence.
	--->
	<cfset REQUEST.Errors = APPLICATION.ServiceFactory.GetService( "ExerciseService" ).ValidateSave( 
		REQUEST.Exercise,
		REQUEST.Errors
		) />
		
		
	<!--- Check to see if any errors were encountered with the data. --->
	<cfif NOT REQUEST.Errors.HasErrors()>

		<!--- 
			Delete the exercise. We are not actually physically 
			deleting exercises; we are just flagging them as deleted 
			in case they ever need to be recovered.
		--->
		<cfset APPLICATION.ServiceFactory.GetService( "ExerciseService" ).Delete( REQUEST.Exercise ) />
		
		
		<!--- 
			We have not fully processed the form data. Redirect the 
			user back to the search page.
		--->
		<cflocation
			url="#CGI.script_name#?action=search"
			addtoken="false"
			/>
			
	</cfif>
	
</cfif>