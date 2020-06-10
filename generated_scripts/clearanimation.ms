sel=getCurrentSelection()
if sel.count<=0 then
(
    Print("not selected any objects")
)
for i=1 to sel.count do
(
    obj=sel[i]
    modPanel.setCurrentObject(obj)
    deleteKeys obj.pos.controller
    deleteKeys obj.scale.controller
    deleteKeys obj.rotation.controller
   
)
 