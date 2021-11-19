
<cfcomponent
	extends="CFC"
	output="false"
	hint="Error flag and message collection object.">
	
	<!--- Run the pseudo code to set up data structures and default values. --->
	<cfset VARIABLES.Instance = StructNew() />
	<cfset VARIABLES.Instance.Errors = StructNew() />
	<cfset VARIABLES.Instance.Messages = ArrayNew( 1 ) />
	
	
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
		name="AddError"
		access="public"
		returntype="void"
		output="false"
		hint="Adds an error with the given hint.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Flag"
			type="string"
			required="true"
			hint="The error flag (identifier for this type of error)."
			/>
			
		<cfargument
			name="Hint"
			type="string"
			required="false"
			default="Invalid property."
			hint="A hint as to why this property is invalid."
			/>
			
		
		<!--- Add the errors. --->
		<cfset VARIABLES.Instance.Errors[ ARGUMENTS.Flag ] = ARGUMENTS.Hint />
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="AddMessage"
		access="public"
		returntype="void"
		output="false"
		hint="Adds the message to the message collection.">

		<!--- Define arguments. --->
		<cfargument
			name="Message"
			type="string"
			required="false"
			hint="The error message that we are adding."
			/>
			
		<!--- Add the message. --->
		<cfset ArrayAppend( VARIABLES.Instance.Messages, ARGUMENTS.Message ) />
	
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="AddMessageIfError"
		access="public"
		returntype="void"
		output="false"
		hint="Adds the message if the given error flag exists.">

		<!--- Define arguments. --->
		<cfargument
			name="Flag"
			type="string"
			required="true"
			hint="The error flag who's existense we are checking."
			/>
			
		<cfargument
			name="Message"
			type="string"
			required="false"
			hint="The error message that we are adding."
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
		
		<!--- Check to see if the error exists. --->
		<cfif StructKeyExists( VARIABLES.Instance.Errors, ARGUMENTS.Flag )>
			
			<!--- The error exists, so add the message. --->
			<cfset ArrayAppend( VARIABLES.Instance.Messages, ARGUMENTS.Message ) />
		
		</cfif>
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<cffunction
		name="GetErrors"
		access="public"
		returntype="struct"
		output="false"
		hint="Returns the errors structure.">
		
		<!--- 
			Return a reference to the errors structure. We might want 
			to consider duplicating this as we return it, but for now, 
			I don't think we should worry.
		--->
		<cfreturn VARIABLES.Instance.Errors />
	</cffunction>
	
	
	<cffunction
		name="GetMessages"
		access="public"
		returntype="array"
		output="false"
		hint="Returns the messages array.">
		
		<cfreturn VARIABLES.Instance.Messages />
	</cffunction>
	
	
	<cffunction
		name="HasError"
		access="public"
		returntype="boolean"
		output="false"
		hint="Check to see if the given error flag exists in the errors collection.">
		
		<!--- Define arguments. --->
		<cfargument
			name="Flag"
			type="string"
			required="true"
			hint="The error flag who's existense we are checking."
			/>
			
		<!--- Return whether or not the flag exists. --->
		<cfreturn StructKeyExists( VARIABLES.Instance.Errors, ARGUMENTS.Flag ) />
	</cffunction>
	
	
	<cffunction
		name="HasErrors"
		access="public"
		returntype="boolean"
		output="false"
		hint="Check to see if the error collection contains any errors.">
		
		<!--- Return the struct count, which will act as a boolean. --->
		<cfreturn StructCount( VARIABLES.Instance.Errors ) />
	</cffunction>
	
	
	<cffunction
		name="HasMessages"
		access="public"
		returntype="boolean"
		output="false"
		hint="Check to see if the error collection contains any messages.">
		
		<!--- Return the struct count, which will act as a boolean. --->
		<cfreturn ArrayLen( VARIABLES.Instance.Messages ) />
	</cffunction>
	
</cfcomponent>