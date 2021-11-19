
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<ul class="pageactions">
		<li>
			<a href="#CGI.script_name#?action=edit&id=#REQUEST.Exercise.GetID()#">Edit</a>
		</li>
		<li>
			<a href="#CGI.script_name#?action=delete&id=#REQUEST.Exercise.GetID()#">Delete</a>
		</li>
	</ul>

	
	<h2>
		#REQUEST.Exercise.GetName()#
	</h2>
	
	
	<!--- Check for description. --->
	<cfif Len( REQUEST.Exercise.GetDescription() )>
		
		<p>
			#REQUEST.Exercise.GetDescription()#
		</p>
	
	</cfif>
	
	
	<!--- Check for joint actions. --->
	<cfif ArrayLen( REQUEST.Exercise.GetJointAspects() )>
	
		<!--- Get the joint aspects. --->
		<cfset REQUEST.JointAspects = REQUEST.Exercise.GetJointAspects() />
	
	
		<h3>
			Joint Actions
		</h3>
		
		<ul>
			<cfloop 
				index="REQUEST.JointApsectIndex"
				from="1"
				to="#ArrayLen( REQUEST.JointAspects )#"
				step="1">
				
				<!--- Get the joint aspect. --->
				<cfset REQUEST.JointAspect = REQUEST.JointAspects[ REQUEST.JointApsectIndex ] />
				
				<li>
					#REQUEST.JointAspect.GetMovementSymmetry().GetName()#
					#REQUEST.JointAspect.GetJoint().GetName()#
					#REQUEST.JointAspect.GetJointAction().GetName()#
					
					<cfif REQUEST.JointAspect.GetMovementPlane().GetID()>
						in the #REQUEST.JointAspect.GetMovementPlane().GetName()# plane
					</cfif>
				</li>
			
			</cfloop>		
		</ul>
	
	</cfif>
	
	
	<!--- Check for contraindications. --->
	<cfif Len( REQUEST.Exercise.GetContraindications() )>
		
		<h3>
			Contraindications
		</h3>
		
		<p>
			#REQUEST.Exercise.GetContraindications()#
		</p>
	
	</cfif>
	
	
	<!--- Check for alternate names. --->
	<cfif Len( REQUEST.Exercise.GetAlternateNames() )>
		
		<h3>
			Alternate Names
		</h3>
		
		<p>
			#REQUEST.Exercise.GetAlternateNames()#
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