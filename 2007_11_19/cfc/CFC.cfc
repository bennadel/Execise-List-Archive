
<cfcomponent
	output="false"
	hint="The base CFC that the other CFCs will extend.">
	
	
	<cffunction 
		name="CreateCFC"
		access="public"
		returntype="any"
		output="false"
		hint="Returns an un-initialized coldfusion component.">
		
		<!--- Define arguments. --->
		<cfargument
			name="CFC"
			type="string"
			required="true"
			hint="The name of the CFC to be created."
			/>
		
		<cfreturn CreateObject( "component", ARGUMENTS.CFC ) />
	</cffunction>
	
	
	<cffunction 
		name="GetVariables"
		access="public"
		returntype="struct"
		output="false"
		hint="Returns the private scope.">
		
		<cfreturn VARIABLES />
	</cffunction>
	
</cfcomponent>