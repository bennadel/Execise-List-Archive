

<!--- 
	Param the key value. This is the record ID of the exercise 
	we are viewing.
--->
<cftry>
	<cfparam name="REQUEST.Attributes.id" type="numeric" default="0" />
	
	<cfcatch>
		<cfset REQUEST.Attributes.id = 0 />
	</cfcatch>
</cftry>


<!--- Query for exercise record that we are looking at.  --->
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
	something went wrong. In that case, we cannot recover and
	must send the user back to the search page.
--->
<cfif NOT REQUEST.Exercise.RecordCount>

	<!--- Redirect back to search. --->
	<cflocation
		url="#CGI.script_name#?action=search"
		addtoken="false"
		/>

</cfif>


<!--- Query for joint actions as they relate to this exercise. --->
<cfquery name="REQUEST.JointAction" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		<!--- Get IDs. --->
		( j.id ) AS joint_id,
		ejjn.joint_action_id,
		ejjn.movement_plane_id,
		ejjn.movement_symmetry_id,
		
		<!--- Get name. --->
		( j.name ) AS joint_name,
		( ISNULL( a.name, '' ) ) AS joint_action_name,
		( ISNULL( p.name, '' ) ) AS movement_plane_name,
		( ISNULL( s.name, '' ) ) AS movement_symmetry_name
	FROM
		el_exercise_joint_jn ejjn
	INNER JOIN
		el_joint j
	ON
		(
				ejjn.exercise_id = <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
			AND
				ejjn.joint_id = j.id		
		)
	LEFT OUTER JOIN
		el_joint_action a
	ON
		ejjn.joint_action_id = a.id
	LEFT OUTER JOIN
		el_movement_plane p
	ON
		ejjn.movement_plane_id = p.id
	LEFT OUTER JOIN
		el_movement_symmetry s
	ON
		ejjn.movement_symmetry_id = s.id
	ORDER BY
		j.sort ASC,
		j.name ASC
</cfquery>


<!--- 
	Now, we want to get related exercise. These are going to 
	be based on joint actions. Therefore, we can only get the 
	related exercises if we have at least one joint-action
	relationship. Query or joint actions for relationshipds that
	satisfy this rule.
--->
<cfquery name="REQUEST.ValidJointAction" dbtype="query">
	SELECT
		joint_id,
		joint_action_id,
		movement_plane_id,
		movement_symmetry_id
	FROM
		REQUEST.JointAction
	WHERE
		joint_action_id != 0
</cfquery>


<!--- Query for related exercises. --->
<cfquery name="REQUEST.RelatedExercise" datasource="#APPLICATION.DSN.Source#" username="#APPLICATION.DSN.Username#" password="#APPLICATION.DSN.Password#">
	SELECT
		e.id,
		e.name
	FROM
		el_exercise e
	WHERE
		e.id != <cfqueryparam value="#REQUEST.Attributes.id#" cfsqltype="cf_sql_integer" />
	AND
		e.is_deleted = 0
		
	<!--- 
		Check to see if we have any valid joint actions. This is the
		really lazy way to do this, and the inefficient way to do this
		because we still have to hit the database, but it will make
		the logic on the detail page easier.
	--->
	<cfif NOT REQUEST.ValidJointAction.RecordCount>
		
		AND
			1 = 0
	
	</cfif>
		
		
	<!--- 
		Loop over valid joint actions to make sure the current exercise 
		matches up in the proper way.
	--->
	<cfloop query="REQUEST.ValidJointAction">
				
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
					ejjn.joint_action_id = <cfqueryparam value="#REQUEST.ValidJointAction.joint_action_id#" cfsqltype="cf_sql_integer" />
					
				<!--- Check to see if plane can be used. --->
				<cfif REQUEST.ValidJointAction.movement_plane_id>
					
					AND
						ejjn.movement_plane_id = <cfqueryparam value="#REQUEST.ValidJointAction.movement_plane_id#" cfsqltype="cf_sql_integer" />
				
				</cfif>
			)
		
	</cfloop>
	
	ORDER BY
		e.name ASC
</cfquery>
