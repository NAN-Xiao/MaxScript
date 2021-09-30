rollout dd "Normal_Combine" width:162 height:100
(
	
	button 'BakeNormal' "BakeNormal" pos:[13, 10] width:142 height:47 enabled:true align:#left
	progressBar pb1 "进度条" pos:[13, 70] width:142 height:18 color:( color 255 0 0 )	
	global pre_normal = #( )
	--	global sel = #( )
	on BakeNormal pressed do (
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

)
createdialog dd 