
<cfcomponent
	extends="CFC"
	output="false"
	hint="Service object for joint action objects.">
	
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
		name="GetAll"
		access="public"
		returntype="query"
		output="false"
		hint="Returns all the joint action records.">
		
		<cfreturn THIS.Search() />		
	</cffunction>
	
	
	<cffunction
		name="GetNewInstance"
		access="public"
		returntype="any"
		output="false"
		hint="Returns a new joint action instance.">
		
		<cfreturn THIS.CreateCFC( "JointAction" ).Init() />		
	</cffunction>
	
	
	<cffunction
		name="Read"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized JiontAction instance.">
		
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
		
		
		<!--- Create the empty joint action object. --->
		<cfset LOCAL.JointAction = THIS.CreateCFC( "JointAction" ).Init() />
		
		<!--- Query for matching record. --->
		<cfset LOCAL.JointActionData = THIS.Search( ID = ARGUMENTS.ID ) />
		
		<!--- Check to see if a record was found. --->
		<cfif LOCAL.JointActionData.RecordCount>
			
			<!--- Store values into bean. --->
			<cfset LOCAL.JointAction.SetID( LOCAL.JointActionData.id ) />
			<cfset LOCAL.JointAction.SetName( LOCAL.JointActionData.name ) />
		
		</cfif>
		
		<!--- Return populated object. --->
		<cfreturn LOCAL.JointAction />
	</cffunction>
	
	
	<cffunction
		name="Search"
		access="public"
		returntype="query"
		output="false"
		hint="Searches the joint action data based on the given search criteria.">
		
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
			
		<!--- Query for records. --->
		<cfquery name="LOCAL.Results" datasource="#VARIABLES.DSN.Source#" username="#VARIABLES.DSN.Username#" password="#VARIABLES.DSN.Password#">
			SELECT
				a.id,
				a.name
			FROM
				el_joint_action a
				
			<!--- Check for ID. --->
			<cfif ARGUMENTS.ID>
				
				WHERE
					a.id = <cfqueryparam value="#ARGUMENTS.ID#" cfsqltype="cf_sql_integer" />
					
			</cfif>
			
			ORDER BY
				a.sort ASC,
				a.name ASC
		</cfquery>
		
		<!--- Return records. --->
		<cfreturn LOCAL.Results />
	</cffunction>	
	
</cfcomponent>