
<cfcomponent
	extends="CFC"
	output="false"
	hint="Service object for joint aspect objects.">
	
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
		name="GetNewInstance"
		access="public"
		returntype="any"
		output="false"
		hint="Returns a new joint aspect instance.">
		
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Create the new joint aspect. --->
		<cfset LOCAL.JointAspect = THIS.CreateCFC( "JointAspect" ).Init() />
		
		<!--- Set empty properties. --->
		<cfset LOCAL.JointAspect.SetJoint( VARIABLES.ServiceFactory.GetService( "JointService" ).GetNewInstance() ) />
		<cfset LOCAL.JointAspect.SetJointAction( VARIABLES.ServiceFactory.GetService( "JointActionService" ).GetNewInstance() ) />
		<cfset LOCAL.JointAspect.SetMovementPlane( VARIABLES.ServiceFactory.GetService( "MovementPlaneService" ).GetNewInstance() ) />
		<cfset LOCAL.JointAspect.SetMovementSymmetry( VARIABLES.ServiceFactory.GetService( "MovementSymmetryService" ).GetNewInstance() ) />
		
		<!--- Return new instance. --->
		<cfreturn LOCAL.JointAspect />		
	</cffunction>
	
</cfcomponent>