	-- Normal Thief  v1.0

-- By Mauricio B. G. 
-- mbg@southlogic.com
-- 02/04

----------------------------------------------------------------
--cb = coordenada base
--ct = coordenada target
--dist = distancia entre cb/ct
--menordist = obvio :)
--normalt = normal do vert mais proximo
--ref - objeto de referencia - depois conteudo do pick button
----------------------------------------------------------------


rollout normal_thief "Normal Thief 1.0 +" width:258 --height:167
(

	groupbox grp1 "Instructions" width: 229 height: 105
	label lb1 "1." pos:[20, 28] width:24 height:24
	pickbutton pick "< Pick Reference Object >" pos: [34, 24] width:190
	label lbl2 "2. Select objects to change normals. [mesh]" pos:[20, 54] width:216 height:16
	label lbl3 "3." pos:[20, 80] width:24 height:24
	button btn "<< - A C T I O N - >>" enabled:false pos:[35, 76] width:190
	groupBox grp2 "Extra Options" pos:[13, 115] width:229 height:60
	checkbox xf_check "Add XForm under Edit Normals" checked:false pos:[24, 133]
	checkbox col_check "Add XForm and Collapse Stack" checked:false pos:[24, 151]
	groupBox grp3 pos:[13, 180] width:229 height:90
	label label "Current Vert:" pos:[20, 192] width:216
	progressbar progress_vert width:210 offset:[8, 0] color:( color 0 100 240 ) 
	label label2 "Current Obj:" pos:[20, 230] width:216
	progressbar progress_obj width:210 offset:[8, 0] color:( color 211 0 0 ) 
	label lb_last "Normal Thief by Mauricio B. G." align:#right offset:[-3, 6]


	-- pick stuff e validação
	on pick picked refmesh do (

		modPanel.setCurrentObject pick.object.baseObject
		if classof pick.object != Editable_mesh then (
			messagebox "Object should be Editable Mesh !" title: "Normal Thief"
			btn.enabled = false
			pick.caption = "< Pick Reference Object >"
		)
		else (
			pick.text = "Reference -> " + refmesh.name
			btn.enabled = true
		)
	)

	-- faz um check desligar o outro
	on xf_check changed theState do col_check.state = off
	on col_check changed theState do xf_check.state = off


	on btn pressed do
	(
		
		-- clear stats 
		label.caption = "Current Vert:"
		progress_vert.value = 0
		label2.caption = "Current Obj:"
		progress_obj.value = 0
		--

		sel = getcurrentselection() -- objs selecionados 
		try ( -- validação, se der erro lá no fim um catch resolve tudo

			disableSceneRedraw() -- to speed up things...

			For obj = 1 to sel.count do ( -- start for 1    -- percorre todos objs selec
				select sel[obj] --seleciona obj 
				
				sai_fora = 0 -- validação se tem edit normals p/ remover abaixo
				
				-- if checked ...
				if col_check.checked == true then ( -- then 1
					ResetXform sel[obj]	
					CollapseStack sel[obj]
					addmodifier sel[obj] ( editnormals())
				) -- close then 1
				else ( -- else 1
					if xf_check.checked == true then ( -- then 2
						try ( modPanel.setCurrentObject sel[obj].edit_normals ) catch ( -- catch
							-- caso ele nao tiver edit normals
							ResetXform sel[obj]	-- MAX 6 only
							addmodifier sel[obj] ( editnormals())
							sai_fora = 1 -- sai fora do if
						) -- end catch
						if sai_fora == 0 then ( -- then 3
							deletemodifier sel[obj] 1
							ResetXform sel[obj]	-- MAX 6 only
							addmodifier sel[obj] ( editnormals())
						) -- close then 3
					) -- close then 2
				) -- close else 1	


				
				-- unify and explicit all base verts
				max modify mode 
				-- se nao tem edit normals, coloca
				try ( modPanel.setCurrentObject sel[obj].edit_normals ) catch ( addmodifier sel[obj] ( editnormals()) )

				subobjectlevel = 1
				max select all
				sel[obj].modifiers[#Edit_Normals].EditNormalsMod.Unify ()
				sel[obj].modifiers[#Edit_Normals].EditNormalsMod.MakeExplicit ()
				
				



				For x = 1 to sel[obj].numverts do ( -- start for 2    -- percorre toda malha base -- que tera as normais alteradas
					
					------------------------------------------
					-- begin core code
					


					modPanel.setCurrentObject sel[obj].baseObject -- tem que ir p/ base p/ ler vert position
					cb = getvert sel[obj] x -- take current base vert position
					
					modPanel.setCurrentObject pick.object.baseObject
					ct = getvert pick.object 1
					
					--default valor menordist
					menordist = ( cb.x - ct.x ) * ( cb.x - ct.x ) + ( cb.y - ct.y ) * ( cb.y - ct.y ) + ( cb.z - ct.z ) * ( cb.z - ct.z ) 
					-- se nao tem edit normals, coloca
					try ( modPanel.setCurrentObject pick.object.edit_normals ) catch ( addmodifier pick.object ( editnormals()) ) -- tem que ir p/ edit normal p/ pegar normal stuff


					-- conversao, pegando a normal correta
					vertn = 1
					vert_array = #{ vertn }
					normal_array = #{ }
					pick.object.Edit_Normals.ConvertVertexSelection &vert_array &normal_array
					normal_result = normal_array as array -- vira array normal p/ poder ler embaixo
					--
					
					if	col_check.checked == false and xf_check.checked == false then (
						normalt = pick.object.modifiers[#Edit_Normals].EditNormalsMod.Getnormal normal_result[1] * sel[obj].rotation -- default valor normalt, multiplica rotation p/ corrigir rotação
					)
					else (
						normalt = pick.object.modifiers[#Edit_Normals].EditNormalsMod.Getnormal normal_result[1]
					)
					
					modPanel.setCurrentObject pick.object.baseObject
					
					

					For i = 2 to pick.object.numverts do ( --start for 3  	-- percorre toda malha reference
						
						ct = getvert pick.object i
						dist = ( cb.x - ct.x ) * ( cb.x - ct.x ) + ( cb.y - ct.y ) * ( cb.y - ct.y ) + ( cb.z - ct.z ) * ( cb.z - ct.z ) 
						
						if dist < menordist then ( -- testa se esta mais proximo
							menordist = dist
							modPanel.setCurrentObject pick.object.edit_normals -- tem que ir p/ edit normal p/ pegar normal stuff
							-- conversao
							vertn = i
							vert_array = #{ vertn }
							normal_array = #{ }
							pick.object.Edit_Normals.ConvertVertexSelection &vert_array &normal_array
							normal_result = normal_array as array -- vira array normal p/ poder ler embaixo
							--
							
							if	col_check.checked == false and xf_check.checked == false then (
								normalt = pick.object.modifiers[#Edit_Normals].EditNormalsMod.Getnormal normal_result[1] * sel[obj].rotation -- default valor normalt, multiplica rotation p/ corrigir rotação
							)
							else (
								normalt = pick.object.modifiers[#Edit_Normals].EditNormalsMod.Getnormal normal_result[1]
							)
							

							modPanel.setCurrentObject pick.object.baseObject
							
							--label.caption = i as string	-- mostra vertice atualmente mais proximo, teste
						) -- end if

						
						
					) -- end for 3
					
					modPanel.setCurrentObject sel[obj].edit_normals -- tem que ir p/ edit normal p/ pegar normal stuff
					
					-- conversao
					vertn = x -- depois trocar por x quando acionar outro for
					vert_array = #{ vertn }
					normal_array = #{ }
					sel[obj].Edit_Normals.ConvertVertexSelection &vert_array &normal_array
					normal_result = normal_array as array -- vira array normal p/ poder ler embaixo
					--
					
					sel[obj].modifiers[#Edit_Normals].EditNormalsMod.Setnormal normal_result[1] normalt -- aplica normal no vertice atual

					-- show stats
					label.caption = "Current Vert:" + x as string + "/" + sel[obj].numverts as string
					progress_vert.value = 100. * x / sel[obj].numverts
					
					-- end core code
					------------------------------------------
					
				) -- end for 2	


				subobjectlevel = 0
				
				-- show stats obj
				label2.caption = "Current Obj:" + obj as string + "/" + sel.count as string
				progress_obj.value = 100. * obj / sel.count

				sel[obj].modifiers[#Edit_Normals].showHandles = on
				
			) -- end for 1

			label.caption = "Done"
			label2.caption = "Done"
			
			enableSceneRedraw() 
			-- end try
		) catch ( enableSceneRedraw()
			messagebox "Error! All objects should be Editable Mesh!" title: "Normal Thief" ) 


	) -- end button

) -- end rollout

createdialog normal_thief





