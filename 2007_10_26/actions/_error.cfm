
<!--- 
	Check to see if we want to include the header and footer. If 
	the page has already rendered (at least in part), then we don't 
	want to include the header or footer.
--->
<cfset REQUEST.IncludeHeader = (NOT GetPageContext().GetResponse().IsCommitted()) />

<!--- Include the page header if the page has not already rendered. --->
<cfif REQUEST.IncludeHeader>

	<cfinclude template="../includes/_header.cfm" />
	
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

	<cfinclude template="../includes/_footer.cfm" />
	
</cfif>