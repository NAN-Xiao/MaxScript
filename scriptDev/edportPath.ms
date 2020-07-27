rollout dd  "Untitled" width:162 height:300
(
	button 'checkuv' "checkuv" pos:[13,26] width:142 height:47 enabled:true align:#left
	on checkuv pressed  do
	(
		x90= $.transform*Matrix3[1,0,0][0,0,1][0,-1,0][0,0,0]
		Format "rout % \n" x90
		Print x90.row1.x
		Pos=#()
		Rot=#()
		if classof $.pos.controller!= Position_List do (
			print "rrrrrr"
			return	null
		)
		pt=listCtrl.getActive $.pos.controller
		cname=ListCtrl.getName $.pos.controller pt
		print cname
		if cname!="Path Constraint" do (
			print "ddddffff"
			return null
		)
		pc=$.pos.controller.Path_Constraint.controller.path
	
		startTime = AnimationRange.Start
		endTime = AnimationRange.End
		m=pc.transform.position
		--Print "r2"
		--Print r2
	--	Print "\n"
		--Print startTime
		for i=startTime to endTime do(
			sliderTime=i
			v=$.transform.position
			--print v
			v2=v-m
	
			--Format "v:%  m:%" v m
			f=v2*(inverse pc.transform)
			--Print f
			--Print m
			--Print v
			if abs f.x<0.001 do (
				f.x=0
			)
			if abs f.y<0.001 do (
				f.y=0
			)
			if abs f.z<0.001 do (
				f.z=0
			)

			append Pos f
			print f
			tram=$.transform*(inverse pc.transform)
			rr=quatToEuler(tram.rotationPart)

			if abs rr.x<0.001 do (
				rr.x=0
			)
			if abs rr.y<0.001 do (
				rr.y=0
			)
			if abs rr.z<0.001 do (
				rr.z=0
			)

			--Print rr
			append Rot rr
		)

		path="C:\Users\Administrator\Desktop"
		file=(path+"/"+(getFilenameFile maxFileName)+"_path.json")
		deleteFile file
		str=createfile file
		Format ("{\n") to:str
		Format "\"Pos\": \n" to:str
		Format "[ \n" to:str
		for j=1 to Pos.count do (
			Format ("{\n") to:str
			Format ("\"x\":"+Pos[j].x as string+",\n") to:str
			Format ("\"y\":"+Pos[j].y as string+",\n") to:str
			Format ("\"z\":"+Pos[j].z as string+"\n") to:str
		
			if j<Pos.count then(
				Format ("},\n") to:str
			)else(
				Format ("}\n") to:str
			)
			Print j
		--	Format ( Pos[j] as string+"\n") to:str

		)
	
		Format "],\n" to:str
		
		--rot
		Format "\"Rot\": \n" to:str
		Format "[ \n" to:str
		for j=1 to Pos.count do (
			Format ("{\n") to:str
			Format ("\"x\":"+Rot[j].x as string+",\n") to:str
			Format ("\"y\":"+Rot[j].y as string+",\n") to:str
			Format ("\"z\":"+Rot[j].z as string+"\n") to:str
		
			if j<Pos.count then(
				Format ("},\n") to:str
			)else(
				Format ("}\n") to:str
			)
			Print j
		)
		Format "]\n" to:str
		--rot end
		Format ("}\n") to:str
		close str
		

		x90= pc.transform*Matrix3[1,0,0][0,0,-1][0,1,0][0,0,0]
		

	)
)
createdialog dd 
