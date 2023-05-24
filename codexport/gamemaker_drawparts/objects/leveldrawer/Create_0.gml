/// @description Insert description here
// You can write your code in this editor

frame = 0
animation_speed = 0.05
animation_timer = 0

showObjects = false
showColisions = false
mapID = 0

fileList = []
GML_ADD_MAPS

for (var i =0; i < array_length(fileList); i++)
{
	fileList[i] = string_delete(fileList[i],1,string_length("datafiles/"))
}

event_user(0);

drawall = true;

