sel=getCurrentSelection()
if sel.count<=0 then
(
    Print("not selected any objects")
)
for i=1 to sel.count do
(
    obj=sel[i]
    modPanel.setCurrentObject(obj)
    macros.run "Modifier Stack" "Convert_to_Poly"
    convertToPoly obj
    polyOps.removeIsolatedVerts obj
)
 