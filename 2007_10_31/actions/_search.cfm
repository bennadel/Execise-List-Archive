
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<h2>
		Exercise List / Search
	</h2>
		
	<p>
		Please enter your search criteria below. Search results
		will show up to the right.
	</p>
	
	
	<!-- BEGIN: Search Form. -->
	<form action="#CGI.script_name#" method="post" id="searchform">
		
		<!--- Flag that the form was submitted. --->
		<input type="hidden" name="submitted" value="1" />
		
		<!--- This is the action we are performing. --->
		<input type="hidden" name="action" value="#REQUEST.Attributes.action#" />
		
		
		<div class="field">
	
			<label for="keywords">
				Keywords:
			</label>
			
			<input type="text" name="keywords" id="keywords" value="#REQUEST.Attributes.keywords#" class="medium" />
			
		</div>
	
		<div class="field">
		
			<p class="label">
				Joint Actions:
			</p>
		
			<div class="inputgroup">
		
				<!--- Loop over joints. --->
				<cfloop query="REQUEST.Joint">
			
					<div class="jointgroup">
					
						<label for="joint_id_list_#REQUEST.Joint.id#" class="joint">
		
							<input type="checkbox" name="joint_id_list" id="joint_id_list_#REQUEST.Joint.id#" value="#REQUEST.Joint.id#" 
								<cfif ListFind( REQUEST.Attributes.joint_id_list, REQUEST.Joint.id )>checked="true"</cfif>
								/> 		
							#REQUEST.Joint.name#
		
						</label>
						
						<div class="jointproperties">
								
							<div class="property">
								
								<label for="joint_action_#REQUEST.Joint.id#_1">
									Action:
								</label>
								
								<select name="joint_action_#REQUEST.Joint.id#" id="joint_action_#REQUEST.Joint.id#_1">
									<option value="0">- - Select Action - -</option>
									
									<cfloop query="REQUEST.JointAction">
										
										<option value="#REQUEST.JointAction.id#"
											<cfif (REQUEST.JointAction.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.Joint.id#" ], 1 ))>selected="true"</cfif>
											>#REQUEST.JointAction.name#</option>
									
									</cfloop>
								</select>
								
							</div>
							
							<div class="property">
							
								<label for="joint_action_#REQUEST.Joint.id#_2">
									Plane:
								</label>
								
								<select name="joint_action_#REQUEST.Joint.id#" id="joint_action_#REQUEST.Joint.id#_2">
									<option value="0">- - Select Plane - -</option>
									
									<cfloop query="REQUEST.MovementPlane">
										
										<option value="#REQUEST.MovementPlane.id#"
											<cfif (REQUEST.MovementPlane.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.Joint.id#" ], 2 ))>selected="true"</cfif>
											>#REQUEST.MovementPlane.name#</option>
									
									</cfloop>
								</select>
								
							</div>
							
							<div class="property">
							
								<label for="joint_action_#REQUEST.Joint.id#_3">
									Symmetry:
								</label>
								
								<select name="joint_action_#REQUEST.Joint.id#" id="joint_action_#REQUEST.Joint.id#_3">
									<option value="0">- - Select Symmetry - -</option>
									
									<cfloop query="REQUEST.MovementSymmetry">
										
										<option value="#REQUEST.MovementSymmetry.id#"
											<cfif (REQUEST.MovementSymmetry.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.Joint.id#" ], 3 ))>selected="true"</cfif>
											>#REQUEST.MovementSymmetry.name#</option>
									
									</cfloop>
								</select>
								
							</div>
							
						</div>
						
					</div>
					
				</cfloop>
		
			</div>
			
		</div>
		
		
		<div class="buttons">
		
			<button type="submit">Search</button>
					
		</div>
	
	</form>
	<!-- END: Search Form. -->
	
	
	
	<!-- BEGIN: Search Results. -->
	<div id="searchresults">
		
		<!--- Check to see if the form has been submitted. --->
		<cfif REQUEST.Attributes.Submitted>
		
			<!--- Check to see if there were any search resutls. --->
			<cfif REQUEST.Exercise.RecordCount>
		
				<ol>
				
					<!--- Loop over results. --->
					<cfloop query="REQUEST.Exercise">
					
						<li>
							<a href="#CGI.script_name#?action=view&id=#REQUEST.Exercise.id#">#REQUEST.Exercise.name#</a>
							
							#REQUEST.Exercise.description#
						</li>		
						
					</cfloop>
					
				</ol>
				
			<cfelse>
			
				<p>
					<em>There are no exercises that match your search criteria.</em>
				</p>
				
				<p>
					<em>Try making your search criteria less specific.</em>
				</p>
				
			</cfif>
		
		</cfif>
		
	</div>
	<!-- BEGIN: Search Results. -->
	
	
	<!--- Progressively enhance page. --->
	<script type="text/javascript">
		
		$(
			function(){
				
				// Hide all the joint properties.
				$( "div.jointproperties" ).hide();
				
				// Show the joint properties for joints that 
				// have already been selected.
				$( "label.joint:has( :checked )" ).next().show();
			
				// Hoop up the clicks for the joint checks.
				$( "label.joint input" ).click(
					function( objEvent ){
						var jInput = $( this );
						var jProperties = jInput.parent( "label" ).next();
						
						// If this is checked then show the actions.
						if (this.checked){
							jProperties.slideDown( "fast" );
						} else {
							jProperties.slideUp( "fast" );						
						}
					}
					);
			
			}		
			);
	
	</script>
	
</cfoutput>

<!--- Include the page footer. --->
<cfinclude template="../includes/_footer.cfm" />