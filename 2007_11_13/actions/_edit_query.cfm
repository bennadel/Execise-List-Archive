

<!--- 
	Param the key value. This is the record ID of the exercise 
	we are editing. If we have a ZERO, then we are ADDing a record, 
	otherwise we are EDITing a record.
--->
<cftry>
	<cfparam name="REQUEST.Attributes.id" type="numeric" default="0" />
	
	<cfcatch>
		<cfset REQUEST.Attributes.id = 0 />
	</cfcatch>
</cftry>

<!--- Param the attribute values. --->
<cfparam name="REQUEST.Attributes.name" type="string" default="" />
<cfparam name="REQUEST.Attributes.description" type="string" default="" />
<cfparam name="REQUEST.Attributes.contraindications" type="string" default="" />
<cfparam name="REQUEST.Attributes.alternate_names" type="string" default="" />
<cfparam name="REQUEST.Attributes.joint_id_list" type="string" default="" />

<!--- 
	NOTE: Because the joint-action relationships are dynamic (based
	on variable records in the database), we cannot param them in a
	static manner. We can only param them once we have a list of joints
	which is done later on in this page.
--->

<!--- 
	Create the form errors array. This will hold data validation 
	error messages.
--->
<cfset REQUEST.Errors = ArrayNew( 1 ) />


<!--- Query for exercise record that we are looking for.  --->
<cfset REQUEST.Exercise = APPLICATION.ServiceFactory.GetService( "ExerciseService" ).Read( REQUEST.Attributes.id ) />

<!--- 
	Check to see if we found a record. If we did not, then 
	we want to ensure that the ID we have currently needs 
	to be forced to zero (which it may already be).
--->
<cfif NOT REQUEST.Exercise.GetID()>

	<!--- Force to zero (ADDing a record). --->
	<cfset REQUEST.Attributes.id = 0 />

</cfif>



<!--- Query for available joins. --->
<cfset REQUEST.Joint = APPLICATION.ServiceFactory.GetService( "JointService" ).GetAll() />

<!--- 
	Now that we have the list of avialable joints, we can param 
	the form values for the various joint-action relationships.
--->
<cfloop query="REQUEST.Joint">
	
	<!--- 
		Each joint action parameters will encompass the three 
		aspects of the relationship:
	
		List item 1: Action
		List item 2: Plane
		List item 3: Symmetry
	--->
	<cftry>
		<cfparam 
			name="REQUEST.Attributes.joint_action_#REQUEST.Joint.id#" 
			type="regex" 
			pattern="\d+,\d+,\d+"
			default="0,0,0" 
			/>

		<cfcatch>
			<cfset "REQUEST.Attributes.joint_action_#REQUEST.Joint.id#" = "0,0,0" />
		</cfcatch>
	</cftry>
	
</cfloop>


<!--- 
	ASSERT: At this point, we have paramed all the form data and
	we are ready to either initialize or process the form data.
--->


<!--- Check to see if the form has been submitted yet. --->
<cfif REQUEST.Attributes.Submitted>

	<!---
		Now that the form has been submitted, we have to validate 
		the data.
	--->
	
	<!--- Check for a Form name. --->
	<cfif NOT Len( REQUEST.Attributes.name )>
	
		<cfset ArrayAppend( 
			REQUEST.Errors, 
			"Please enter an exercise name."
			) />
	
	</cfif>

	
	<!--- Check to see if any errors were encountered with the data. --->
	<cfif NOT ArrayLen( REQUEST.Errors )>
	
		<!--- Set the form data into the exercise. --->
		<cfset REQUEST.Exercise.SetName( REQUEST.Attributes.name ) />
		<cfset REQUEST.Exercise.SetDescription( REQUEST.Attributes.description ) />
		<cfset REQUEST.Exercise.SetContraindications( REQUEST.Attributes.contraindications ) />
		<cfset REQUEST.Exercise.SetAlternateNames( REQUEST.Attributes.alternate_names ) />
	
		<!--- 
			Now, we need to build up an array of joint aspects based 
			on what the user checked in the form.
		--->
		<cfset REQUEST.JointAspects = ArrayNew( 1 ) />
		
		<!--- Loop over the joints selected in the form. --->
		<cfloop
			index="REQUEST.JointID"
			list="#REQUEST.Attributes.joint_id_list#"
			delimiters=",">
			
			<!--- Create a new joint aspect with default values. --->
			<cfset REQUEST.JointAspect = APPLICATION.ServiceFactory.GetService( "JointAspectService" ).GetNewInstance() />
			
			<!--- Add the joint aspect to the array. --->
			<cfset ArrayAppend( REQUEST.JointAspects, REQUEST.JointAspect ) />
			
			<!--- 
				Get the joint actions for this joint. This will be a 
				list of three IDs for Action, Plane, and Symmetry.
				
				NOTE: We know that these will all be numeric based on
				our RegularExpression CFParam.
			--->
			<cfset REQUEST.JointAction = REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ] />
			
			<!--- Set the properties for the various aspects. --->
			<cfset REQUEST.JointAspect.SetJoint( APPLICATION.ServiceFactory.GetService( "JointService" ).Read( REQUEST.JointID ) ) />
			<cfset REQUEST.JointAspect.SetJointAction( APPLICATION.ServiceFactory.GetService( "JointActionService" ).Read( ListGetAt( REQUEST.JointAction, 1 ) ) ) />
			<cfset REQUEST.JointAspect.SetMovementPlane( APPLICATION.ServiceFactory.GetService( "MovementPlaneService" ).Read( ListGetAt( REQUEST.JointAction, 2 ) ) ) />
			<cfset REQUEST.JointAspect.SetMovementSymmetry( APPLICATION.ServiceFactory.GetService( "MovementSymmetryService" ).Read( ListGetAt( REQUEST.JointAction, 3 ) ) ) />
			
		</cfloop>
		
		<!--- Set the joint aspects into the exercise. --->
		<cfset REQUEST.Exercise.SetJointAspects( REQUEST.JointAspects ) />
		
		
		<!--- 
			Now that we have stored all the form values into the 
			exercise, let's commit the exercise back to the database.
		--->
		<cfset APPLICATION.ServiceFactory.GetService( "ExerciseService" ).Save( REQUEST.Exercise ) />
		
		
		<!--- 
			We have not fully processed the form data. Redirect the 
			user back to the search page.
		--->
		<cflocation
			url="#CGI.script_name#?action=search"
			addtoken="false"
			/>
		
	</cfif>

<cfelse>


	<!--- 
		The form has not yet been submitted. Default the form 
		values if we have a query to work with.
	--->
	<cfif REQUEST.Exercise.GetID()>
			
		<!--- Param basic exercise data. --->
		<cfset REQUEST.Attributes.name = REQUEST.Exercise.GetName() />
		<cfset REQUEST.Attributes.description = REQUEST.Exercise.GetDescription() />
		<cfset REQUEST.Attributes.contraindications = REQUEST.Exercise.GetContraindications() />
		<cfset REQUEST.Attributes.alternate_names = REQUEST.Exercise.GetAlternateNames() />
		
		<!--- Param the joint id list. --->
		<cfset REQUEST.Attributes.joint_id_list = "" />
		
		<!--- Get the joint aspects. --->
		<cfset REQUEST.JointAspects = REQUEST.Exercise.GetJointAspects() />
		
		<!--- Build the joint ID list. --->
		<cfloop
			index="REQUEST.JointAspectIndex"
			from="1"
			to="#ArrayLen( REQUEST.JointAspects )#"
			step="1">
			
			<!--- Add to the list of joint IDs that are selected. --->
			<cfset REQUEST.Attributes.joint_id_list = ListAppend(
				REQUEST.Attributes.joint_id_list,
				REQUEST.JointAspects[ REQUEST.JointAspectIndex ].GetJoint().GetID()
				) />
				
			<!--- Set the individual joint aspect id list. --->
			<cfset "REQUEST.Attributes.joint_action_#REQUEST.JointAspects[ REQUEST.JointAspectIndex ].GetJoint().GetID()#" = (
				REQUEST.JointAspects[ REQUEST.JointAspectIndex ].GetJointAction().GetID() & "," &
				REQUEST.JointAspects[ REQUEST.JointAspectIndex ].GetMovementPlane().GetID() & "," &
				REQUEST.JointAspects[ REQUEST.JointAspectIndex ].GetMovementSymmetry().GetID()
				) />
		
		</cfloop>

	</cfif>
	

</cfif>



<!--- 
	ASSERT: At this point, the form has been intialized or processed.
	If we have gotten this far, then we know that the form is going 
	to display. Now, we can gather any additional information that we 
	will need.
--->


<!--- Query for joint actions. --->
<cfset REQUEST.JointAction = APPLICATION.ServiceFactory.GetService( "JointActionService" ).GetAll() />

<!--- Query for movements planes. --->
<cfset REQUEST.MovementPlane = APPLICATION.ServiceFactory.GetService( "MovementPlaneService" ).GetAll() />

<!--- Query for movements symmentry. --->
<cfset REQUEST.MovementSymmetry = APPLICATION.ServiceFactory.GetService( "MovementSymmetryService" ).GetAll() />
