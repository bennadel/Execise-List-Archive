
<!--- Include the page header. --->
<cfinclude template="../includes/_header.cfm" />

<cfoutput>

	<h2>
		Add / Edit Exercise
	</h2>
	
	<form action="#CGI.script_name#" method="post">
		
		<!--- Flag that the form was submitted. --->
		<input type="hidden" name="submitted" value="1" />
		
		<!--- This is the action we are performing. --->
		<input type="hidden" name="action" value="#REQUEST.Attributes.action#" />
		
		<!--- This is the ID of the record we are looking at. --->
		<input type="hidden" name="id" value="#REQUEST.Attributes.id#" />
	
		
		<!--- Check to see if there are any form errors. --->
		<cfif ArrayLen( REQUEST.Errors )>
			
			<div class="errors">
			
				<p>
					Please review the following errors:
				</p>
				
				<ul>
					<cfloop
						index="REQUEST.Index"
						from="1"
						to="#ArrayLen( REQUEST.Errors )#"
						step="1">
						
						<li>
							#REQUEST.Errors[ REQUEST.Index ]#
						</li>
						
					</cfloop>
				</ul>
				
			</div>
		
		</cfif>
		
		
		<div class="field">
		
			<label for="name">
				Name:
			</label>
			
			<input type="text" name="name" id="name" value="#REQUEST.Attributes.name#" class="large" />
		
		</div>
		
		<div class="field">
		
			<label for="description">
				Description:
			</label>
			
			<textarea name="description" id="description" class="large">#REQUEST.Attributes.description#</textarea>
					
		</div>
		
		<div class="field">
		
			<p class="label">
				Joint Actions:
			</p>
		
			<div class="inputgroup">
		
				<!--- Loop over joints. --->
				<cfloop query="REQUEST.Joint">
				
					<!--- 
						Get the joint ID into a variable so that we don't get 
						with the nested loop problem during the Select output.
					--->
					<cfset REQUEST.JointID = REQUEST.Joint.id />
					
			
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
											<cfif (REQUEST.JointAction.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ], 1 ))>selected="true"</cfif>
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
											<cfif (REQUEST.MovementPlane.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ], 2 ))>selected="true"</cfif>
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
											<cfif (REQUEST.MovementSymmetry.id EQ ListGetAt( REQUEST.Attributes[ "joint_action_#REQUEST.JointID#" ], 3 ))>selected="true"</cfif>
											>#REQUEST.MovementSymmetry.name#</option>
									
									</cfloop>
								</select>
								
							</div>
							
						</div>
						
					</div>
					
				</cfloop>
		
			</div>
			
		</div>
		
		<div class="field">
		
			<label for="contraindications">
				Contraindications:
			</label>
			
			<textarea name="contraindications" id="contraindications" class="large">#REQUEST.Attributes.contraindications#</textarea>
			
			<p class="fieldnote">
				Please list out the indicators that would red-flag this 
				exercise as being inappropriate for a given individual.
			</p>
					
		</div>
		
		<div class="field">
		
			<label for="alternate_names">
				Alternate Names:
			</label>
			
			<textarea name="alternate_names" id="alternate_names" class="large">#REQUEST.Attributes.alternate_names#</textarea>
					
		</div>
		
		<div class="buttons">
		
			<button type="submit">Add / Edit Exercise</button>
					
		</div>
	
	</form>
	
	
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
						
							// Show properties.
							jProperties.slideDown( "fast" );
						
						} else {
						
							// Hide the properties.
							jProperties.slideUp( "fast" );						
							
							// Reset the select boxes.
							jProperties.find( "select" ).each(
								function( intI ){
									this.selectedIndex = 0;								
								}
								);
							
						}
					}
					);
			
			}		
			);
	
	</script>

</cfoutput>

<!--- Include the page footer. --->
<cfinclude template="../includes/_footer.cfm" />