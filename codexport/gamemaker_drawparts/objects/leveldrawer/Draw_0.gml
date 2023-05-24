/// @description Insert description here
// You can write your code in this editor


	for (var i = 0; i<ds_list_size(layergroups); i+=1)
	{
		auxMap = ds_list_find_value(layergroups,i)
		auxList = ds_map_find_value(auxMap,"layer")
	
		for (var b = 0; b<ds_list_size(auxList); b+=1)
		{
			coordX = b % mapSizeW
			coordY = floor(b/mapSizeW)
		
			auxMap = ds_list_find_value(auxList,b)
			topIzq = ds_map_find_value(auxMap,"topIzq")
			topDer = ds_map_find_value(auxMap,"topDer")
			botIzq = ds_map_find_value(auxMap,"botIzq")
			botDer = ds_map_find_value(auxMap,"botDer")
			
			topizqAni = ds_list_find_value(chipsetAnims,topIzq)
			topderAni = ds_list_find_value(chipsetAnims,topDer)
			botizqAni = ds_list_find_value(chipsetAnims,botIzq)
			botderAni = ds_list_find_value(chipsetAnims,botDer)
			
			arrtopizq = ds_map_find_value(ds_list_find_value(listAnimFrames,topizqAni),"arr")
			sizetopizqani = ds_list_size(arrtopizq)
			arrtopder = ds_map_find_value(ds_list_find_value(listAnimFrames,topderAni),"arr")
			sizetopderani = ds_list_size(arrtopder)
			arrbotizq = ds_map_find_value(ds_list_find_value(listAnimFrames,botizqAni),"arr")
			sizebotizqani = ds_list_size(arrbotizq)
			arrbotder = ds_map_find_value(ds_list_find_value(listAnimFrames,botderAni),"arr")
			sizebotderani = ds_list_size(arrbotder)
		
			topIzq = topIzq + ds_list_find_value(arrtopizq,floor(frame % sizetopizqani))
			topDer = topDer + ds_list_find_value(arrtopder,floor(frame % sizetopderani))
			botIzq = botIzq + ds_list_find_value(arrbotizq,floor(frame % sizebotizqani))
			botDer = botDer + ds_list_find_value(arrbotder,floor(frame % sizebotderani))
		
			auxMap = ds_list_find_value(chipsetQuads,topIzq)
			xquad = ds_map_find_value(auxMap,"x")
			yquad = ds_map_find_value(auxMap,"y")
		

				if (blank1 != topIzq)
					draw_sprite_part(chipsetIMGsprite, 0, xquad, yquad, tileSizeW/2, tileSizeH/2,
						coordX*tileSizeW, coordY*tileSizeH)
		
				auxMap = ds_list_find_value(chipsetQuads,topDer)
				xquad = ds_map_find_value(auxMap,"x")
				yquad = ds_map_find_value(auxMap,"y")
		
				if (blank2 != topDer)
					draw_sprite_part(chipsetIMGsprite, 0, xquad, yquad, tileSizeW/2, tileSizeH/2,
						coordX*tileSizeW + tileSizeW/2, coordY*tileSizeH)
			
				auxMap = ds_list_find_value(chipsetQuads,botIzq)
				xquad = ds_map_find_value(auxMap,"x")
				yquad = ds_map_find_value(auxMap,"y")
		
				if (blank3 != botIzq)
					draw_sprite_part(chipsetIMGsprite, 0, xquad, yquad, tileSizeW/2, tileSizeH/2,
						coordX*tileSizeW, coordY*tileSizeH + tileSizeH/2)
			
				auxMap = ds_list_find_value(chipsetQuads,botDer)
				xquad = ds_map_find_value(auxMap,"x")
				yquad = ds_map_find_value(auxMap,"y")
		
				if (blank4 != botDer)
					draw_sprite_part(chipsetIMGsprite, 0, xquad, yquad, tileSizeW/2, tileSizeH/2,
						coordX*tileSizeW + tileSizeW/2, coordY*tileSizeH + tileSizeH/2)

			
			if i == ds_list_size(layergroups)-1
			{
			
				if (showColisions) 
				{
					tileColision = ds_list_find_value(mapColisions,b)
					if (tileColision > 0)
					{
						draw_set_color(c_black)
						draw_set_alpha(0.5)
						draw_rectangle(coordX*tileSizeW, coordY*tileSizeH,
							coordX*tileSizeW+tileSizeW, coordY*tileSizeH+tileSizeH,false)
						draw_set_color(c_white)
						draw_set_alpha(1)
						draw_text(coordX*tileSizeW, coordY*tileSizeH,tileColision)
					}
				}
			
				if (showObjects)
				{
					for (var z = 0; z< ds_list_size(mapObjects); z+=1)
					{
						auxMap = ds_list_find_value(mapObjects,z)
						if (coordX == ds_map_find_value(auxMap,"coordX")) && 
							(coordY == ds_map_find_value(auxMap,"coordY"))
						{
							draw_set_color(c_black)
							draw_set_alpha(0.5)
							draw_rectangle(coordX*tileSizeW, coordY*tileSizeH,
								coordX*tileSizeW+tileSizeW, coordY*tileSizeH+tileSizeH,false)
							draw_set_color(c_white)
							draw_set_alpha(1)
							draw_text(coordX*tileSizeW, coordY*tileSizeH,ds_map_find_value(auxMap,"objectID"))
						}	
					}
				}
			}
		}
	}




draw_text(10,400,"Map: "+string(fileList[mapID]))
draw_text(10,425,"Toggle Objects (tap E): "+string(showObjects))
draw_text(10,450,"Toggle Colisions (tap R): "+string(showColisions))
draw_text(10,475,"Change map (tap W)")
draw_text(10,500,"Img loaded: "+string(chipsetIMG))