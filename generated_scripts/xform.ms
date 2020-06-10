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
    obj.position=[0,0,0]
)
 