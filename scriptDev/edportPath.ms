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
		r=pc.transform.rotationPart
	

	
		r2=inverse r

		Print "r2"
		Print r2
		Print "\n"
		Print endTime
		for i=startTime to endTime do(
			sliderTime=i
			v=$.transform.position
			--print v
			v2=v-m
		--	Format "v:%  m:%" v m
			f=v2*r2
			if abs f.x<0.001 do (
				f.x=0
			)
			if abs f.y<0.001 do (
				f.y=0
			)
			if abs f.z<0.001 do (
				f.z=0
			)
			Print f
			append Pos f
			--print f
			--rr=quatToEuler($.transform.rotation*r2)
		--	Print rr
			--append Rot rot
		)

		--if Pos.count!=Rot.count do (
		--	print "Poskey count != rot key count"
			--return null
	--	)
		for i=1 to Pos.count do (
		--	print Rot[i]
		--	Print Pos[i]
		)
		
		m90= pc.transform*Matrix3[1,0,0][0,0,-1][0,1,0][0,0,0]
		

	)
)
createdialog dd 
