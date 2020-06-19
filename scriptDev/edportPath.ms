rollout dd  "Untitled" width:162 height:300
(
	button 'checkuv' "checkuv" pos:[13,26] width:142 height:47 enabled:true align:#left
	on checkuv pressed  do
	(
	
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
		Print pc
		Pos=#()
		Rot=#()
		startTime = AnimationRange.Start
		endTime = AnimationRange.End
		m=pc.position
		r=pc.transform.rotationPart
		r2=inverse r
		for i=startTime to endTime do(
			sliderTime=i
			v=$.transform.pos
			v2=v-m
			f=v2*r2
			if f.x<0.0001 do(
				f.x=0
			)
			if f.y<0.0001 do(
				f.y=0
			)
			if f.z<0.0001 do(
				f.z=0
			)
			append Pos f
			rt=quatToEuler2 ($.transform.rotation*r2)
			append Rot rt
		)

		if Pos.count!=Rot.count do (
			print "Poskey count != rot key count"
			return null
		)
		for i=1 to Pos.count do (
			print Pos[1]
		)

	)
)
createdialog dd 
