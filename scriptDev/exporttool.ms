rollout exporttool "Export Tools" width:272 height:168
(
	button 'export' "Export    FBX" pos:[13,97] width:245 height:52 align:#left
	button 'folder' "....." pos:[214,37] width:34 height:29 align:#left
	editText 'path' "" pos:[23,40] width:177 height:22 align:#left
	groupBox 'grp7' "save path" pos:[15,16] width:245 height:65 enabled:false align:#left
	on folder pressed  do
(
		folderPath = getSavePath()
		edt_path.text = folderPath
	)
)