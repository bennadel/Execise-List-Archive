
<!--- Param the attribute values. --->
<cfparam name="REQUEST.Attributes.keywords" type="string" default="" />
<cfparam name="REQUEST.Attributes.joint_id_list" type="string" default="" />

<!--- 
	NOTE: Because the joint-action relationships are dynamic (based
	on variable records in the database), we cannot param them in a
	static manner. We can only param them once we have a list of joints
	which is done below.
--->
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


<!--- 
	Check to see if the form has been submitted yet. Since 
	this is just a search form, there is really no need for 
	initialization, just processing.
--->
<cfif REQUEST.Attributes.Submitted>

	<!--- 
		For searching, we need to create an array of Join Aspects 
		on which to search.
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
	
		
	<!--- Query for matching exercises. --->
	<cfset REQUEST.Exercise = APPLICATION.ServiceFactory.GetService( "ExerciseService" ).Search(
		Keywords = REQUEST.Attributes.keywords,
		JointAspects = REQUEST.JointAspects
		) />
	
</cfif>


<!--- 
	ASSERT: At this point, the form has been intialized or processed.
	Now, we can gather any additional information that we will need
	for display, not processing.
--->


<!--- Query for joint actions. --->
<cfset REQUEST.JointAction = APPLICATION.ServiceFactory.GetService( "JointActionService" ).GetAll() />

<!--- Query for movements planes. --->
<cfset REQUEST.MovementPlane = APPLICATION.ServiceFactory.GetService( "MovementPlaneService" ).GetAll() />

<!--- Query for movements symmentry. --->
<cfset REQUEST.MovementSymmetry = APPLICATION.ServiceFactory.GetService( "MovementSymmetryService" ).GetAll() />