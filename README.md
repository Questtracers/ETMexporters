# Export Script
## System explanation
This is one of the coolest features of the program, I coded the export manager in a way that everybody can write its own exporters and publish them as plugins, this is a complex thing and if you are only interested on mapping you can skip this. If you want to add support to other platform keep reading this section explains how the export scripting works.

The basics are simple:

1. ETM has several data contained in several exporting variables
2. There are functions that call this data
3. You can replace keystrings by this data on any type of code or textfile

Lets see an example with Lua Love 2D code

```lua
maploadedList = {MAP_LIST}

function initialLoad()
  for i, V in pairs(maploadedList) do
    local decodedAux = dofile(V)
    table.insert(decodedList,decodedAux)
    table.insert(imgList,love.graphics.newImage(decodedAux["img"]))
  end
end
```

maloadedList is the list of the maps jsons urls, in order to do this we need to set the following rules to the json

```json
{
	"id" : "MAP_LIST",
	"content" : "\"<MAPFOLDERS><MAPNAMES>.lua\",",
	"params" : "removeLastCharacter",
	"type" : "write_map"
}
```

This will replace the MAP_LIST by the list of maps, but that list will be composed by the variables <MAPFOLDERS> and <MAPNAMES> followed by .lua
The type "write_map" means that is going to go throught the list of maps and concatenate the text inside content
The param "removeLastCharacter" will remove the last "," of the concatenated text

So we need two new rules for this

```json
{
	"id" : "<MAPFOLDERS>",
	"content" : "",
	"params" : "foldermap",
	"type" : "map_index"
},
{
	"id" : "<MAPNAMES>",
	"content" : "",
	"params" : "mapnames",
	"type" : "map_index"
}
```

This two new rules are used to replace the text inside MAP_LIST.

Both rules are "map_index" it means it will run throught the list of maps.
First rule is param "foldermap" it means it will only display the folder assigned to the map but without the name
Second rule is param "mapnames" it means it will display the name of the map but without the extension

So, the second rules replace the text per iteration in the map list of the first rule so it composes something like this

```lua
maploadedList = {"love2d_maps/Map1.lua,love2d_maps/Map2.lua"}
```

There are rules to define the map folder too and to transform the jsons into lua files (so they dont take forever to load), but that will be explained later.

Take note that the structure of the rules are always something like this:

- **Id:** Its the key that is going to be searched and replaced, its recomended to use always some weird characters to encapsulate them
- **Content:** I normally assigned this to the things to write, but some rules dont have this or are calling internal values from ETM so some of them are blank
- **Params:** It contains part of the instruction or changes in the instruction behaviour
- **Type:** It contains the base instruction, the combination with types and params is what composes the action ETM gets to generate the modified files

These rules are in the codexportsrules files in ETM, they are jsons that contains the following:

- **Id:** It needs to be called in the same way as the file
- **RemoveFolder:** It tells ETM to remove the folder before exporting it again
- **Warning:** Its the warning that is displayed after exporting
- **Codexports:** Its the set of rules

Then in the folder codeexports inside ETM you have the folders with the source codes of each exporter, the idea is to add the ids of the rules inside the sourcecodes, ETM will make the replacements when exporting.

The export script allows to do several things, but if you need anything for your exporter contact me and I will add the functionality.

## List of instructions
### img_index
The img_index type instruction is one of the most importants is the instruction that is used to pour ETM data to the export process, depending on the param the instruction will return one thing or another

#### Param imgnames
```json
{
	"id" : "IMGNAMES",
	"content" : "",
	"params" : "imgnames",
	"type" : "img_index"
}
```
Param "imgnames" stores in id all the names of the images without it extension

#### Param numbers
```json
{
	"id" : "IMG_COUNTER",
	"content" : "",
	"params" : "numbers",
	"type" : "img_index"
}
```
Param "numbers" stores numbers from 1 to the amount of images into the id

#### Param uuid
```json
{
	"id" : "IMG_TERCER_UUID",
	"content" : "",
	"params" : "uuid",
	"type" : "img_index"
}
```
Param "uuid" stores random uuids for each image
The format of the uuids is this one eda3499d-6061-9543-9694-601509ed3e69

!> If you want to store uuids without hyphens instead of uuid use uuidnohyphen as a param

#### Param url
```json
{
	"id" : "IMGURL",
	"content" : "",
	"params" : "url",
	"type" : "img_index"
}
```
Param "url" stores the whole url of the image relative to the project in the variable id, it also includes the name and the format of the image

#### Param file
```json
{
	"id" : "IMGNAMESFORMAT",
	"content" : "",
	"params" : "file",
	"type" : "img_index"
}
```
Param "file" stores the name of the image plus its format, normaly name.png into the variable in id.

#### Param folderimg
```json
{
	"id" : "IMGFOLDERURL",
	"content" : "",
	"params" : "folderimg",
	"type" : "img_index"
}
```
Param "folderimg" stores the url relative to the project of each image but without inlcuding the name of the image on varaible id

#### Param imgwidth, imgheight
```json
{
	"id" : "IMG_VALWIDTH",
	"content" : "",
	"params" : "imgwidth",
	"type" : "img_index"
}
```
Param "imgwidth" or "imgheight" stores the sizes of the image on the variable id

#### Param mapnames
Same as the imgnames in image

Param "mapnames" stores in id all the names of the maps without it extension

### map_index
This is the same as img_index but for maps, its used to get data from ETM and store it on varaibles that can be used by the exporter

#### Param url
Same as the one in image

Param "url" stores the whole url of the map relative to the project in the variable id, it also includes the name and the format of the image

#### Param numbers
Same as the one in image

Param "numbers" stores numbers from 1 to the amount of maps into the id

#### Param uuid
Same as the one in image

Param "uuid" stores random uuids for each map
The format of the uuids is this one eda3499d-6061-9543-9694-601509ed3e69

!> If you want to store uuids without hyphens instead of uuid use uuidnohyphen as a param

#### Param foldermap
Same as the folderimg in image

Param "foldermap" stores the url relative to the project of each map but without inlcuding the name of the map on varaible id

#### Param file
Same as the one in image

Param "file" stores the name of the map plus its format, normaly name.json into the variable in id.

### file_map, file_img
```json
{
	"id" : "FOLDER_CREATE_MAP_FILES",
	"content" : "MAPURL",
	"params" : "",
	"type" : "file_map"
}
```
Type "file_map" this creates the map file on whatever text is in MAPURL it does this action per map
Type "file_img" does the same but it creates the image

!> Be aware the content can be more complex, check the following example done for type file_img

```json
{
	"id" : "FOLDER_CREATE_IMG_LAYERS",
	"content" : "sprites/IMGNAMES/layers/IMG_UUIDS/IMG_LAYERS_UUID.png",
	"params" : "",
	"type" : "file_img"
}
```

Here we compose the content url by using static words like "sprites" or "layers" and different calls to the image data, even we rename the resulting png to other thing contained in IMG_LAYERS_UUID and not the original image name

### folder_map, folder_img
```json
{
	"id" : "FOLDER_CREATE_IMG_NAMES",
	"content" : "sprites/IMGNAMES/layers/IMG_UUIDS/",
	"params" : "",
	"type" : "folder_img"
}
```
Type "folder_map" this creates a folder per map on the url specified in content
Type "folder_img" does the same but it does it per image

These parameters are not very useful cause when you set an url in the file_map and file_img types it creates a folder if it doesnt find it, but they are included just in case someone finds them useful.

### write_map, write_img
```json
{
	"id" : "MAP_LIST",
	"content" : "\"<MAPFOLDERS><MAPNAMES>.lua\",",
	"params" : "removeLastCharacter",
	"type" : "write_map"
}
```
Type "write_map" replaces the keyword defined in id by the text defined in content and it does this per map
Type "write_img" does the same per image
Param "removeLastCharacter" removes the final character of the generated text, usually used to remove the last comma in arrays

### bulk_maps, bulk_imgs
```json
{
	"id" : "love2d_maps",
	"content" : "",
	"params" : "",
	"type" : "bulk_maps"
}
```
Type "bulk_maps" defines the initial folder used by the file_map instruction, in file_map instruction the id of this instruction will be added before the content of the file_map data in order to generate the final map url
Type "bulk_imgs" does the same but with the file_img function

These parameters are not very useful as the whole url can be defined in the file_map and file_img instructions, will probably deprecated soon but they are used already on the actual exporters

### type_export
```json
{
	"id" : "lua",
	"content" : "",
	"params" : "",
	"type" : "type_export"
}
```
Type "type_export" tells ETM to code the maps in other format than json, the new format will be the one defined in id. Right now the only format available appart from json is lua. If people ask for more I will add support for them.

### Savefile
```json
{
	"id" : "SAVE_FILE_IMGYY",
	"content" : "",
	"params" : "no copy",
	"type" : "savefile"
}
```
Param "no copy" avoids copying the file to the exported folder
Type "savefile" saves the file in cache to modify it or copying it more than once
This instruction saves the file called SAVE_FILE_IMGY

### export_file_img
```json
{
	"id" : "EXPORT_FILE_IMGYY",
	"content" : "sprites/IMGNAMES/IMGNAMES.yy",
	"params" : "SAVE_FILE_IMGYY",
	"type" : "export_file_img"
}
```
Type "export_file_img" export the saved file specified in params as many times as images are in the url set in content

!> Before being exported, it also checks inside the file and replaces any write_img per image

!> export_file_map will be done anytime soon if requested

### operator
```json
{
	"id" : "OPERATOR_SECOND_VALHEIGHT",
	"content" : "IMG_SECOND_VALHEIGHT",
	"params" : "-1",
	"type" : "operator"
}
```
Type "operator" sums the value set in params to a type img_index or map_index instruction and store the result in id

This is useful cause some engines has different types of index or representation of values.
