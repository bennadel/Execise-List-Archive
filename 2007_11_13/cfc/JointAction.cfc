
<cfcomponent
	extends="CFC"
	output="false"
	hint="Models a joint action within the system.">
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.Instance = StructNew() />
	<cfset VARIABLES.Instance.ID = 0 />
	<cfset VARIABLES.Instance.Name = "" />
	
	
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
		name="GetID"
		access="public"
		returntype="numeric"
		output="false"
		hint="Returns the ID property.">
		
		<cfreturn VARIABLES.Instance.ID />
	</cffunction>
	
	
	<cffunction
		name="GetName"
		access="public"
		returntype="string"
		output="false"
		hint="Returns the name property.">
		
		<cfreturn VARIABLES.Instance.Name />
	</cffunction>
	
	
	<cffunction
		name="SetID"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the ID property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="numeric"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.ID = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetName"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the name property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.Name = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
</cfcomponent>
	