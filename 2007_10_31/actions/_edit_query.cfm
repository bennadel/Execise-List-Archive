

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
<cfquery name="REQUEST.Exercise" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		e.id,
		e.name,
		e.description,
		e.contraindications,
		e.alternate_names	
	FROM
		el_exercise e
	WHERE
		e.id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
	AND
		e.is_deleted = 0
</cfquery>

<!--- 
	Check to see if we found a record. If we did not, then 
	we want to ensure that the ID we have currently needs 
	to be forced to zero (which it may already be).
--->
<cfif NOT REQUEST.Exercise.RecordCount>

	<!--- Force to zero (ADDing a record). --->
	<cfset REQUEST.Attributes.id = 0 />

</cfif>



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
	
		<!--- 
			If we have made it this far, then the data is ready to process. 
			Now, we have to see if we are adding a new record or editing an 
			existing record. If we have an ID, then we have an existing record.
		--->
		<cfif REQUEST.Attributes.id>
		
			<!--- Update the existing record. --->
			<cfquery name="REQUEST.Update" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
				UPDATE
					el_exercise
				SET
					name = <cfqueryparam value="#REQUEST.Attributes.name#" cfsqltype="cf_sql_varchar" />,
					description = <cfqueryparam value="#REQUEST.Attributes.description#" cfsqltype="cf_sql_varchar" />,
					contraindications = <cfqueryparam value="#REQUEST.Attributes.contraindications#" cfsqltype="cf_sql_varchar" />,
					alternate_names = <cfqueryparam value="#REQUEST.Attributes.alternate_names#" cfsqltype="cf_sql_varchar" />,
					date_updated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />
				WHERE
					id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
			</cfquery>
		
		<cfelse>
		
			<!--- Insert the new record. --->
			<cfquery name="REQUEST.Insert" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
				INSERT INTO el_exercise
				(
					name,
					description,
					contraindications,
					alternate_names,
					date_created
				) VALUES (
					<cfqueryparam value="#REQUEST.Attributes.name#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#REQUEST.Attributes.description#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#REQUEST.Attributes.contraindications#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#REQUEST.Attributes.alternate_names#" cfsqltype="cf_sql_varchar" />,
					<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp" />
				);
					
				<!--- Select the new identity. --->
				SELECT
					@@Identity AS id
				;
			</cfquery>
			
			<!--- Store the new ID. --->
			<cfset REQUEST.Attributes.id = REQUEST.Insert.id />
		
		</cfif>
		
		
		<!--- 
			ASSERT: At this point, we have either inserted or updated
			the given record. Either way, we now have the ID of our 
			current record in the REQUEST.Attributes.id variable.
		--->
	
		
		<!--- Update the joint-action relationships to the current record. --->
		<cfquery name="REQUEST.UpdateJointAction" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
			<!--- Start out by deleting any existing relationship. --->
			DELETE FROM
				el_exercise_joint_jn
			WHERE
				exercise_id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
			;
			
			<!--- Now, we can go through and create the new relationships. --->
			<cfloop
				index="REQUEST.JointID"
				list="#REQUEST.Attributes.joint_id_list#"
				delimiters=",">
				
				<!--- 
					For each joint, we should have a joint-action relationship 
					that consists of a three item list. Break that up into an 
					array for easier access. 
				--->
				<cfset REQUEST.Relationship = ListToArray( REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ] ) />
				
				INSERT INTO el_exercise_joint_jn
				(
					exercise_id,
					joint_id,
					joint_action_id,
					movement_plane_id,
					movement_symmetry_id
				) VALUES (
					<cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#REQUEST.JointID#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#REQUEST.Relationship[ 1 ]#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#REQUEST.Relationship[ 2 ]#" cfsqltype="cf_sql_integer" />,
					<cfqueryparam value="#REQUEST.Relationship[ 3 ]#" cfsqltype="cf_sql_integer" />
				);
				
			</cfloop>
		</cfquery>
		
		
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
	<cfif REQUEST.Exercise.RecordCount>
	
		<!--- Query for current joint-action relationships. --->
		<cfquery name="REQUEST.JointAction" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
			SELECT
				ejjn.joint_id,
				ejjn.joint_action_id,
				ejjn.movement_plane_id,
				ejjn.movement_symmetry_id
			FROM
				el_exercise_joint_jn ejjn
			WHERE
				ejjn.exercise_id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
		</cfquery>
		
		
		<!--- Param basic exercise data. --->
		<cfset REQUEST.Attributes.name = REQUEST.Exercise.name />
		<cfset REQUEST.Attributes.description = REQUEST.Exercise.description />
		<cfset REQUEST.Attributes.contraindications = REQUEST.Exercise.contraindications />
		<cfset REQUEST.Attributes.alternate_names = REQUEST.Exercise.alternate_names />
		
		<!--- Param the joint id list. --->
		<cfset REQUEST.Attributes.joint_id_list = ValueList( REQUEST.JointAction.joint_id ) />
		
		<!--- 
			Param the joint data. For this, we need to set the 
			form data for each joint-action relationship.
		--->
		<cfloop query="REQUEST.JointAction">
			
			<!--- Param the joint-action. --->
			<cfset "REQUEST.Attributes.joint_action_#REQUEST.JointAction.joint_id#" = (
				REQUEST.JointAction.joint_action_id & "," &
				REQUEST.JointAction.movement_plane_id & "," &
				REQUEST.JointAction.movement_symmetry_id
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

