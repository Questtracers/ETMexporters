require('math')


maploadedList = {MAP_LIST}
maploaded = ""
decodedList = {}
imgList = {}

showColision = 0
showObjects = 0
idMap = 1

function initialLoad()
  for i, V in pairs(maploadedList) do
    local decodedAux = dofile(V)
    table.insert(decodedList,decodedAux)
    table.insert(imgList,love.graphics.newImage(decodedAux["img"]))
  end
end

function mapLoad(mapid)
  --contents, size = love.filesystem.read(maploaded)
  chipsetQuads = {}
  chipsetAnims = {}
  decoded = {}
  collectgarbage()
 
  decoded = decodedList[mapid]
  maploaded = maploadedList[mapid]
  
  chipsetIMG = decoded["img"]
  tileSizeW = decoded["tilesizeW"]
  tileSizeH = decoded["tilesizeH"]
  mapSizeW = decoded["mapSizeW"]
  mapSizeH = decoded["mapSizeH"]
  
  blank1 = decoded["blank1"]+1
  blank2 = decoded["blank2"]+1
  blank3 = decoded["blank3"]+1
  blank4 = decoded["blank4"]+1
  
  --chip = love.graphics.newImage(chipsetIMG)
  chip = imgList[mapid]
  imgSizeW = chip:getWidth()
  imgSizeH = chip:getHeight()
  
  -- Creating the inventory of Quads/tile to show from chip
  -- Also creating the assignations to the differents animations for each quad/tile
  
  local counter = 0
  
  for y = 1,imgSizeH/(tileSizeH/2) do
    for x = 1, imgSizeW/(tileSizeW/2) do
      local newQuad = love.graphics.newQuad((x-1)*tileSizeW/2,(y-1)*tileSizeH/2,tileSizeW/2,tileSizeH/2,imgSizeW,imgSizeH)
      table.insert(chipsetQuads,newQuad)
      
      local inserted = 0
      
      for i, V in pairs(decoded.ANISplit) do
        if counter == V["idChipset"] then
          --print("insert",counter,i,V["idChipset"],V["idAnimation"])
          table.insert(chipsetAnims,V["idAnimation"])
          inserted = 1
        end
      end
      
      if inserted == 0 then
        table.insert(chipsetAnims,0)
      end
      
      counter = counter + 1
    end
  end
end


function love.load()
  
  initialLoad()
  mapLoad(idMap)
  
end

frame = 0

function love.update()

  frame = frame + 0.01
  
end

function love.keypressed(key)

  if key == "e" then
    if showColision == 0 then showColision = 1 else showColision = 0 end
  elseif key == "r" then
    if showObjects == 0 then showObjects = 1 else showObjects = 0 end
  elseif key == "w" then
    if idMap == #maploadedList then idMap = 1 else idMap = idMap+1 end
    mapLoad(idMap)
  end

end


function love.draw()
  
  for i, V in pairs(decoded.layerGroups) do
    layer = i
    
    for i, V in pairs(decoded.layerGroups[i]["layer"]) do
      
      coordX = (i-1) % mapSizeW
      coordY = math.floor((i-1)/mapSizeW)
      
      topizqani = chipsetAnims[V["topIzq"]+1]+1
      topderani = chipsetAnims[V["topDer"]+1]+1
      botizqani = chipsetAnims[V["botIzq"]+1]+1
      botderani = chipsetAnims[V["botDer"]+1]+1
      
      sizetopizqani = #decoded.listAnimFrames[topizqani]["arr"]
      sizetopderani = #decoded.listAnimFrames[topderani]["arr"]
      sizebotizqani = #decoded.listAnimFrames[botizqani]["arr"]
      sizebotderani = #decoded.listAnimFrames[botderani]["arr"]
      
      topizq = V["topIzq"] +  decoded.listAnimFrames[topizqani]["arr"][1+math.floor(frame % sizetopizqani)]
      topder = V["topDer"] +  decoded.listAnimFrames[topderani]["arr"][1+math.floor(frame % sizetopderani)]
      botizq = V["botIzq"] +  decoded.listAnimFrames[botizqani]["arr"][1+math.floor(frame % sizebotizqani)]
      botder = V["botDer"] +  decoded.listAnimFrames[botderani]["arr"][1+math.floor(frame % sizebotderani)]
      
      if blank1 ~= topizq+1 then
        love.graphics.draw(chip,chipsetQuads[1+topizq],coordX*tileSizeW,coordY*tileSizeH)
      end
      
      if blank2 ~= topder+1 then
        love.graphics.draw(chip,chipsetQuads[1+topder],coordX*tileSizeW+tileSizeW/2,coordY*tileSizeH)
      end
      
      if blank3 ~= botizq+1 then
        love.graphics.draw(chip,chipsetQuads[1+botizq],coordX*tileSizeW,coordY*tileSizeH+tileSizeH/2)
      end
      
      if blank4 ~= botder+1 then
        love.graphics.draw(chip,chipsetQuads[1+botder],coordX*tileSizeW+tileSizeW/2,coordY*tileSizeH+tileSizeH/2)
      end
      
      
      --print(i)
      
      if layer == #decoded.layerGroups then
      
        if showColision == 1 then
          --print(i)
          if decoded.colisionMap[i] > 0 then
            love.graphics.setColor(0,0,0,0.5)
            love.graphics.rectangle("fill",coordX*tileSizeW,coordY*tileSizeH,tileSizeW,tileSizeH)
            love.graphics.setColor(255,255,255,1)
            love.graphics.print(decoded.colisionMap[i],coordX*tileSizeW,coordY*tileSizeH)
          end
        end
        
        if showObjects == 1 then
          for i, V in pairs(decoded.objects) do
            if coordX == V["coordX"] and coordY == V["coordY"] then
              love.graphics.setColor(0,0,0,0.5)
              love.graphics.rectangle("fill",coordX*tileSizeW,coordY*tileSizeH,tileSizeW,tileSizeH)
              love.graphics.setColor(255,255,255,1)
              love.graphics.print(V["objectID"],coordX*tileSizeW,coordY*tileSizeH)
            end
            
          end
          
        end
      end
      
    end
  end

  
  local displaY = 400
  love.graphics.print("Switch Map (key W): " .. maploaded, 10, 10+displaY)
  love.graphics.print("Toggle collisions (key E): ".. showColision, 10, 30+displaY)
  love.graphics.print("Toggle objects (key R): " .. showObjects, 10, 50+displaY)
  love.graphics.print("Img loaded: " .. chipsetIMG, 10, 70+displaY)
end
