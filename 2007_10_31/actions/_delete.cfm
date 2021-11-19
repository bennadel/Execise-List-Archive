
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<h2>
		Delete Confirmation
	</h2>
	
	<p>
		Please confirm that you would like to delete the following exercise:
	</p>
	
	<p class="strongwarning">
		#REQUEST.Exercise.name#
	</p>
	
	<!--- 
		This could have been done with a simple link, but I decided 
		to keep with the FORM submission as an arbitrary choice.
	--->
	<form action="#CGI.script_name#" method="post">
	
		<!--- Flag that the form was submitted. --->
		<input type="hidden" name="submitted" value="1" />
		
		<!--- This is the action we are performing. --->
		<input type="hidden" name="action" value="#REQUEST.Attributes.action#" />
		
		<!--- This is the ID of the record we are looking at. --->
		<input type="hidden" name="id" value="#REQUEST.Attributes.id#" />
	
		<button type="submit">
			Delete Exercise			
		</button>
	</form>

</cfoutput>

<!--- Include the page footer. --->
<cfinclude template="../includes/_footer.cfm" />