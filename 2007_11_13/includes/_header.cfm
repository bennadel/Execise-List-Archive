
<!--- 
	Before we output the page, let's just clean the Attributes 
	object. Since some of this data will be going back into FORM 
	fields, we want to make sure to escape parts of it. If we want
	the original values, we can always use the other scopes.
--->
<cfloop
	item="REQUEST.Key"
	collection="#REQUEST.Attributes#">
	
	<!--- Escape values. --->
	<cfset REQUEST.Attributes[ REQUEST.Key ] = HtmlEditFormat( REQUEST.Attributes[ REQUEST.Key ] ) />
	
</cfloop>


<!--- 
	Set the content type and reset the content buffer. 
	This will kill any extra white space that we have adding
	during the pre-page processing.
--->
<cfcontent
	type="text/html"
	reset="true"
	/>

<cfoutput>
	
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
	<html>
	<head>
		<title>Exercise List</title>
		
		<!-- Linked Files. -->
		<link rel="stylesheet" type="text/css" href="linked/content.css"></link>
		<link rel="stylesheet" type="text/css" href="linked/meta_content.css"></link>
		<link rel="stylesheet" type="text/css" href="linked/form.css"></link>
		<link rel="stylesheet" type="text/css" href="linked/structure.css"></link>
		<script type="text/javascript" src="linked/jquery-1.2.1.pack.js"></script>
		<script type="text/javascript" src="linked/scripts.js"></script>
	</head>
	<body>
	
		<!-- BEGIN: Site Header. -->
		<div id="siteheader">
			
			<h1>
				Project HUGE: Exercise List
			</h1>	
		
		</div>	
		<!-- END: Site Header. -->
	
		
		<!-- BEGIN: Primary Navigation. -->
		<ul id="primarynav">
			
			<li class="nav1">
				<a href="index.cfm?action=search">Exercise List</a>
			</li>
			<li class="nav2">
				<a href="index.cfm?action=edit">Add New Exercise</a>
			</li>
			
			<!--- Hack for last vertical pipe. --->
			<li>
				&nbsp;<br />
			</li>	
			
		</ul>	
		<!-- END: Primary Navigation. -->
		
		
		<!-- BEGIN: Site Content. -->
		<div id="sitecontent">
		
			<!-- BEGIN: Content Container. -->
			<div id="content">
		
</cfoutput>