
<cfcomponent
	extends="CFC"
	output="false"
	hint="Service object for movement plane objects.">
	
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
		hint="Returns all the movement plane records.">
		
		<cfreturn THIS.Search() />		
	</cffunction>
	
	
	<cffunction
		name="GetNewInstance"
		access="public"
		returntype="any"
		output="false"
		hint="Returns a new movement plane instance.">
		
		<cfreturn THIS.CreateCFC( "MovementPlane" ).Init() />		
	</cffunction>
	
	
	<cffunction
		name="Read"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized MovementPlane instance.">
		
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
		
		<!--- Create the empty movement plane object. --->
		<cfset LOCAL.MovementPlane = THIS.CreateCFC( "MovementPlane" ).Init() />
		
		<!--- Query for matching record. --->
		<cfset LOCAL.MovementPlaneData = THIS.Search( ID = ARGUMENTS.ID ) />
		
		<!--- Check to see if a record was found. --->
		<cfif LOCAL.MovementPlaneData.RecordCount>
			
			<!--- Store values into bean. --->
			<cfset LOCAL.MovementPlane.SetID( LOCAL.MovementPlaneData.id ) />
			<cfset LOCAL.MovementPlane.SetName( LOCAL.MovementPlaneData.name ) />
		
		</cfif>
		
		<!--- Return populated object. --->
		<cfreturn LOCAL.MovementPlane />
	</cffunction>
	
	
	<cffunction
		name="Search"
		access="public"
		returntype="query"
		output="false"
		hint="Searches the movement plane data based on the given search criteria.">
		
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
				p.id,
				p.name
			FROM
				el_movement_plane p
				
			<!--- Check for ID. --->
			<cfif ARGUMENTS.ID>
				
				WHERE
					p.id = <cfqueryparam value="#ARGUMENTS.ID#" cfsqltype="cf_sql_integer" />
					
			</cfif>
			
			ORDER BY
				p.sort ASC,
				p.name ASC
		</cfquery>
		
		<!--- Return records. --->
		<cfreturn LOCAL.Results />
	</cffunction>	
	
</cfcomponent>