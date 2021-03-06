rollout Utilty "Utilty Tools" width:272 height:444
(
	button 'resetBtn' "ResetXForm" pos:[31,21] width:100 height:30 align:#left
	button 'checkmat' "CheckMat" pos:[31,65] width:100 height:30 align:#left
	groupBox 'grp6' "Pivot" pos:[29,155] width:214 height:108 align:#left
	button 'movepivot' "ResetPivot" pos:[46,209] width:188 height:39 align:#left
	button 'btn17' "UV2  OutSide" pos:[142,65] width:100 height:30 align:#left
	checkbox 'salpha' "alpha" pos:[183,303] width:46 height:23 checked:false align:#left
	checkbox 'suv2' "uv2" pos:[37,303] width:60 height:23 checked:false align:#left
	checkbox 'scolor' "color" pos:[110,303] width:55 height:23 align:#left
	groupBox 'grp7' "ClearChannel" pos:[29,280] width:214 height:142 align:#left
	button 'chabtn' "ClearChannel" pos:[42,368] width:188 height:39 align:#left
	button 'movepos' "MoveZero" pos:[142,21] width:100 height:30 align:#left
	checkbox 'sanima' "animation" pos:[37,328] width:60 height:23 enabled:true checked:false align:#left
	button 'removevertex' "RemoveIsolabedVertex" pos:[31,110] width:100 height:30 align:#left
	radioButtons 'pivotselect' "" pos:[45,176] width:168 height:16 enabled:true labels:#("buttom", "top", "world") columns:3 align:#left
	button 'UnWrapuv2' "UnWrap  LightUV" pos:[142,110] width:100 height:30 align:#left
	global  clearuv2
	global  clearalpha
	global  clearcolor
	global  clearanima
	global _pivot
	global allMat

	global uvobj=#()
	on resetBtn pressed  do
	(
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do
		(
		   -- modPanel.setCurrentObject(obj)
		   -- modPanel.addModToSelection(XForm ()) ui:on
		   ResetXForm obj
			maxOps.CollapseNode obj on
		    convertTo obj PolyMeshObject
		)
	)
	on checkmat pressed  do
	(
		allMat=#()
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
			Print("not selected any objects")
		)
		for obj in selection do
		(
			--modPanel.setCurrentObject(obj)
			if classof obj.material ==Multimaterial then 
			(
				append allMat obj
				--Print("111")
			)
			
		)
		if allMat.count>0 then 
		(
			path=maxFilePath
			if path=="" then 
			(
				path="C:\Users\Administrator\Desktop"
			)
			file=(path+"/"+(getFilenameFile maxFileName)+"_Multi/sub-obj.txt")
			deleteFile file
			str=createfile file
			s="Multi/sub-obj: \n"
			Format s to:str
			for m in allMat do 
			(
				s=(m.name+"\n")
				Format s to:str
			)
			close str	
			messageBox "some object has Multi/sub-obj material"
		)
	)	
	on checkUV pressed  do
	(
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do 
		(
			convertToPoly obj --转换成poly
			has=polyop.getMapSupport obj 2 --是否有uv2
			if has==true then 
			(
				ver=polyop.getNumMapVerts obj 2 
				if ver>0 then
				(
					--print ver
					for i=1 to ver do 
					(
						uvw=polyop.getMapVert obj 2 i
						x=uvw.x
						y=uvw.y
						z=uvw.z
						if (x<0 OR x>1 or y<0 OR y>1 or z<0 OR z>1) then 
						(
							append uvobj obj
						)
					)
				)
			)
			if uvobj.count>0 then 
			(
				path=maxFilePath
				if path=="" then 
				(
					path="C:\Users\Administrator\Desktop"
				)
				file=(path+"/"+(getFilenameFile maxFileName)+"_uv2.txt")
				deleteFile file
				str=createfile file
				s="uv2_outside: \n"
				Format s to:str
				for m in uvobj do 
				(
					s=(m.name+"\n")
					Format s to:str
				)
				close str
				messageBox "some object's uv2 outsid"
			)
		)

	)
	on UnWrapuv2 pressed do
	(
	
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		
		for obj in selection do
		(
			convertTo obj PolyMeshObject
			addModifier obj (Unwrap_UVW())
			obj.Unwrap_UVW.setTVSubObjectMode 3
			obj.Unwrap_UVW.setMapChannel 2
			obj.Unwrap_UVW.setFlattenSpacing 0.001
			obj.Unwrap_UVW.setFlattenAngle 45
			obj.Unwrap_UVW.unwrap2.flattenMapNoParams()
			update obj
			--obj.Unwrap_UVW.flattenMap 45.0 #() 0.001 true 0 true true   --.flattenMap <float>angleThreshold <point3 array>normalList <float>spacing <boolean>normalize <integer>layOutType <boolean>rotateClusters <boolean>fillHoles 
			--obj.Unwrap_UVW.normalMap #() 0.001 true 0 true true --<point3 array>normalList <float>spacing <boolean>normalize <integer>layOutType <boolean>rotateClusters <boolean>alignWidth 
			--obj.Unwrap_UVW.unwrap6.pack 1 0.001 true true true
			convertTo obj PolyMeshObject
		
		)
	)

	on movepivot pressed  do
	(
		
		--归零
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do
		(
			-- center.z = obj.min.z
			--modPanel.setCurrentObject(obj)
			center = obj.center
			Print pivotselect.state as string
			case pivotselect.state of
			(
				1: center.z = obj.max.z 
				2: center.z = obj.min.z 
				3: center=[0,0,0]
			--	default :  center.z = obj.min.z
			)
			obj.pivot = center
		)
	)
	on movepos pressed  do
	(
		--归零
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do
		(
			obj.position=[0,0,0]
		)
	)
	on removevertex pressed  do
	(
		--删除多余点
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do
		(
			modPanel.setCurrentObject(obj)
			convertTo obj PolyMeshObject
			polyop.deleteIsoVerts obj
		)
	)
	--checkbox for channel
	on suv2 changed state do
	(
		clearuv2=suv2.state
		print(1)
	)
	on salpha changed state do
	(
		clearalpha=salpha.state
		print(2)
	)
	on scolor changed state do
	(
		clearcolor=scolor.state
		print(3)
	)
	on sanima changed state do
	(
		clearanima=sanima.state
		print(4)
	)
	--clerachannel
	on chabtn pressed  do
	(
	
		if selection.count<=0 then
		(
			messageBox "没有选择物体"
		    Print("not selected any objects")
		)
		for obj in selection do
		(
			modPanel.setCurrentObject(obj)
			if clearuv2==true then 
			(
				--claer uv2
				j=10
				while j>2 do
				(
					ChannelInfo.ClearChannel obj j
					j-=1
				)
				maxOps.CollapseNodeTo obj 1 on
			) 
			if clearalpha==true then 
			(
				--claer alpha
				ChannelInfo.ClearChannel obj -2
				maxOps.CollapseNodeTo obj 1 on
			) 
			if clearcolor==true then 
			(
				--claer vertexcolor 
				ChannelInfo.ClearChannel obj 0
				maxOps.CollapseNodeTo obj 1 on
			) 
			if clearanima==true then 
			(
				--claer animation kes
				deleteKeys obj.pos.controller
				deleteKeys obj.scale.controller
				deleteKeys obj.rotation.controller
			) 
		)
		messageBox "清除Channel完成"
		Print("Clear channel")
	)

)
--export tool
rollout exporttool "Export Object" width:272 height:168
(
	button 'export' "Export    FBX" pos:[13,97] width:245 height:52 align:#left
	button 'folder' "....." pos:[214,37] width:34 height:29 align:#left
	editText 'path' "" pos:[23,40] width:177 height:22 align:#left
	groupBox 'grp7' "save path" pos:[15,16] width:245 height:65 enabled:false align:#left
	on folder pressed  do
	(
		folderPath = getSavePath()
		path.text = folderPath
	)
	on export pressed  do
	(
		if path.text=="" then
		(
			messageBox "请先选择导出的路径"
			Print("export path is null")
		)
		else
		(
			fpath=path.text
			--fils=getfiles (fpath+"/"+"*.fbx")
		--	for f in fils do 
			--(
		--		deleteFile f
		--	)
			for obj in selection do 
			(
				filename=obj.name						
			--	fils=getfiles (fpath+"/"+"*.fbx")
			--	if fils.count!=0 then
			--	(	
				--	ind=0
				--	for f in fils do 
				--	(
				--		fname=getFilenameFile f
				--		if filename==fname then 
				--		(
				--			filename=(filename+"_"+ind as string)
							--ind+=1
				--		)
				--	)
				--)
				completeFilePath = (fpath + "/" + filename)
				exportFile completeFilePath #noPrompt selectedOnly:true using:FBXEX
				
			)
			messageBox "导出全部fbx"
		)
	)
)

rollout ExportPatch "ExportPatch" width:272 height:168
(
	button 'export' "ExportPath" pos:[13,97] width:245 height:52 align:#left
	button 'folder' "....." pos:[214,37] width:34 height:29 align:#left
	editText 'path' "" pos:[23,40] width:177 height:22 align:#left

	on folder pressed  do
	(
		folderPath = getSaveFileName()
		Print folderPath
		path.text = folderPath
	)
	on export pressed  do
	(

		if path.text=="" do
		(
			messageBox "请先选择导出的路径"
			break
		)
	
	--	Print  selection.count
		if  selection.count==1 then
		(
			obj=selection[1]
			if ClassOf(obj)!=Line do 
			(
				messageBox "this object is not a line"
				break
			)
	
			maxOps.CloneNodes selection  cloneType:#copy newNodes:&result
			result.name="temp"
			select result
			convertTo $ PolyMeshObject
			vers=polyop.getVertsByFlag $ 0
			if vers.count>0 do 
			(
				pos=#()
				for index in vers do 
				(

					v=polyop.getVert $ index
					p=[v.x, v.z ,v.y]
					
					append pos p
				)
				--写文件
				if pos.count>0 do 
				(	
					Print "export position"
					file=path.text
					--deleteFile file
					str=createfile file
					for p in pos do 
					(
						Format ((p as string)+"\n") to:str
						--Format "\n" to:str
					)
					close str	
				)
			
			)
			delete $
		)
	
	)
)
--createdialog unnamedRollout 
rf = newRolloutFloater "FunPlus Tool Box" 285 900
addRollout Utilty rf
addRollout exporttool rf
addRollout ExportPatch rf