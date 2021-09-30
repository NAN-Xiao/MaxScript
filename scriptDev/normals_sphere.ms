rollout dd "NormalSphere" width:162 height:100
(
	
	button 'click' "click" pos:[13, 10] width:142 height:47 enabled:true align:#left
	progressBar pb1 "进度条" pos:[13, 65] width:142 height:18 color:( color 255 0 0 )	


	on click pressed do (
		sels = getcurrentselection()
		obj = sels[1]
		convertToPoly obj
		addModifier obj ( Edit_Normals())
		Mn = obj.modifiers[#Edit_Normals]
		p = obj.pos

		vn = polyop.getNumVerts obj
		--print vn
		for x = 1 to vn do (
			
			v = obj.getvertex x
			dir = [v.x - p.x, v.y - p.y, v.z - p.z]
			dir = normalize dir
			modPanel.setCurrentObject Mn

			vert_array = #{ x } 
			normal_array = #{ }
			Mn.ConvertVertexSelection &vert_array &normal_array
			normal_result = normal_array as array
			for y = 1 to normal_result.count do (
				Mn.EditNormalsMod.Setnormal normal_result[y] dir
			)
			
			print dir
		)

	)
)
createdialog dd 