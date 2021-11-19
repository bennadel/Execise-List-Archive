
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<ul class="pageactions">
		<li>
			<a href="#CGI.script_name#?action=edit&id=#REQUEST.Exercise.id#">Edit</a>
		</li>
		<li>
			<a href="#CGI.script_name#?action=delete&id=#REQUEST.Exercise.id#">Delete</a>
		</li>
	</ul>

	
	<h2>
		#REQUEST.Exercise.name#
	</h2>
	
	
	<!--- Check for description. --->
	<cfif Len( REQUEST.Exercise.description )>
		
		<p>
			#REQUEST.Exercise.description#
		</p>
	
	</cfif>
	
	
	<!--- Check for joint actions. --->
	<cfif REQUEST.JointAction.RecordCount>
	
		<h3>
			Joint Actions
		</h3>
		
		<ul>
			<cfloop query="REQUEST.JointAction">
				
				<li>
					#REQUEST.JointAction.movement_symmetry_name#
					#REQUEST.JointAction.joint_name#
					#REQUEST.JointAction.joint_action_name#
					
					<cfif Len( REQUEST.JointAction.movement_plane_name )>
						in the #REQUEST.JointAction.movement_plane_name# plane
					</cfif>
				</li>
			
			</cfloop>		
		</ul>
	
	</cfif>
	
	
	<!--- Check for contraindications. --->
	<cfif Len( REQUEST.Exercise.contraindications )>
		
		<h3>
			Contraindications
		</h3>
		
		<p>
			#REQUEST.Exercise.contraindications#
		</p>
	
	</cfif>
	
	
	<!--- Check for alternate names. --->
	<cfif Len( REQUEST.Exercise.alternate_names )>
		
		<h3>
			Alternate Names
		</h3>
		
		<p>
			#REQUEST.Exercise.alternate_names#
		</p>
	
	</cfif>
	
	
	<!--- Check for related exercises. --->
	<cfif REQUEST.RelatedExercise.RecordCount>
	
		<h3>
			Related Exercises by Joint Actions
		</h3>
		
		<ul>
			<cfloop query="REQUEST.RelatedExercise">
				
				<li>
					<a href="#CGI.script_name#?action=view&id=#REQUEST.RelatedExercise.id#">#REQUEST.RelatedExercise.name#</a>
				</li>
			
			</cfloop>		
		</ul>
	
	</cfif>
	
</cfoutput>

<!--- Include the page footer. --->
<cfinclude template="../includes/_footer.cfm" />