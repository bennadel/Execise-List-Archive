
<cfcomponent
	extends="CFC"
	output="false"
	hint="Models a joint aspect within the system.">
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.Instance = StructNew() />
	<cfset VARIABLES.Instance.Joint = "" />
	<cfset VARIABLES.Instance.JointAction = "" />
	<cfset VARIABLES.Instance.MovementPlane = "" />
	<cfset VARIABLES.Instance.MovementSymmetry = "" />
	
	
	<cffunction 
		name="Init"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an initialized component.">
		
		<!--- Return This reference. --->
		<cfreturn THIS />
	</cffunction>
	
	
	<cffunction
		name="GetJoint"
		access="public"
		returntype="any"
		output="false"
		hint="Returns the joint property.">
		
		<cfreturn VARIABLES.Instance.Joint />
	</cffunction>
	
	
	<cffunction
		name="GetJointAction"
		access="public"
		returntype="any"
		output="false"
		hint="Returns the joint action property.">
		
		<cfreturn VARIABLES.Instance.JointAction />
	</cffunction>
	
	
	<cffunction
		name="GetMovementPlane"
		access="public"
		returntype="any"
		output="false"
		hint="Returns the movement plane property.">
		
		<cfreturn VARIABLES.Instance.MovementPlane />
	</cffunction>
	
	
	<cffunction
		name="GetMovementSymmetry"
		access="public"
		returntype="any"
		output="false"
		hint="Returns the movement symmetry property.">
		
		<cfreturn VARIABLES.Instance.MovementSymmetry />
	</cffunction>
	
	
	<cffunction
		name="SetJoint"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the joint property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.Joint = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetJointAction"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the joint action property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.JointAction = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetMovementPlane"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the movement plane property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.MovementPlane = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetMovementSymmetry"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the movement symmetry property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="any"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.MovementSymmetry = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
</cfcomponent>
	