rollout dd "Untitled" width:162 height:300
(
	
	button 'BakeNormal' "BakeNormal" pos:[13, 26] width:142 height:47 enabled:true align:#left
	button 'TranslateNormal' "TranslateNormal" pos:[13, 76] width:142 height:47 enabled:true align:#left
	pickbutton pick "< Pick Reference Object >" pos:[13, 125] width:142 height:47 enabled:true align:#left
	progressBar pb1 "进度条" pos:[13, 200] width:142 height:18 color:( color 255 0 0 )	
	global pre_normal = #( )
	--	global sel = #( )
	on BakeNormal pressed do(
		setCommandPanelTaskMode #modify
		sel = getcurrentselection() --当前选择的物体
		pb1.value = 0

		For o = 1 to sel.count do (
			--塌陷成editble mesh
			convertToPoly sel[o]
			--当前选择的集合体
			obj = sel[o]
			--添加editornormal修改器
			addmodifier obj ( Edit_Normals())
			En = obj.modifiers[#Edit_Normals]
			--得到顶点数量
			vt = polyop.getNumVerts obj
			--Print vt
			--选择所有法线并且焊接法线
			modPanel.setCurrentObject En
			subobjectlevel = 1
			max select all
			En.EditNormalsMod.unify()


			--进度条数量
			prograss = sel.count + vt
			--遍历顶点返回法线引用
			for vn = 1 to vt do (
				vert_array = #{ vn }
				normal_array = #{ }
				--根据顶点索引返回顶点对法线的引用下标
				En.ConvertVertexSelection &vert_array &normal_array
				na = normal_array as array
				--顶点引用的法线数量大于1 代表不是光滑的物体 直接返回
				if ( na.count > 1 ) do (
					messageBox "顶点的法线数量大于1 检查光滑组"
					deleteModifier obj En
					return null
				)
				--根据索引得到当前点的法线
				normal = En.GetNormal na[1]
				ncolor = normalize normal 
				ncolor.x = - ncolor.x
				vc = ( ncolor * 0.5 + 0.5 ) * [255, 255, 255]
				vcolor = vc as Color
				polyop.setVertColor obj 0 vert_array vcolor
				Print na[1]
				Print normal
				Print vcolor 
				Print "-----------------------"
				
				pb1.value = 100. * ( o + vn ) / prograss
			)
			deletemodifier obj En
		)
		print pb1.value
	)
	--转移法线

	on pick picked refmesh do (
		
		if  pick.object!=undefined do(
			print "1"
			modPanel.setCurrentObject pick.object.baseObject
			convertToPoly pick.object
		)
	)

	on TranslateNormal pressed do(
		if pick.object==undefined do(
			Print "222"
			messagebox "没有拾取目标转换的mesh"
			return null
		)
		refobj=pick.object
		-- refvn =polyop.getNumVerts refobj
		-- refEn = sel.modifiers[#Edit_Normals]
		sels = getcurrentselection()--当前选择的物体
		if sels.Count>=1 do(
			sel=sels[1]
			
			if sel==undefined do(
				messagebox "没有选择mesh"
				return null
			)
			convertToPoly sel
			-- addmodifier sel ( Edit_Normals())
			--En = sel.modifiers[#Edit_Normals]
			vn =polyop.getNumVerts sel
			print vn
			--i=1
			--先遍历要改的顶点法线 再遍历用来替换的顶点法线 计算距离 然后替换
			for n=1 to vn do(
				ct=sel.getvertex n
				print (ct.x)

				refn= polyop.getNumVerts refobj
				for  rn=1 to refn do(
					
				)
			
				
			)

		)
		


	)
)
createdialog dd 