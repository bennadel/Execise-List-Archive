
<!--- Param the attribute values. --->
<cfparam name="REQUEST.Attributes.keywords" type="string" default="" />
<cfparam name="REQUEST.Attributes.joint_id_list" type="string" default="" />

<!--- 
	NOTE: Because the joint-action relationships are dynamic (based
	on variable records in the database), we cannot param them in a
	static manner. We can only param them once we have a list of joints
	which is done below.
--->

<!--- Query for available joins. --->
<cfquery name="REQUEST.Joint" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		j.id,
		j.name
	FROM
		el_joint j
	ORDER BY
		j.sort ASC,
		j.name ASC
</cfquery>

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

	<!--- Query for matching exercises. --->
	<cfquery name="REQUEST.Exercise" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
		DECLARE @keywords VARCHAR( 100 );
		
		<!--- 
			Store keywords here so that we can reference multiple 
			times without the query param. 
		--->
		SET @keywords = <cfqueryparam value="#REQUEST.Attributes.keywords#" cfsqltype="cf_sql_varchar" />
		
	
		SELECT
			e.id,
			e.name,
			e.description
		FROM
			el_exercise e	
		WHERE
			e.is_deleted = 0
			
		<!--- Check for keywords. --->
		<cfif Len( REQUEST.Attributes.keywords )>
			
			AND
				(
						CHARINDEX( @keywords, e.name ) > 0
					OR
						CHARINDEX( @keywords, e.description ) > 0
					OR
						CHARINDEX( @keywords, e.contraindications ) > 0
					OR
						CHARINDEX( @keywords, e.alternate_names ) > 0
				)
		
		</cfif>
		
			
		<!--- Loop over the joints that we want to search on. --->
		<cfloop
			index="REQUEST.JointID"
			list="#REQUEST.Attributes.joint_id_list#"
			delimiters=",">
		
			<!--- 
				Get the joint actions for this joint. This will be a 
				list of three IDs for Action, Plane, and Symmetry.
				
				NOTE: We know that these will all be numeric based on
				our RegularExpression CFParam.
			--->
			<cfset REQUEST.JointAction = REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ] />
			
			<!--- Break out the parts. --->
			<cfset REQUEST.JointActionID = ListGetAt( REQUEST.JointAction, 1 ) />
			<cfset REQUEST.MovementPlaneID = ListGetAt( REQUEST.JointAction, 2 ) />
			<cfset REQUEST.MovementSymmetryID = ListGetAt( REQUEST.JointAction, 3 ) />
		
			AND
				EXISTS
				(
					SELECT
						1
					FROM
						el_exercise_joint_jn ejjn
					WHERE
						ejjn.exercise_id = e.id
					AND
						ejjn.joint_id = <cfqueryparam value="#REQUEST.JointID#" cfsqltype="cf_sql_integer" />		
						
					<!--- Check to see if we have joint action. --->
					<cfif REQUEST.JointActionID>
					
						AND
							ejjn.joint_action_id = <cfqueryparam value="#REQUEST.JointActionID#" cfsqltype="cf_sql_integer" />
					
					</cfif>
						
					<!--- Check to see if we have movement plane. --->
					<cfif REQUEST.MovementPlaneID>
					
						AND
							ejjn.movement_plane_id = <cfqueryparam value="#REQUEST.MovementPlaneID#" cfsqltype="cf_sql_integer" />
					
					</cfif>
					
					<!--- Check to see if we have movement symmetry. --->
					<cfif REQUEST.MovementSymmetryID>
					
						AND
							ejjn.movement_symmetry_id = <cfqueryparam value="#REQUEST.MovementSymmetryID#" cfsqltype="cf_sql_integer" />
					
					</cfif>
				)
				
		</cfloop>
						
		ORDER BY
			e.name ASC	
	</cfquery>

</cfif>


<!--- 
	ASSERT: At this point, the form has been intialized or processed.
	Now, we can gather any additional information that we will need
	for display, not processing.
--->


<!--- Query for joint actions. --->
<cfquery name="REQUEST.JointAction" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		a.id,
		a.name
	FROM
		el_joint_action a
	ORDER BY
		a.sort ASC,
		a.name ASC
</cfquery>


<!--- Query for movements planes. --->
<cfquery name="REQUEST.MovementPlane" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		p.id,
		p.name
	FROM
		el_movement_plane p
	ORDER BY
		p.sort ASC,
		p.name ASC
</cfquery>			


<!--- Query for movements symmentry. --->
<cfquery name="REQUEST.MovementSymmetry" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		s.id,
		s.name
	FROM
		el_movement_symmetry s
	ORDER BY
		s.sort ASC,
		s.name ASC
</cfquery>	
