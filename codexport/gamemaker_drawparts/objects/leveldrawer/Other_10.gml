/// @description Insert description here
// You can write your code in this editor


file = file_text_open_read(fileList[mapID]);
sjson = ""
//ds_list_destroy(chipsetQuads)
//ds_list_destroy(chipsetAnims)
//ds_map_destroy(jsonMap)

while (!file_text_eof(file))
{
	sjson = sjson + file_text_read_string(file)
	file_text_readln(file)
}
file_text_close(file)

jsonMap = json_decode(sjson);

show_debug_message("showing json variables")
chipsetIMG = ds_map_find_value(jsonMap,"img")
show_debug_message(chipsetIMG)
tileSizeW  = ds_map_find_value(jsonMap,"tilesizeW")
tileSizeH = ds_map_find_value(jsonMap,"tilesizeH")
mapSizeW = ds_map_find_value(jsonMap,"mapSizeW")
mapSizeH = ds_map_find_value(jsonMap,"mapSizeH")

show_debug_message(chipsetIMG)
strLastPos = string_last_pos("/",chipsetIMG)
strAux = string_copy(chipsetIMG,strLastPos+1,string_length(chipsetIMG)-strLastPos-4)
show_debug_message(strAux)
chipsetIMGsprite = asset_get_index(strAux);

imgSizeW = sprite_get_width(chipsetIMGsprite)
imgSizeH = sprite_get_height(chipsetIMGsprite)

chipsetQuads = ds_list_create()
chipsetAnims = ds_list_create()

var counter =0

for (var auxY = 0; auxY < imgSizeH/(tileSizeH/2); auxY+=1)
{
	for (var auxX = 0; auxX < imgSizeW/(tileSizeW/2); auxX += 1)
	{
		auxMap = ds_map_create()
		ds_map_add(auxMap,"x",auxX*tileSizeW/2)
		ds_map_add(auxMap,"y",auxY*tileSizeH/2)
		ds_list_add(chipsetQuads,auxMap)
		
		var inserted = 0
	
		aniSplit = ds_map_find_value(jsonMap,"ANISplit")
		for (var i=0; i<ds_list_size(aniSplit); i+=1)
		{
			auxMap = ds_list_find_value(aniSplit,i)
			
			if counter = ds_map_find_value(auxMap,"idChipset")
			{
				ds_list_add(chipsetAnims,ds_map_find_value(auxMap,"idAnimation"))
				show_debug_message("inserted: "+string(ds_map_find_value(auxMap,"idAnimation")))
				inserted = 1
			}
		}
		
		if inserted = 0
		{
			ds_list_add(chipsetAnims,0)
			show_debug_message("inserted: 0")
		}
		
		counter = counter +1
	}
}

blank1 = ds_map_find_value(jsonMap,"blank1")
blank2 = ds_map_find_value(jsonMap,"blank2")
blank3 = ds_map_find_value(jsonMap,"blank3")
blank4 = ds_map_find_value(jsonMap,"blank4")

layergroups = ds_map_find_value(jsonMap,"layerGroups")
listAnimFrames = ds_map_find_value(jsonMap,"listAnimFrames")

mapColisions = ds_map_find_value(jsonMap,"colisionMap")
for (var i =0; i <ds_list_size(mapColisions); i+=1)
{
	auxVal = ds_list_find_value(mapColisions,i);
	//show_debug_message(auxVal);
}




//show_debug_message(ds_map_is_list(jsonMap,"listAnimFrames"))

mapObjects = ds_map_find_value(jsonMap,"objects")
for (var i = 0; i< ds_list_size(mapObjects); i+=1)
{
	auxMap = ds_list_find_value(mapObjects,i);
	auxVal = ds_map_find_value(auxMap,"objectID")
	//show_debug_message("objectID: "+string(auxVal))
	auxVal = ds_map_find_value(auxMap,"coordX")
	//show_debug_message("coordX: "+string(auxVal))
	auxVal = ds_map_find_value(auxMap,"coordY")
	//show_debug_message("coordY: "+string(auxVal))
}

show_debug_message("last check")
show_debug_message(ds_map_find_value(jsonMap,"img"));

show_debug_message("list chipanims")
show_debug_message(ds_list_size(chipsetAnims))