
<cfcomponent 
	output="false"
	hint="Handle the application.">

	
	<!--- Set application settings. --->
	<cfset THIS.Name = "ExerciseList" />
	<cfset THIS.ApplicationTimeout = CreateTimeSpan( 0, 1, 0, 0 ) />
	<cfset THIS.SessionManagement = false />
	<cfset THIS.SetClientCookies = false />
	
	<!--- Set page settings. --->
	<cfsetting 
		requesttimeout="10"
		showdebugoutput="false"
		/>
	
	
	<cffunction 
		name="OnApplicationStart" 
		access="public" 
		returntype="boolean" 
		output="false" 
		hint="Fires when the application is first created.">
		
		<!--- 
			Lock the application scope (via named lock). While this will not 
			ensure the experience of every user on this site, it will ensure 
			that only one round of intialization happens at a time.
		--->
		<cflock
			name="OnApplicationStart"
			type="exclusive"
			timeout="10">
		
			<!--- Clear the application scope. --->
			<cfset StructClear( APPLICATION ) />
			
			<!--- 
				Create a DSN structure. Instead of defining the DSN 
				information here, we are including it for security reasons.
			--->
			<cfset APPLICATION.DSN = StructNew() />
			<cfinclude template="../_application_dsn.cfm" />
			<!---
			<cfset APPLICATION.DSN.Source = "" />
			<cfset APPLICATION.DSN.Username = "" />
			<cfset APPLICATION.DSN.Password = "" />
			--->
			
		</cflock>
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
	
		
	<cffunction 
		name="OnRequestStart" 
		access="public" 
		returntype="boolean" 
		output="true" 
		hint="Fires when prior to page processing.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="TargetPage" 
			type="string" 
			required="true" 
			/>
			
		<!--- Define the local scope. --->
		<cfset var LOCAL = StructNew() />
			
			
		<!--- 
			Check to see if the application needs to be reinitialized. 
			If so (URL existence), we are going to call the OnApplicationStart()
			event method manually and display a success message to the user.
		--->
		<cfif (
			StructKeyExists( URL, "reinit" ) AND
			THIS.OnApplicationStart()
			)>
		
			<h1>
				Application Initialized
			</h1>
			
			<p>
				The application has been re-intialized.
			</p>
		
			<!--- Return false so that the requested page does not render. --->
			<cfreturn false />
			
		</cfif>
		
		
		<!--- 
			ASSERT: If we have made it this far then we are not resetting 
			the application. Therefore, we can continue to initialize the 
			page request.
		--->
		
		
		<!--- 
			Clean the form values at the beginning of every request so that 
			we don't have to worry about this during form validation across 
			the site.
		--->
		<cfloop
			item="LOCAL.Key"
			collection="#FORM#">
				
			<!--- Trim value. --->
			<cfset FORM[ LOCAL.Key ] = Trim( FORM[ LOCAL.Key ] ) />
			
		</cfloop>
		
		
		<!--- 
			Create an Attributes object to hold the combined URL and FORM 
			scopes. This will make is possible to scope any passed in variable
			even if we are not sure where it is coming from. In our case, 
			FORM has higher importance and will overwrite values in the URL scope.
		--->
		<cfset REQUEST.Attributes = Duplicate( URL ) />
		<cfset StructAppend( REQUEST.Attributes, FORM ) />
		
		<!--- 
			Now that we have our attributes structure, we can default some 
			values that will be used throughout the application.
		--->
		
		<!--- The Action will determine what page we are on. --->
		<cfparam
			name="REQUEST.Attributes.Action"
			type="string"
			default=""
			/>
			
		<!--- 
			The submitted flag will determine if a given FORM has been 
			submitted. We are wrapping it in a try / catch to make sure 
			it is a boolean value.
		--->
		<cftry>	
			<cfparam
				name="REQUEST.Attributes.Submitted"
				type="boolean"
				default="false"
				/>
				
			<cfcatch>
				<cfset REQUEST.Attributes.Submitted = false />
			</cfcatch>
		</cftry>
		
		
		<!--- Return out. --->
		<cfreturn true />
	</cffunction>
	
	
	<cffunction 
		name="OnRequest"
		access="public"
		returntype="void" 
		output="true" 
		hint="Fires after pre-page processing is complete.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="TargetPage" 
			type="string" 
			required="true" 
			/>
			
		<!--- 
			Include the INDEX page no matter which template was 
			actually requested. All actions run through the index 
			page front-controller.
		--->
		<cfinclude template="index.cfm" />
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
	
	<!---
	<cffunction 
		name="OnRequestEnd" 
		access="public" 
		returntype="void" 
		output="true" 
		hint="Fires after the page processing is complete.">
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	--->

	<!---
	<cffunction 
		name="OnApplicationEnd" 
		access="public" 
		returntype="void" 
		output="false"
		hint="Fires when the application is terminated.">
		
		<!--- Define arguments. --->
		<cfargument 
			name="ApplicationScope" 
			type="struct" 
			required="false" 
			default="#StructNew()#" 
			/>
			
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	--->
	
	
	<cffunction 
		name="OnError" 
		access="public" 
		returntype="void" 
		output="true" 
		hint="Fires when an exception occures that is not caught by a try/catch.">
				
		<!--- Define arguments. --->
		<cfargument 
			name="Exception" 
			type="any" 
			required="true" 
			/>
			
		<cfargument 
			name="EventName" 
			type="string" 
			required="false" 
			default="" 
			/>
			
		<!--- Include the error page. --->
		<cfinclude template="./actions/_error.cfm" />
		
		<!--- Return out. --->
		<cfreturn />
	</cffunction>
	
</cfcomponent>