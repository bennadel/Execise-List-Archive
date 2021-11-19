
<cfcomponent
	extends="CFC"
	output="false"
	hint="Factory for system objects.">
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.DSN = "" />	
	<cfset VARIABLES.ExerciseService = "" />
	<cfset VARIABLES.JointAspectService = "" />
	<cfset VARIABLES.JointService = "" />
	<cfset VARIABLES.JointActionService = "" />
	<cfset VARIABLES.MovementPlaneService = "" />
	<cfset VARIABLES.MovementSymmetryService = "" />
	
	
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
			
		<!--- Store the DSN. --->
		<cfset VARIABLES.DSN = ARGUMENTS.DSN />
		
		<!--- Set up the rest of the singleton objects. --->
		<cfset VARIABLES.ExerciseService = THIS.CreateCFC( "ExerciseService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		<cfset VARIABLES.JointAspectService = THIS.CreateCFC( "JointAspectService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		<cfset VARIABLES.JointService = THIS.CreateCFC( "JointService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		
		<cfset VARIABLES.JointActionService = THIS.CreateCFC( "JointActionService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		
		<cfset VARIABLES.MovementPlaneService = THIS.CreateCFC( "MovementPlaneService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		
		<cfset VARIABLES.MovementSymmetryService = THIS.CreateCFC( "MovementSymmetryService" ).Init( 
			DSN = VARIABLES.DSN,
			ServiceFactory = THIS
			) />
			
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="GetService"
		access="public"
		returntype="any"
		output="false"
		hint="Returns the given service object.">
		
		<!--- Defined arguments. --->
		<cfargument
			name="Service"
			type="string"
			required="true"
			hint="The name of the service we need to return."
			/>
		
		<!--- Return singleton. --->
		<cfreturn VARIABLES[ ARGUMENTS.Service ] />		
	</cffunction>
	
</cfcomponent>