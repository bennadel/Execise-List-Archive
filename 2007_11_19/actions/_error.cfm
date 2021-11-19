
<!--- 
	Check to see if we want to include the header and footer. If 
	the page has already rendered (at least in part), then we don't 
	want to include the header or footer.
--->
<cfset REQUEST.IncludeHeader = (NOT GetPageContext().GetResponse().IsCommitted()) />

<!--- Include the page header if the page has not already rendered. --->
<cfif REQUEST.IncludeHeader>

	<!--- 
		Wrap the header / footer in a CFTry / CFCatch. We need to 
		do this because we are not sure where the error occurred 
		at the point of processing and therefore, we are not sure 
		that the Header file will have the required presequite 
		code executed. 
	--->
	<cftry>
		<cfinclude template="../includes/_header.cfm" />
		
		<!--- Catch any errors generated in the header. --->
		<cfcatch>
			<!--- 
				Not much we can do at this point since we can not 
				be sure WHERE the error took place.
			--->
		</cfcatch>
	</cftry>
	
</cfif>

<cfoutput>

	<h2>
		An Error Has Occurred
	</h2>
	
	<p>
		An error has occurred on the site. Our team of dedicated 
		programmers has already been alerted and is looking into it.
		Thank you for your patience in this matter.
	</p>
	
	<p>
		<a href="index.cfm?action=search">Click here</a> to search exercises.<br />
		<a href="index.cfm?action=edit">Click here</a> to add an exercise.
	</p>

</cfoutput>

<!--- Include the page footer if the page has not already rendered. --->
<cfif REQUEST.IncludeHeader>

	<!--- 
		Wrap the header / footer in a CFTry / CFCatch. We need to 
		do this because we are not sure where the error occurred 
		at the point of processing and therefore, we are not sure 
		that the Footer file will have the required presequite 
		code executed. 
	--->
	<cftry>
		<cfinclude template="../includes/_footer.cfm" />
		
		<!--- Catch any errors generated in the footer. --->
		<cfcatch>
			<!--- 
				Not much we can do at this point since we can not 
				be sure WHERE the error took place.
			--->
		</cfcatch>
	</cftry>
	
</cfif>