rollout unnamedRollout "Untitled" width:162 height:300
(
	button 'btn1' "Button" pos:[32,72] width:84 height:71 align:#left
	on btn1 pressed  do
	(
	--	Print  selection.count
		if  selection.count==1 then
		(
			obj=selection[1]
			if ClassOf(obj)!=Line do 
			(
				messageBox "this object is not a line"
				break
			)
	
			--result
			maxOps.CloneNodes selection  cloneType:#copy newNodes:&result
			result.name="temp"
			select result
		
	
			convertTo $ PolyMeshObject
			--print ()
			vers=polyop.getVertsByFlag $ 0
			if vers.count>0 do 
			(
				--Print "2222"
				pos=#()
				for index in vers do 
				(

					v=polyop.getVert $ index
					p=[v.x, v.z ,v.y]
					
					append pos p
				)
				if pos.count>0 do 
				(
					for p in pos do 
					(
						Print p
					)
				)
			
			)
		)
	
	)
)
createdialog unnamedRollout