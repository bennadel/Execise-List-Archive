
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<h2>
		Delete Confirmation
	</h2>
	
	
	<!--- Check to see if there are any form error messages. --->
	<cfif REQUEST.Errors.HasMessages()>
		
		<!--- Get the messages array. --->
		<cfset REQUEST.ErrorMessages = REQUEST.Errors.GetMessages() />
		
		<div class="errors">
		
			<p>
				Please review the following errors:
			</p>
			
			<ul>
				<cfloop
					index="REQUEST.Index"
					from="1"
					to="#ArrayLen( REQUEST.ErrorMessages )#"
					step="1">
					
					<li>
						#REQUEST.ErrorMessages[ REQUEST.Index ]#
					</li>
					
				</cfloop>
			</ul>
			
		</div>
	
	</cfif>
	
	
	<p>
		Please confirm that you would like to delete the following exercise:
	</p>
	
	<p class="strongwarning">
		#REQUEST.Exercise.GetName()#
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