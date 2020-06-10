rollout exporttool "Export Tools" width:296 height:168
(
	button 'export' "Export    FBX" pos:[15,97] width:264 height:52 align:#left
	button 'folder' "....." pos:[228,37] width:34 height:29 align:#left
	editText 'path' "" pos:[24,40] width:199 height:22 align:#left
	groupBox 'grp7' "save path" pos:[15,16] width:264 height:65 enabled:false align:#left
	on folder pressed  do
(
		folderPath = getSavePath()
		edt_path.text = folderPath
	)
)