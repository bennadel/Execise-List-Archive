

<!--- 
	Param the key value. This is the record ID of the exercise 
	we are viewing.
--->
<cftry>
	<cfparam name="REQUEST.Attributes.id" type="numeric" default="0" />
	
	<cfcatch>
		<cfset REQUEST.Attributes.id = 0 />
	</cfcatch>
</cftry>


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


<!--- Query for related exercises. --->
<cfset REQUEST.RelatedExercise = APPLICATION.ServiceFactory.GetService( "ExerciseService" ).GetRelatedExercises( 
	REQUEST.Exercise 
	) />