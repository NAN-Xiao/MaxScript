rollout dd "NormalTrans" width:162 height:150
(
	
	button 'TranslateNormal' "TranslateNormal" pos:[13, 10] width:142 height:47 enabled:true align:#left
	pickbutton pick "< Pick Reference Object >" pos:[13, 60] width:142 height:47 enabled:true align:#left
	progressBar pb1 "进度条" pos:[13, 120] width:142 height:18 color:( color 255 0 0 )	
	on pick picked refmesh do (
		
		if pick.object != undefined do (
			modPanel.setCurrentObject pick.object.baseObject
			convertToPoly pick.object
			pick.text = "RefObject = " + refmesh.name
		)
	)

	on TranslateNormal pressed do (
		if pick.object == undefined do (
			Print "222"
			messagebox "没有拾取目标转换的mesh"
			return null
		)
		refobj = pick.object
		-- refvn =polyop.getNumVerts refobj
		-- refEn = sel.modifiers[#Edit_Normals]
		sels = getcurrentselection()--当前选择的物体
		if sels.Count >= 1 do (
			sel = sels[1]
			
			if sel == undefined do (
				messagebox "没有选择mesh"
				return null
			)	
			convertToPoly sel
			addmodifier sel ( Edit_Normals())
			SEn = sel.modifiers[#Edit_Normals]
			vn = polyop.getNumVerts sel
			rvn = polyop.getNumVerts refobj


			addmodifier refobj ( Edit_Normals())
			REn = refobj.modifiers[#Edit_Normals]

			
			
			for n = 1 to vn do (
				cb = sel.getvertex n
				--cb=cb*sel.transform
				

				ct = refobj.getvertex 1
				menordist = ( cb.x - ct.x ) * ( cb.x - ct.x ) + ( cb.y - ct.y ) * ( cb.y - ct.y ) + ( cb.z - ct.z ) * ( cb.z - ct.z ) 
				--print ( menordist )
				
				vert_array = #{ 1 }
				normal_array = #{ }
				REn.ConvertVertexSelection &vert_array &normal_array
				normal_result = normal_array as array 
				normalt = REn.EditNormalsMod.Getnormal normal_result[1]
				for rn = 2 to rvn do (
					ct = refobj.getvertex rn
					--Print rn
					--ct=ct*refobj.transform
					dist = ( cb.x - ct.x ) * ( cb.x - ct.x ) + ( cb.y - ct.y ) * ( cb.y - ct.y ) + ( cb.z - ct.z ) * ( cb.z - ct.z ) 

					if dist < menordist then (
						menordist = dist
						modPanel.setCurrentObject REn -- tem que ir p/ edit normal p/ pegar normal stuff
						vert_array = #{ rn }
						normal_array = #{ }
						REn.ConvertVertexSelection &vert_array &normal_array
						normal_result = normal_array as array -- vira array normal p/ poder ler embaixo
						-- --
						normalt = normal_result --REn.EditNormalsMod.Getnormal normal_result[1]
						modPanel.setCurrentObject refobj.baseObject -- testa se esta mais proximo
					)
					--
				)
				modPanel.setCurrentObject sel.modifiers[#Edit_Normals] 
				vert_array = #{ n }
				normal_array = #{ }
				SEn.ConvertVertexSelection &vert_array &normal_array
				normal_result = normal_array as array
				--Print normalt
				--SEn.EditNormalsMod.Setnormal normal_result[1] normalt
				result = REn.EditNormalsMod.Getnormal normalt[1]
				for x = 1 to normal_result.count do (
					modPanel.setCurrentObject REn
					if ( x <= normalt.count ) then (
						result = REn.EditNormalsMod.Getnormal normalt[x]
					) else (
						result = REn.EditNormalsMod.Getnormal normalt[normalt.count]
					)
					modPanel.setCurrentObject SEn
					SEn.EditNormalsMod.Setnormal normal_result[x] result
				)
				-- Print normal_result.count
				-- for x = 1 to normal_result.count do (
				-- 	result = REn.EditNormalsMod.Getnormal normalt[1]
				-- 	if x <= normalt.count then (
				-- 		result = REn.EditNormalsMod.Getnormal normalt[x]
				-- 	)
				-- 	else (
				-- 		result = REn.EditNormalsMod.Getnormal normalt[normalt.count]
				-- 	)
				-- 	print result
				-- 	-- Print x
				-- 	SEn.EditNormalsMod.Setnormal normal_result[1] result
				-- )
				
			)

		)
		


	)
)
createdialog dd 