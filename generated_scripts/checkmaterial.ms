sel=getCurrentSelection()
all=#()
if sel.count<=0 then
(
    Print("not selected any objects")
)
for i=1 to sel.count do
(
	obj=sel[i]
    modPanel.setCurrentObject(obj)

    if (classof obj.material ==Multimaterial) then 
   (
    append all obj
    )
    if( classof obj.material==UndefinedClass)then 
    (
    append all obj
     )
)

if (all.count>1) then (
    
    Print(all.count)
)
 