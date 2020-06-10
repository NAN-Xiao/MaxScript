rollout unnamedRollout "Untitled" width:280 height:426
(
	button 'resetBtn' "ResetXF" pos:[34,10] width:201 height:45 align:#left
	button 'btn5' "ClearAnimation" pos:[34,131] width:201 height:45 align:#left
	button 'btn6' "CheckMaterial" pos:[34,189] width:201 height:45 align:#left
	button 'btn26' "ResetPosition" pos:[34,72] width:201 height:45 align:#left
	button 'chabtn' "ClearChannel" pos:[33,368] width:201 height:45 align:#left
	checkbox 'chk1' "uv2" pos:[39,287] width:47 height:14 align:#left
	groupBox 'grp1' "SelectChannel" pos:[22,252] width:228 height:107 align:#left
	checkbox 'chk2' "alpha" pos:[108,287] width:47 height:14 align:#left
	checkbox 'chk3' "color" pos:[182,287] width:47 height:14 align:#left
	on resetBtn pressed  do
(
		sel=getCurrentSelection()
		if sel.count<=0 then
		(
		    Print("not selected any objects")
		)
		for i=1 to sel.count do
		(
			obj=sel[i]
		    modPanel.setCurrentObject(obj)
		    modPanel.addModToSelection(XForm ()) ui:on
			maxOps.CollapseNode obj on
		    convertTo obj PolyMeshObject
		    center = obj.center
		    center.z = obj.min.z
		    obj.pivot = center
		    move obj [0,0,0]
		)
	)
	on btn5 pressed  do
(
		sel=getCurrentSelection()
		if sel.count<=0 then
		(
		    Print("not selected any objects")
		)
		for i=1 to sel.count do
		(
			obj=sel[i]
		    deleteKeys obj.pos.controller
		    deleteKeys obj.scale.controller
		    deleteKeys obj.rotation.controller
		)
	)
	on btn6 pressed  do
	sel=getCurrentSelection()
	
	if sel.count<=0 then
	(
	    Print("not selected any objects")
	)
	for i=1 to sel.count do
	(
		obj=sel[i]
	    modPanel.setCurrentObject(obj)
	    if (classof obj.material ==Multimaterial||) then 
	    (
	        Print("111")
	    )
	    
	)
	on btn26 pressed  do
(
		sel=getCurrentSelection()
		if sel.count<=0 then
		(
		    Print("not selected any objects")
		)
		for i=1 to sel.count do
		(
		    center = obj.center
		    center.z = obj.min.z
		    obj.pivot = center
		    move obj [0,0,0]
		)
	)
	on chabtn pressed  do
	sel=getCurrentSelection()
	
	if sel.count<=0 then
	(
	    Print("not selected any objects")
	)
	for i=1 to sel.count do
	(
		obj=sel[i]
	    modPanel.setCurrentObject(obj)
	    if (classof obj.material ==Multimaterial||) then 
	    (
	        Print("111")
	    )
	    
	)
	on chk1 changed state do
		print(1)
	on chk2 changed state do
		print(1)
	on chk3 changed state do
		print(1)
)