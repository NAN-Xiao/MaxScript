rollout exporttool "Export Tools" width:280 height:181
(
	button 'export' "Export    FBX" pos:[16,85] width:247 height:52 align:#left
	button 'folder' "Path" pos:[209,40] width:43 height:29 align:#left
	editText 'path' "" pos:[23,43] width:171 height:22 align:#left
	groupBox 'grp7' "save path" pos:[15,16] width:250 height:65 enabled:false align:#left
	on folder pressed  do
(
		folderPath = getSavePath()
		edt_path.text = folderPath
	)
)