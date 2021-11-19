
<cfcomponent
	extends="CFC"
	output="false"
	hint="Service object for exercise objects.">
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.DSN = "" />
	<cfset VARIABLES.ServiceFactory = "" />
	
	
	<cffunction 
		name="Init"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized component.">
		
		<!--- Defined arguments. --->
		<cfargument
			name="DSN"
			type="struct"
			required="true"
			hint="The DSN object."
			/>
			
		<cfargument
			name="ServiceFactory"
			type="any"
			required="true"
			hint="The system's service factory."
			/>
			
		<!--- Store arguments. --->
		<cfset VARIABLES.DSN = ARGUMENTS.DSN />
		<cfset VARIABLES.ServiceFactory = ARGUMENTS.ServiceFactory />
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="Delete"
		access="public"
		returntype="any"
		output="false"
		hint="Deletes the given exercise.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exercise"
			type="any"
			required="true"
			hint="The exercise instance we are updating."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Set the date updated. --->
		<cfset ARGUMENTS.Exercise.SetDateUpdated( Now() ) />
		
		
		<!--- 
			Before we delete the exercise information, let's double check 
			to make sure that it is valid.
		--->
		<cfif THIS.ValidateDelete( ARGUMENTS.Exercise ).HasErrors()>
		
			<!--- 
				There were errors to exit this method and return false 
				to indicate that the save was not successful.
			--->
			<cfreturn false />
		
		</cfif>
		
			
		<!--- Start a transaction. --->
		<cftransaction 
			action="begin" 
			isolation="read_committed">
		
			<!--- Try to perform the database update. Catch any errors for rollback. --->
			<cftry>
			
			
				<!--- Delete the exercise. --->
				<cfquery name="LOCAL.Update" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
					UPDATE
						e
					SET
						e.is_deleted = 1,
						e.date_updated = <cfqueryparam value="#ARGUMENTS.Exercise.GetDateUpdated()#" cfsqltype="cf_sql_timestamp" />
					FROM
						el_exercise e
					WHERE
						e.id = <cfqueryparam value="#ARGUMENTS.Exercise.GetID()#" cfsqltype="cf_sql_integer" />
				</cfquery>
		
			
				<!--- Catch any database errors. --->
				<cfcatch>
				
					<!--- Roll back the transaction. --->
					<cftransaction action="rollback" />
					
					<!--- Rethrow the error for the application to handle.. --->
					<cfrethrow />
				
				</cfcatch>		
					
			</cftry>
			
		</cftransaction>		
		
		
		<!--- Return success. --->
		<cfreturn true />
	</cffunction>
	
	
	<cffunction
		name="GetAll"
		access="public"
		returntype="query"
		output="false"
		hint="Returns all the exercise records.">
		
		<cfreturn THIS.Search() />		
	</cffunction>
	
	
	<cffunction
		name="GetJointAspects"
		access="public"
		returntype="array"
		output="false"
		hint="Returns the array of joint aspects for a given exercise.">
		
		<!--- Define arguments. --->
		<cfargument
			name="ID"
			type="numeric"
			required="true"
			hint="The ID of the exercise for which we are getting joint aspects."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Query for records. --->
		<cfquery name="LOCAL.Results" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
			SELECT
				ejjn.joint_id,
				ejjn.joint_action_id,
				ejjn.movement_plane_id,
				ejjn.movement_symmetry_id
			FROM
				el_exercise_joint_jn ejjn
			INNER JOIN
				el_joint j
			ON
				ejjn.joint_id = j.id
			WHERE
				ejjn.exercise_id = <cfqueryparam value="#ARGUMENTS.ID#" cfsqltype="cf_sql_integer" />
			ORDER BY
				j.sort ASC,
				j.name ASC
		</cfquery>
		
		
		<!--- Create an array to hold the joint aspects. --->
		<cfset LOCAL.JointAspects = ArrayNew( 1 ) />
		
		<!--- Loop over the results and create the joint aspects objects. --->
		<cfloop query="LOCAL.Results">
		
			<!--- Create joint aspect object. --->
			<cfset LOCAL.JointAspect = VARIABLES.ServiceFactory.GetService( "JointAspectService" ).GetNewInstance() />
			
			<!--- Set the joint properties. --->
			<cfset LOCAL.JointAspect.SetJoint( VARIABLES.ServiceFactory.GetService( "JointService" ).Read( LOCAL.Results.joint_id ) ) />
			<cfset LOCAL.JointAspect.SetJointAction( VARIABLES.ServiceFactory.GetService( "JointActionService" ).Read( LOCAL.Results.joint_action_id ) ) />
			<cfset LOCAL.JointAspect.SetMovementPlane( VARIABLES.ServiceFactory.GetService( "MovementPlaneService" ).Read( LOCAL.Results.movement_plane_id ) ) />
			<cfset LOCAL.JointAspect.SetMovementSymmetry( VARIABLES.ServiceFactory.GetService( "MovementSymmetryService" ).Read( LOCAL.Results.movement_symmetry_id ) ) />

			<!--- Append to aspect array. --->
			<cfset ArrayAppend( LOCAL.JointAspects, LOCAL.JointAspect ) />
		
		</cfloop>		
		
		
		<cfreturn LOCAL.JointAspects />
	</cffunction>
	
	
	<cffunction
		name="GetNewInstance"
		access="public"
		returntype="any"
		output="false"
		hint="Returns a new exercise instance.">
		
		<cfreturn THIS.CreateCFC( "Exercise" ).Init() />		
	</cffunction>
	
	
	<cffunction
		name="GetRelatedExercises"
		access="public"
		returntype="query"
		output="false"
		hint="Searches for exercises related to the given one based on joint apsects.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exercise"
			type="any"
			required="true"
			hint="The exercise for which we are finding related exercises."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Get a short hand to the joint aspects. --->
		<cfset LOCAL.JointAspects = ARGUMENTS.Exercise.GetJointAspects() />
		
			
		<!--- Query for records. --->
		<cfquery name="LOCAL.Results" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
			SELECT
				e.id,
				e.name
			FROM
				el_exercise e
			WHERE
				e.is_deleted = 0
			AND
				e.id != <cfqueryparam value="#ARGUMENTS.Exercise.GetID()#" cfsqltype="cf_sql_integer" />
			
			
			<!--- Check for joint aspects. --->
			<cfif ArrayLen( LOCAL.JointAspects )>
			
				<!--- Loop over joint aspects. --->
				<cfloop 
					index="LOCAL.Index"
					from="1"
					to="#ArrayLen( LOCAL.JointAspects )#"
					step="1">
					
					<!--- Get a short hand to the currnet joint aspect. --->
					<cfset LOCAL.JointAspect = LOCAL.JointAspects[ LOCAL.Index ] />
					
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
								ejjn.joint_id = <cfqueryparam value="#LOCAL.JointAspect.GetJoint().GetID()#" cfsqltype="cf_sql_integer" />
							
							
							<!--- Check for joint action. --->
							<cfif LOCAL.JointAspect.GetJointAction().GetID()>
							
								AND
									ejjn.joint_action_id = <cfqueryparam value="#LOCAL.JointAspect.GetJointAction().GetID()#" cfsqltype="cf_sql_integer" />
							
							</cfif>
							
							<!--- Check to see if plane can be used. --->
							<cfif LOCAL.JointAspect.GetMovementPlane().GetID()>
								
								AND
									ejjn.movement_plane_id = <cfqueryparam value="#LOCAL.JointAspect.GetMovementPlane().GetID()#" cfsqltype="cf_sql_integer" />
							
							</cfif>
						)
					
				</cfloop>
			
			
			<cfelse>
			
				<!--- There are no joint aspects, so make sure this does not run. --->
				AND
					1 = 0
			
			</cfif>
			
			ORDER BY
				e.name ASC,
				e.id DESC
		</cfquery>
		
		<!--- Return records. --->
		<cfreturn LOCAL.Results />
	</cffunction>
	
	
	<cffunction
		name="Read"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized Exercise instance.">
		
		<!--- Define arguments. --->
		<cfargument
			name="ID"
			type="numeric"
			required="false"
			default="0"
			hint="The ID of the record we are returning."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		
		<!--- 
			Check to see if the ID is zero. If it is, simply return a 
			new instance so we don't have to make extraneous calls to 
			the database.
		--->
		<cfif NOT ARGUMENTS.ID>
			<cfreturn THIS.GetNewInstance() />
		</cfif>
		
		
		<!--- Create the empty exercise object. --->
		<cfset LOCAL.Exercise = THIS.CreateCFC( "Exercise" ).Init() />
		
		<!--- Query for matching record. --->
		<cfset LOCAL.ExerciseData = THIS.Search( ID = ARGUMENTS.ID ) />
		
		<!--- Check to see if a record was found. --->
		<cfif LOCAL.ExerciseData.RecordCount>
			
			<!--- Store values into bean. --->
			<cfset LOCAL.Exercise.SetID( LOCAL.ExerciseData.id ) />
			<cfset LOCAL.Exercise.SetName( LOCAL.ExerciseData.name ) />
			<cfset LOCAL.Exercise.SetDescription( LOCAL.ExerciseData.description ) />
			<cfset LOCAL.Exercise.SetContraindications( LOCAL.ExerciseData.contraindications ) />
			<cfset LOCAL.Exercise.SetAlternateNames( LOCAL.ExerciseData.alternate_names ) />
			<cfset LOCAL.Exercise.SetDateUpdated( LOCAL.ExerciseData.date_updated ) />
			<cfset LOCAL.Exercise.SetDateCreated( LOCAL.ExerciseData.date_created ) />
			<cfset LOCAL.Exercise.SetJointAspects( THIS.GetJointAspects( LOCAL.ExerciseData.id ) ) />
		
		</cfif>
		
		<!--- Return populated object. --->
		<cfreturn LOCAL.Exercise />
	</cffunction>
	
	
	<cffunction
		name="Save"
		access="public"
		returntype="boolean"
		output="false"
		hint="Inserts or updates the given exercise information. Returns true if successful.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exercise"
			type="any"
			required="true"
			hint="The exercise instance we are updating."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Set the date updated. --->
		<cfset ARGUMENTS.Exercise.SetDateUpdated( Now() ) />
		
		
		<!--- 
			Before we save the exercise information, let's double check 
			to make sure that it is valid.
		--->
		<cfif THIS.ValidateSave( ARGUMENTS.Exercise ).HasErrors()>
		
			<!--- 
				There were errors to exit this method and return false 
				to indicate that the save was not successful.
			--->
			<cfreturn false />
		
		</cfif>
		
			
		<!--- Start a transaction. --->
		<cftransaction 
			action="begin" 
			isolation="read_committed">
		
			<!--- Try to perform the database update. Catch any errors for rollback. --->
			<cftry>
			
		
				<!--- 
					Check to see if we have an ID. This will determine whether 
					or not we are updating or inserting.
				--->
				<cfif ARGUMENTS.Exercise.GetID()>
					
					<!--- We have an existing ID, so we are updating. --->
					<cfquery name="LOCAL.Update" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
						UPDATE
							e
						SET
							e.name = <cfqueryparam value="#ARGUMENTS.Exercise.GetName()#" cfsqltype="cf_sql_varchar" />,
							e.description = <cfqueryparam value="#ARGUMENTS.Exercise.GetDescription()#" cfsqltype="cf_sql_varchar" />,
							e.contraindications = <cfqueryparam value="#ARGUMENTS.Exercise.GetContraindications()#" cfsqltype="cf_sql_varchar" />,
							e.alternate_names = <cfqueryparam value="#ARGUMENTS.Exercise.GetAlternateNames()#" cfsqltype="cf_sql_varchar" />,
							e.date_updated = <cfqueryparam value="#ARGUMENTS.Exercise.GetDateUpdated()#" cfsqltype="cf_sql_timestamp" />
						FROM
							el_exercise e
						WHERE
							e.id = <cfqueryparam value="#ARGUMENTS.Exercise.GetID()#" cfsqltype="cf_sql_integer" />
					</cfquery>
				
				<cfelse>
				
					<!--- We do not have an existing ID, so we are inserting. --->
					<cfquery name="LOCAL.Insert" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
						INSERT INTO el_exercise
						(
							name,
							description,
							contraindications,
							alternate_names,
							date_updated,
							date_created
						) VALUES (
							<cfqueryparam value="#ARGUMENTS.Exercise.GetName()#" cfsqltype="cf_sql_varchar" />,
							<cfqueryparam value="#ARGUMENTS.Exercise.GetDescription()#" cfsqltype="cf_sql_varchar" />,
							<cfqueryparam value="#ARGUMENTS.Exercise.GetContraindications()#" cfsqltype="cf_sql_varchar" />,
							<cfqueryparam value="#ARGUMENTS.Exercise.GetAlternateNames()#" cfsqltype="cf_sql_varchar" />,
							<cfqueryparam value="#ARGUMENTS.Exercise.GetDateUpdated()#" cfsqltype="cf_sql_timestamp" />,
							<cfqueryparam value="#ARGUMENTS.Exercise.GetDateCreated()#" cfsqltype="cf_sql_timestamp" />
						);
						
						<!--- Select the new ID. --->
						SELECT
							@@Identity AS id
						;
					</cfquery>
					
					<!--- Store the new ID back into the instance. --->
					<cfset ARGUMENTS.Exercise.SetID( LOCAL.Insert.id ) />
					
				</cfif>
				
				
				<!--- 
					ASSERT: At this point, we have either updated or insert our exercise
					record and updated the Exercise instance. We can now treat the record
					uniformly going forward.
				--->
				
				
				<!--- Update the joins. --->
				<cfquery name="LOCAL.UpdateJoins" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
					<!--- First, let's delete any pre-existing joint aspect data. --->
					DELETE FROM
						ejjn
					FROM
						el_exercise_joint_jn ejjn
					WHERE
						ejjn.exercise_id = <cfqueryparam value="#ARGUMENTS.Exercise.GetID()#" cfsqltype="cf_sql_integer" />
					;
					
					
					<!--- Get the joint aspects. --->
					<cfset LOCAL.JointAspects = ARGUMENTS.Exercise.GetJointAspects() />
					
					<!--- Now, loop over the joints aspects and create the relationships. --->
					<cfloop
						index="LOCAL.Index"
						from="1"
						to="#ArrayLen( LOCAL.JointAspects )#"
						step="1">
						
						<!--- Insert the record. --->
						INSERT INTO el_exercise_joint_jn 
						(
							exercise_id,
							joint_id,
							joint_action_id,
							movement_plane_id,
							movement_symmetry_id				
						) VALUES (
							<cfqueryparam value="#ARGUMENTS.Exercise.GetID()#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#LOCAL.JointAspects[ LOCAL.Index ].GetJoint().GetID()#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#LOCAL.JointAspects[ LOCAL.Index ].GetJointAction().GetID()#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#LOCAL.JointAspects[ LOCAL.Index ].GetMovementPlane().GetID()#" cfsqltype="cf_sql_integer" />,
							<cfqueryparam value="#LOCAL.JointAspects[ LOCAL.Index ].GetMovementSymmetry().GetID()#" cfsqltype="cf_sql_integer" />
						);				
						
					</cfloop>
				</cfquery>
				
			
				<!--- Catch any database errors. --->
				<cfcatch>
				
					<!--- Roll back the transaction. --->
					<cftransaction action="rollback" />
					
					<!--- Rethrow the error for the application to handle.. --->
					<cfrethrow />
				
				</cfcatch>		
					
			</cftry>
			
		</cftransaction>
		
		<!--- Return true for successful update. --->
		<cfreturn true />
	</cffunction>
	
	
	<cffunction
		name="Search"
		access="public"
		returntype="query"
		output="false"
		hint="Searches the exercise data based on the given search criteria.">
		
		<!--- Define arguments. --->
		<cfargument
			name="ID"
			type="numeric"
			required="false"
			default="0"
			hint="The ID of the record we are returning."
			/>
		
		<cfargument
			name="Keywords"
			type="string"
			required="false"
			default=""
			hint="Keywords to filter on."
			/>
			
		<cfargument
			name="JointAspects"
			type="array"
			required="false"
			default="#ArrayNew( 1 )#"
			hint="The array of joint aspects on which to search for related exercises."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
			
		<!--- Query for records. --->
		<cfquery name="LOCAL.Results" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
			DECLARE @keywords VARCHAR( 50 );
			
			SET @keywords = <cfqueryparam value="#Left( ARGUMENTS.Keywords, 50 )#" cfsqltype="cf_sql_varchar" />;
			
			SELECT
				e.id,
				e.name,
				e.description,
				e.contraindications,
				e.alternate_names,
				e.date_updated,
				e.date_created
			FROM
				el_exercise e
			WHERE
				e.is_deleted = 0
			
			<!--- Check for ID. --->
			<cfif ARGUMENTS.ID>
			
				AND
					e.id = <cfqueryparam value="#ARGUMENTS.ID#" cfsqltype="cf_sql_integer" />
					
			</cfif>
			
			<!--- Check for keywords. --->
			<cfif Len( ARGUMENTS.Keywords )>
			
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
			
			<!--- Check for joint aspects. --->
			<cfif ArrayLen( ARGUMENTS.JointAspects )>
			
				<!--- Loop over joint aspects. --->
				<cfloop 
					index="LOCAL.Index"
					from="1"
					to="#ArrayLen( ARGUMENTS.JointAspects )#"
					step="1">
					
					<!--- Get a short hand to the currnet joint aspect. --->
					<cfset LOCAL.JointAspect = ARGUMENTS.JointAspects[ LOCAL.Index ] />
					
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
								ejjn.joint_id = <cfqueryparam value="#LOCAL.JointAspect.GetJoint().GetID()#" cfsqltype="cf_sql_integer" />
							
							<!--- Check for joint action. --->
							<cfif LOCAL.JointAspect.GetJointAction().GetID()>
							
								AND
									ejjn.joint_action_id = <cfqueryparam value="#LOCAL.JointAspect.GetJointAction().GetID()#" cfsqltype="cf_sql_integer" />
							
							</cfif>
							
							<!--- Check to see if plane can be used. --->
							<cfif LOCAL.JointAspect.GetMovementPlane().GetID()>
								
								AND
									ejjn.movement_plane_id = <cfqueryparam value="#LOCAL.JointAspect.GetMovementPlane().GetID()#" cfsqltype="cf_sql_integer" />
							
							</cfif>
							
							<!--- Check to see if symmetry can be used. --->
							<cfif LOCAL.JointAspect.GetMovementSymmetry().GetID()>
								
								AND
									ejjn.movement_symmetry_id = <cfqueryparam value="#LOCAL.JointAspect.GetMovementSymmetry().GetID()#" cfsqltype="cf_sql_integer" />
							
							</cfif>
						)
					
				</cfloop>
			
			</cfif>
			
			ORDER BY
				e.name ASC,
				e.id DESC
		</cfquery>
		
		<!--- Return records. --->
		<cfreturn LOCAL.Results />
	</cffunction>
	
	
	<cffunction 
		name="ValidateDelete"
		access="public"
		returntype="any"
		output="false"
		hint="Validates a given Exercise instance for deletion. It can take an optional error collection option to populate.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exercise"
			type="any"
			required="true"
			hint="An exercise object." 
			/>
		
		<cfargument
			name="Errors"
			type="any"
			required="false"
			hint="The optional error collection. If this is not passed in, one will be created for you."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		
		<!--- Check to see if we need to create an error collection. --->
		<cfif NOT StructKeyExists( ARGUMENTS, "Errors" )>
			
			<!--- 
				Create our own error collection. Just store it right 
				back into the ARGUMENTS scope so that the rest of the 
				method can treat this scenario uniformly.
			--->
			<cfset ARGUMENTS.Errors = VARIABLES.ServiceFactory.CreateCFC( "ErrorCollection" ).Init() />
		
		</cfif>
		
		<!--- Return the error collection. --->
		<cfreturn ARGUMENTS.Errors />
	</cffunction>
	
	
	<cffunction 
		name="ValidateSave"
		access="public"
		returntype="any"
		output="false"
		hint="Validates a given Exercise instance for saving. It can take an optional error collection option to populate.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Exercise"
			type="any"
			required="true"
			hint="An exercise object." 
			/>
		
		<cfargument
			name="Errors"
			type="any"
			required="false"
			hint="The optional error collection. If this is not passed in, one will be created for you."
			/>
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		
		<!--- Check to see if we need to create an error collection. --->
		<cfif NOT StructKeyExists( ARGUMENTS, "Errors" )>
			
			<!--- 
				Create our own error collection. Just store it right 
				back into the ARGUMENTS scope so that the rest of the 
				method can treat this scenario uniformly.
			--->
			<cfset ARGUMENTS.Errors = VARIABLES.ServiceFactory.CreateCFC( "ErrorCollection" ).Init() />
		
		</cfif>
		
		
		<!--- Check to see if the name has been set. --->
		<cfif NOT Len( ARGUMENTS.Exercise.GetName() )>
		
			<cfset ARGUMENTS.Errors.AddError(
				"NameExistence",
				"Name property has not been set"
				) />
		
		<!--- Check to see if the name is too long. --->
		<cfelseif (Len( ARGUMENTS.Exercise.GetName() ) GT 100)>
		
			<cfset ARGUMENTS.Errors.AddError(
				"NameLength",
				"Name property must be 100 characters or less"
				) />
		
		</cfif>
		
		
		<!--- Return the error collection. --->
		<cfreturn ARGUMENTS.Errors />
	</cffunction>
	
</cfcomponent>