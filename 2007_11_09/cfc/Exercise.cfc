
<cfcomponent
	extends="CFC"
	output="false"
	hint="Models an exercise within the system.">
	
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.Instance = StructNew() />
	<cfset VARIABLES.Instance.ID = 0 />
	<cfset VARIABLES.Instance.Name = "" />
	<cfset VARIABLES.Instance.Description = "" />
	<cfset VARIABLES.Instance.Contraindications = "" />
	<cfset VARIABLES.Instance.AlternateNames = "" />
	<cfset VARIABLES.Instance.DateUpdated = Now() />
	<cfset VARIABLES.Instance.DateCreated = Now() />
	<cfset VARIABLES.Instance.JointAspects = ArrayNew( 1 ) />
		
	
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
		name="GetAlternateNames"
		access="public"
		returntype="string"
		output="false"
		hint="Returns the alternate names property.">
		
		<cfreturn VARIABLES.Instance.AlternateNames />
	</cffunction>
	
	
	<cffunction 
		name="GetContraindications"
		access="public"
		returntype="string"
		output="false"
		hint="Returns the contraindications property.">
		
		<cfreturn VARIABLES.Instance.Contraindications />
	</cffunction>
	
	
	<cffunction 
		name="GetDateCreated"
		access="public"
		returntype="date"
		output="false"
		hint="Returns the date created property.">
		
		<cfreturn VARIABLES.Instance.DateCreated />
	</cffunction>
	
	
	<cffunction 
		name="GetDateUpdated"
		access="public"
		returntype="date"
		output="false"
		hint="Returns the date updated property.">
		
		<cfreturn VARIABLES.Instance.DateUpdated />
	</cffunction>
	
	
	<cffunction 
		name="GetDescription"
		access="public"
		returntype="string"
		output="false"
		hint="Returns the description property.">
		
		<cfreturn VARIABLES.Instance.Description />
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
		name="GetJointAspects"
		access="public"
		returntype="array"
		output="false"
		hint="Returns the exercise-joint aspects property array.">
		
		<cfreturn VARIABLES.Instance.JointAspects />
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
		name="SetAlternateNames"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the alternate names property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.AlternateNames = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetContraindications"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the contraindications property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.Contraindications = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetDateCreated"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the date created property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="date"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.DateCreated = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetDateUpdated"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the date updated property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="date"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.DateUpdated = ARGUMENTS.Value />
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="SetDescription"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the description property.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="string"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.Description = ARGUMENTS.Value />
		<cfreturn />
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
		name="SetJointAspects"
		access="public"
		returntype="void"
		output="false"
		hint="Sets the exercise-joint aspect property array.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Value"
			type="array"
			required="true"
			/>
		
		<cfset VARIABLES.Instance.JointAspects = ARGUMENTS.Value />
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