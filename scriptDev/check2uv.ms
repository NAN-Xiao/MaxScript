rollout dd  "Untitled" width:162 height:300
(

	button 'checkuv' "checkuv" pos:[13,26] width:142 height:47 enabled:true align:#left


	global errobj=#()
	on checkuv pressed  do
	(
		
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
							append errobj obj
							print "error"
							continue
						)
			
					)
				)
			)
		
		)



	)

)
createdialog dd 


	--