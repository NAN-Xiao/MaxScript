



rollout unnamedRollout "Utilty Tools" width:280 height:542
(
	button 'resetBtn' "ResetXForm" pos:[37,9] width:201 height:45 align:#left
	button 'checkmat' "CheckMaterial" pos:[37,232] width:201 height:45 align:#left
	button 'movepivot' "ResetPivot" pos:[38,113] width:201 height:45 align:#left
	button 'chabtn' "ClearChannel" pos:[37,393] width:201 height:45 align:#left
	checkbox 'suv2' "uv2" pos:[39,332] width:47 height:14 align:#left
	groupBox 'grp1' "SelectChannel" pos:[24,293] width:228 height:166 align:#left
	checkbox 'salpha' "alpha" pos:[108,332] width:47 height:14 align:#left
	checkbox 'scolor' "color" pos:[182,332] width:47 height:14 align:#left
	checkbox 'sanima' "animation" pos:[39,362] width:64 height:14 align:#left
	button 'movepos' "MovePosToZero" pos:[37,171] width:201 height:45 align:#left
	dropDownList 'spivot' "Pivot" pos:[43,58] width:190 height:41 items:#("Top", "Buttom", "Align world") selection:2 align:#left
	button 'removevertex' "RemoveIsolabedVertex" pos:[37,470] width:201 height:45 align:#left

	global  clearuv2
	global  clearalpha
	global  clearcolor
	global  clearanima
	global _pivot
	global allMat
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
			if path!="" then
			(
				file=(path+"/"+(getFilenameFile maxFileName)+"_Log.txt")
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
			)
			
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
			case _pivot of
			(
				"Buttom":  center.z = obj.min.z
				"Top":	   center.z = obj.max.z
				"Align world": center=[0,0,0]
				default :  center.z = obj.min.z
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

	on spivot selected sel do
	(
		_pivot=spivot.items[sel]
	)
)
--export tool
rollout exporttool "Export Tools" width:296 height:168
(
	button 'export' "Export    FBX" pos:[15,97] width:264 height:52 align:#left
	button 'folder' "....." pos:[228,37] width:34 height:29 align:#left
	editText 'path' "" pos:[24,40] width:199 height:22 align:#left
	groupBox 'grp7' "save path" pos:[15,16] width:264 height:65 enabled:false align:#left
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
			fils=getfiles (fpath+"/"+"*.fbx")
			for f in fils do 
			(
				deleteFile f
			)
			for obj in selection do 
			(
				filename=obj.name						
				fils=getfiles (fpath+"/"+"*.fbx")
				if fils.count!=0 then
				(	
					ind=0
					for f in fils do 
					(
						fname=getFilenameFile f
						if filename==fname then 
						(
							filename=(filename+"_"+ind as string)
							--ind+=1
						)
					)
				)
				completeFilePath = (fpath + "/" + filename)
				exportFile completeFilePath #noPrompt selectedOnly:true using:FBXEX
				
			)
			messageBox "导出全部fbx"
		)
	)
)
--createdialog unnamedRollout 
rf = newRolloutFloater "FunPlus Tool Box" 280 900
addRollout unnamedRollout rf
addRollout exporttool rf