
<cfcomponent
	extends="CFC"
	output="false"
	hint="Service object for joint objects.">
	
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
		hint="Returns all the joint records.">
		
		<cfreturn THIS.Search() />		
	</cffunction>
	
	
	<cffunction
		name="GetNewInstance"
		access="public"
		returntype="any"
		output="false"
		hint="Returns a new joint instance.">
		
		<cfreturn THIS.CreateCFC( "Joint" ).Init() />		
	</cffunction>
	
	
	<cffunction
		name="Read"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized Jiont instance.">
		
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
		
		<!--- Create the empty joint object. --->
		<cfset LOCAL.Joint = THIS.CreateCFC( "Joint" ).Init() />
		
		<!--- Query for matching record. --->
		<cfset LOCAL.JointData = THIS.Search( ID = ARGUMENTS.ID ) />
		
		<!--- Check to see if a record was found. --->
		<cfif LOCAL.JointData.RecordCount>
			
			<!--- Store values into bean. --->
			<cfset LOCAL.Joint.SetID( LOCAL.JointData.id ) />
			<cfset LOCAL.Joint.SetName( LOCAL.JointData.name ) />
		
		</cfif>
		
		<!--- Return populated object. --->
		<cfreturn LOCAL.Joint />
	</cffunction>
	
	
	<cffunction
		name="Search"
		access="public"
		returntype="query"
		output="false"
		hint="Searches the joint data based on the given search criteria.">
		
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
				j.id,
				j.name
			FROM
				el_joint j
				
			<!--- Check for ID. --->
			<cfif ARGUMENTS.ID>
				
				WHERE
					j.id = <cfqueryparam value="#ARGUMENTS.ID#" cfsqltype="cf_sql_integer" />
					
			</cfif>
			
			ORDER BY
				j.sort ASC,
				j.name ASC
		</cfquery>
		
		<!--- Return records. --->
		<cfreturn LOCAL.Results />
	</cffunction>	
	
</cfcomponent>