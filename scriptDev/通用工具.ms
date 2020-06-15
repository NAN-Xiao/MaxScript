rollout Utilty "Utilty Tools" width:272 height:637
(
	button 'resetBtn' "ResetXForm" pos:[31,21] width:100 height:30 align:#left
	button 'checkmat' "CheckMat" pos:[31,65] width:100 height:30 align:#left
	groupBox 'grp6' "Pivot" pos:[29,155] width:214 height:108 align:#left
	button 'movepivot' "ResetPivot" pos:[46,209] width:188 height:39 align:#left
	button 'btn17' "UV2  OutSide" pos:[142,65] width:100 height:30 align:#left
	checkbox 'salpha' "alpha" pos:[183,303] width:46 height:23 checked:false align:#left
	checkbox 'suv2' "uv2" pos:[37,303] width:60 height:23 checked:false align:#left
	checkbox 'scolor' "color" pos:[110,303] width:55 height:23 align:#left
	groupBox 'grp7' "ClearChannel" pos:[29,280] width:214 height:142 align:#left
	button 'chabtn' "ClearChannel" pos:[42,368] width:188 height:39 align:#left
	button 'movepos' "MoveZero" pos:[142,21] width:100 height:30 align:#left
	checkbox 'sanima' "animation" pos:[37,328] width:60 height:23 enabled:true checked:false align:#left
	button 'removevertex' "RemoveIsolabedVertex" pos:[31,110] width:100 height:30 align:#left
	radioButtons 'pivotselect' "" pos:[45,176] width:168 height:16 enabled:true labels:#("buttom", "top", "world") columns:3 align:#left
	button 'UnWrapuv2' "UnWrap  LightUV" pos:[142,110] width:100 height:30 align:#left
)