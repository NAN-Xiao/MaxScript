/*
--------------------------------------------------------------------------------
Author: lijianpeng
--------------------------------------------------------------------------------
*/

function CalVertNormals =
(
	if ( getCommandPanelTaskMode() != #modify ) do
	setCommandPanelTaskMode #modify
	if ( Filters.Is_EditPoly()) do
	(
		local theNode = selection[1]
		local theEditObj = modPanel.getCurrentObject()
		local theEditNorm = undefined
		--local theVertPaint = undefined
		local iModIndex = theNode.modifiers.count
		if ( ( classOf theEditObj ) == Editable_Poly ) then
		(
			theEditNorm = theNode.modifiers[theNode.modifiers.count]
			local baFaceSelection = polyOp.getFaceSelection theEditObj
		)
		if ( not baFaceSelection.isEmpty ) do
		(
			if ( ( classOf theEditNorm ) == UndefinedClass ) then
			(
				theEditNorm = Edit_Normals()
				--theVertPaint = VertexPaint()
				addModifier theNode theEditNorm
				--addModifier theNode theVertPaint
			)
			else if ( ( classOf theEditNorm ) != Edit_Normals ) then
			(
				theEditNorm = Edit_Normals()
				--theVertPaint = VertexPaint()
				addModifier theNode theEditNorm before:iModIndex
				--addModifier theNode theVertPaint before:iModIndex
			)
			if ( theEditNorm != undefined ) do
			(
				local baVertsFromFaceSelection = polyOp.getVertsUsingFace theEditObj baFaceSelection
				local ap3FaceNormals = for iFace = 1 to ( polyOp.getNumFaces theEditObj ) collect
				( if ( baFaceSelection[iFace] ) then ( polyOp.getFaceNormal theEditObj iFace ) else ( 0.0 ) )
				modPanel.setCurrentObject theEditNorm
				local abaFaceVertNormals = #( )
				for iFace = 1 to ( polyOp.getNumFaces theEditObj ) do
				(
					local baFaceVertNormals = #{ }
					if ( baFaceSelection[iFace] ) do
					theEditNorm.convertFaceSelection #{ iFace } baFaceVertNormals node:theNode
					append abaFaceVertNormals baFaceVertNormals
				)
				local baAllVertNormals = #{ }
				theEditNorm.convertFaceSelection baFaceSelection baAllVertNormals node:theNode
				for iVert in baVertsFromFaceSelection do
				(
					local verlist = #{ }
					append verlist iVert
					
					local Faces = polyop.getFacesUsingVert theNode verlist
					print ( "Faces : " + Faces as string )
					
					local totalAngle = 0
					for iFace in Faces do
					(
						print ( "Faces : " + iFace as string )
						local FaceEdges = polyop.getEdgesUsingFace theNode iFace
						local AllEdgesUseVert = polyop.getEdgesUsingVert theNode iVert
						local vector2 = #( )
						print ( "FaceEdges : " + FaceEdges as string )
						print ( "AllEdgesUseVert : " + AllEdgesUseVert as string )
						for iFaceEdges in FaceEdges do
						(
							for iAllEdgesUseVert in AllEdgesUseVert do
							(
								if ( iFaceEdges == iAllEdgesUseVert ) do
								( 
									print ( "Edge : " + iFaceEdges as string )
									local MyVerts = polyop.getEdgeVerts theNode iFaceEdges
									print ( "MyVerts : " + MyVerts as string )
									if ( MyVerts[1] == iVert ) then
									(
										print ( "Verts : " + MyVerts[1] as string + "/" + MyVerts[2] as string )
										local vertA = polyop.getVert theNode MyVerts[1]
										local vertB = polyop.getVert theNode MyVerts[2]
										local Dv = vertA - vertB
										Dv = normalize Dv
										append vector2 Dv
										--print(" Dv : " +    Dv as string  + "vector2" + vector2 as string)
									)
									else
									(
										print ( "Verts : " + MyVerts[1] as string + "/" + MyVerts[2] as string )
										local vertB = polyop.getVert theNode MyVerts[1]
										local vertA = polyop.getVert theNode MyVerts[2]
										local Dv = vertA - vertB
										Dv = normalize Dv
										append vector2 Dv
										--print(" Dv : " +    Dv as string +  "vector2" + vector2 as string)
									)
								)
							)
						)
						--print("vector2[1] : " +    vector2 as string)
						local dotvalue = dot vector2[1] vector2[2]
						print ( "dotvalue: " + dotvalue as string )
						local angle = acos dotvalue
						print ( "angle: " + angle as string )
						totalAngle = totalAngle + angle
					)
					local baVertNormals = #{ }
					theEditNorm.convertVertexSelection #{ iVert } baVertNormals node:theNode
					baVertNormals *= baAllVertNormals
					local baProxiFaces = ( polyOp.getFacesUsingVert theEditObj iVert ) * baFaceSelection
					if ( baVertNormals.numberSet == 1 ) then
					(
						local p3AvgFaceNormal = Point3 0.0 0.0 0.0
						local normals = #( )
						for iFace in baProxiFaces do
						(
							p3AvgFaceNormal += ap3FaceNormals[iFace]
						)
						
						p3AvgFaceNormal /= baProxiFaces.numberSet
						local iNormal = ( baVertNormals as Array )[1]
						--theEditNorm.setNormal iNormal p3AvgFaceNormal node:theNode
						p3AvgFaceNormal.y = p3AvgFaceNormal.y
						p3AvgFaceNormal.x = - p3AvgFaceNormal.x
						p3AvgFaceNormal.z = p3AvgFaceNormal.z
						local norCol = p3AvgFaceNormal * 255 * 0.5 + [128, 128, 128]
						local Col = norCol as color
						print ( "totalAngle" + totalAngle as string )
						Col.a = totalAngle / ( 360 ) * 255
						
						
						local vertlist = #{ } 
						append vertlist iVert
						local V_Channel = 0
						--polyop.setVDataValue theNode 3 vertlist Col.a
						polyop.setVertColor theNode -2 vertlist ( color Col.a Col.a Col.a ) 
						polyop.setVertColor theNode V_Channel vertlist Col
						--local norCol = p3AvgFaceNormal * 256 * 0.5 + [128,128,128]
						--local Col = norCol as color
						--Col.a = 1.0
						--local obj = selection[1]
						--setVertColor obj iVert Col
						print ( "if" + iVert as string + " / " + theNode as string + " / " + Col as string + Col.a as string )
					)
					else
					(
						local count = 0
						local totoalNormal = Point3 0.0 0.0 0.0
						local normals = #( )
						for iNormal in baVertNormals do
						(
							local p3AvgFaceNormal = Point3 0.0 0.0 0.0
							for iFace in baProxiFaces do
							if ( abaFaceVertNormals[iFace][iNormal] ) do
							p3AvgFaceNormal += ap3FaceNormals[iFace]
							p3AvgFaceNormal = normalize p3AvgFaceNormal
							--p3AvgFaceNormal = p3AvgFaceNormal / 3.0
							count = count + 1
							
							totoalNormal = totoalNormal + p3AvgFaceNormal
							append normals p3AvgFaceNormal
						)
						
						totoalNormal = normalize totoalNormal
						
						--theEditNorm.setNormal iNormal p3AvgFaceNormal node:theNode
						totoalNormal.y = totoalNormal.y
						totoalNormal.x = - totoalNormal.x
						totoalNormal.z = totoalNormal.z
						local norCol = totoalNormal * 255 * 0.5 + [128, 128, 128]
						local Col = norCol as color
						--print("totalAngle" + totalAngle as string)
						Col.a = totalAngle / ( 360 ) * 255
						
						
						local vertlist = #{ } 
						append vertlist iVert
						local V_Channel = 0
						--polyop.setVDataValue theNode 3 vertlist Col.a
						polyop.setVertColor theNode -2 vertlist ( color Col.a Col.a Col.a ) 
						polyop.setVertColor theNode V_Channel vertlist Col
						
						--theNode.SetVertexColor()
						
						print ( "else" + iVert as string + " / " + theNode as string + " / " + Col as string + Col.a as string )
					)
				)
				theEditNorm.makeExplicit selection:baAllVertNormals node:theNode
				maxOps.collapseNodeTo theNode theNode.modifiers.count true
				modPanel.setCurrentObject theNode.baseObject
				subObjectLevel = 4
			)
		)
	)
)
rollout cn_rollout "Create Vert Color Normal"
(	
	button createNormalsButton "Create Normals" width:150
	button aboutButton "About" width:150
	
	on createNormalsButton pressed do 
	(
		--s=selection
		--ConvertTo s Editable_Poly
		--select s
		--polyOp.setFaceSelection s #{1..polyOp.getNumFaces s}
		
		CalVertNormals()
		--for obj in selection do	createNormals obj lengthSpinner.value distanceOffsetSpinner.value mapOffsetSpinner.value renderable:renderableCheckbox.checked thickness:thicknessSpinner.value mapping:mappingCheckbox.checked
	)
	
	on aboutButton pressed do 
	(
		message = StringStream ""
		format "Create Vert Color Normal v%\nLijianpeng\nkalashnikov2986@163.com\nSee script for usage details." cn_rollout_VERSION to:message
		messageBox message
	)
)

if cn_floater != undefined then CloseRolloutFloater cn_floater
cn_floater = newRolloutFloater "Create Vert Color Normal" 200 100
addRollout cn_rollout cn_floater