using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Tilemaps;
using UnityEngine.UI;
using TMPro;
using static System.Net.Mime.MediaTypeNames;

public class MapLoader : MonoBehaviour
{
    //public TextAsset[] mapFiles;
    public List<TextAsset> mapFilesList = new List<TextAsset>();
    public Tilemap[] tilemapList;

    private int showCollision = 0;
    private int showObjects = 0;
    private int currentMapId = 0;
    private int currentAsset = 0;

    private MapData[] decodedMaps;
    public List<TilesetSlicer> slicedImgsList = new List<TilesetSlicer>();
    public List<string> imgsStrings = new List<string>();
    private int[] animationMap;

    private float timer = 0;
    public int animationSpeed = 1;
    private int frame = 0;

    private GameObject[] objectsInScene;

    // Start is called before the first frame update
    void Start()
    {
        //tilemap.transform.localScale = new Vector3(0.5f, 0.5f);
        StartExporter();
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            //action change map

            for (int i = 0; i < objectsInScene.Length; i++)
            {
                Destroy(objectsInScene[i]);
            }
            objectsInScene = null;

            for (int i = 0; i < tilemapList.Length; i++)
            {
                Destroy(tilemapList[i]);
            }
            tilemapList = null;

            currentMapId++;
            if (currentMapId == decodedMaps.Length)
                currentMapId = 0;
            LoadMap(currentMapId);
        }

        timer += Time.deltaTime;
        if (timer >= 1.0f / animationSpeed)
        {
            timer = 0;
            frame += 1;
            refreshMap(currentMapId, false);
        }
    }

    private void StartExporter()
    {
        <MAP_LIST_CODE>

        decodedMaps = new MapData[mapFilesList.Count];

        int i = 0;
        foreach (TextAsset mapFiles in mapFilesList)
        {
            decodedMaps[i] = JsonUtility.FromJson<MapData>(mapFiles.text);
            i = i + 1;
        }

        <IMG_LIST_CODE>

        LoadMap(currentMapId);
    }

    private void addTileSlicer(string assetName)
    {
        imgsStrings.Add(assetName);

        Texture2D test;
        int tileSizeX = 1;
        int tileSizeY = 1;

        for (int z = 0; z < decodedMaps.Length; z++)
        {
            string subcadena = decodedMaps[z].img.Substring(0, decodedMaps[z].img.Length - 4);
            if (subcadena == assetName)
            {
                tileSizeX = decodedMaps[z].tilesizeW / 2;
                tileSizeY = decodedMaps[z].tilesizeH / 2;
            }
        }

        test = Resources.Load<Texture2D>(assetName);
        test.filterMode = FilterMode.Point;
        slicedImgsList.Add(new TilesetSlicer(test, tileSizeX, tileSizeY));
    }

    private Vector3 createTile(int idQuad, int type, int pos, int mapW, int layer, int colision = -1)
    {
        int spriteIndexX = idQuad % slicedImgsList[currentAsset].tilesPerRow;
        int spriteIndexY = idQuad / slicedImgsList[currentAsset].tilesPerRow;
        spriteIndexY = slicedImgsList[currentAsset].tilesPerColumn - spriteIndexY-1;

        Debug.Log(slicedImgsList[currentAsset].tilesPerColumn);

        Sprite sprite = slicedImgsList[currentAsset].GetSprite(spriteIndexX, spriteIndexY);
        Tile tile = ScriptableObject.CreateInstance<Tile>();
        
        tile.sprite = sprite;

        int coordX = pos % mapW;
        int coordY = pos / mapW * -1;
        int pow = 2;

        if (colision>-1) pow = 1;

        switch (type)
        {
            case 0:
                coordX = coordX * pow;
                coordY = coordY * pow;
                break;

            case 1:
                coordX = coordX * pow + 1;
                coordY = coordY * pow;
                break;

            case 2:
                coordX = coordX * pow;
                coordY = coordY * pow - 1;
                break;

            case 3:
                coordX = coordX * pow + 1;
                coordY = coordY * pow - 1;
                break;
        
        }

        tilemapList[layer].SetTile(new Vector3Int(coordX, coordY, 0), tile);

        return tilemapList[layer].CellToWorld(new Vector3Int(coordX, coordY, 0));
    }

    private void refreshMap(int mapId, bool renderAll)
    {
        MapData mapData = decodedMaps[mapId];

        for (int i = 0; i < mapData.layerGroups.Length; i++)
        {
            for (int b = 0; b < mapData.layerGroups[i].layer.Length; b++)
            {
                int topIzq = mapData.layerGroups[i].layer[b].topIzq;
                int topizqani = animationMap[topIzq];
                int[] topizqaniarr = mapData.listAnimFrames[topizqani].arr;

                if ((renderAll || topizqani>0) && (topIzq != mapData.blank1))
                    createTile(topIzq + topizqaniarr[frame % topizqaniarr.Length], 0, b, mapData.mapSizeW, i);

                int topDer = mapData.layerGroups[i].layer[b].topDer;
                int topderani = animationMap[topDer];
                int[] topderaniarr = mapData.listAnimFrames[topderani].arr;

                if ((renderAll || topderani>0) && (topDer != mapData.blank2))
                    createTile(topDer + topderaniarr[frame % topderaniarr.Length], 1, b, mapData.mapSizeW, i);

                int botIzq = mapData.layerGroups[i].layer[b].botIzq;
                int botizqani = animationMap[botIzq];
                int[] botizqaniarr = mapData.listAnimFrames[botizqani].arr;

                if ((renderAll || botizqani>0) && (botIzq != mapData.blank3))
                    createTile(botIzq + botizqaniarr[frame % botizqaniarr.Length], 2, b, mapData.mapSizeW, i);

                int botDer = mapData.layerGroups[i].layer[b].botDer;
                int botderani = animationMap[botDer];
                int[] botderaniarr = mapData.listAnimFrames[botderani].arr;

                if ((renderAll || botderani>0) && (botDer != mapData.blank4))
                    createTile(botDer + botderaniarr[frame % botderaniarr.Length], 3, b, mapData.mapSizeW, i);

                //Debug.Log("layer: " + i.ToString() + " tile: " + b.ToString() + " " + topIzq.ToString()
                //    + " " + topDer.ToString() + " " + botDer.ToString() + " " + botIzq.ToString());
            }
        }
    }

    private void LoadMap(int mapId)
    {
        MapData mapData = decodedMaps[mapId];

        for (int i = 0; i < imgsStrings.Count; i++)
        {
            string subcadena = decodedMaps[mapId].img.Substring(0, decodedMaps[mapId].img.Length - 4);
            if (subcadena == imgsStrings[i])
                currentAsset = i;
        }

        int counter = 0;
        int imgSizeH = slicedImgsList[currentAsset].tileset.height;
        int imgSizeW = slicedImgsList[currentAsset].tileset.width;
        int tileSizeW = mapData.tilesizeW;
        int tileSizeH = mapData.tilesizeH;

        int totalSubtilesH = imgSizeH / (tileSizeH / 2);
        int totalSubtilesW = imgSizeW / (tileSizeW / 2);

        animationMap = new int[totalSubtilesW * totalSubtilesH];

        objectsInScene = new GameObject[mapData.layerGroups.Length + 1 + mapData.objects.Length];

        for (int y = 0; y < totalSubtilesH; y++)
        {
            for (int x = 0; x < totalSubtilesW; x++)
            {
                bool inserted = false;

                for (int b = 0; b < mapData.ANISplit.Length; b++)
                {
                    if (counter == mapData.ANISplit[b].idChipset)
                    {
                        animationMap[counter] = mapData.ANISplit[b].idAnimation;
                        inserted = true;
                    }
                }

                if (!inserted)
                    animationMap[counter] = 0;

                counter++;
            }
        }

        tilemapList = new Tilemap[mapData.layerGroups.Length+1];

        for (int i = 0; i < mapData.layerGroups.Length; i++)
        {
            GameObject tilemapObject = new GameObject("Layer " + i.ToString());
            tilemapObject.transform.SetParent(gameObject.transform);
            tilemapObject.transform.localPosition = Vector3.zero;
            tilemapObject.transform.localScale = Vector3.one;
            Tilemap tilemapAux = tilemapObject.AddComponent<Tilemap>();
            TilemapRenderer tilemapRenderer = tilemapObject.AddComponent<TilemapRenderer>();
            tilemapRenderer.sortingOrder = i;

            tilemapList[i] = tilemapAux;
            objectsInScene[i] = tilemapObject;
        }

        GameObject tilemapObjectColi = new GameObject("Colisions");
        tilemapObjectColi.transform.SetParent(gameObject.transform);
        tilemapObjectColi.transform.localPosition = new Vector3(0, -1);
        tilemapObjectColi.transform.localScale = new Vector3(2, 2);
        Tilemap tilemapAuxColi = tilemapObjectColi.AddComponent<Tilemap>();
        TilemapRenderer coliTilerender = tilemapObjectColi.AddComponent<TilemapRenderer>();
        coliTilerender.sortingOrder = mapData.layerGroups.Length;

        tilemapList[mapData.layerGroups.Length] = tilemapAuxColi;
        objectsInScene[mapData.layerGroups.Length] = tilemapObjectColi;

        TilemapCollider2D coliTilecolider = tilemapAuxColi.gameObject.AddComponent<TilemapCollider2D>();
        Rigidbody2D coliRigidbody = tilemapAuxColi.gameObject.AddComponent<Rigidbody2D>();
        coliRigidbody.bodyType = RigidbodyType2D.Kinematic;

        //textList = new TextMeshProUGUI[mapData.objects.Length];

        for (int i = 0; i < mapData.colisionMap.Length; i++)
        {
            Vector3 auxVect = createTile(mapData.blank1, 0, i, mapData.mapSizeW, mapData.layerGroups.Length, mapData.colisionMap[i]);

            int coordX = i % mapData.mapSizeW;
            int coordY = i / mapData.mapSizeW * -1;

            for (int b = 0; b < mapData.objects.Length; b++)
            {
                if ((coordX == mapData.objects[b].coordX) && (coordY == -mapData.objects[b].coordY))
                {
                    GameObject textMeshProPrefab = CreateTextMeshProPrefab(mapData.objects[b].objectID, auxVect, b);
                    objectsInScene[mapData.layerGroups.Length + 1 + b] = textMeshProPrefab;
                }
            }
        }

        refreshMap(mapId, true);
    }

    private GameObject CreateTextMeshProPrefab(string text, Vector3 position, int amount)
    {
        // Crea un nuevo objeto de juego y agrega un componente TextMeshProUGUI.
        GameObject textMeshProObject = new GameObject("TextMeshProObject");

        TextMeshPro textMeshPro = textMeshProObject.AddComponent<TextMeshPro>();
        //textList[amount] = textMeshPro;

        // Configura las propiedades del componente TextMeshProUGUI según tus necesidades.
        textMeshPro.text = text;
        textMeshPro.fontSize = 24;
        textMeshPro.color = Color.white;
        textMeshPro.alignment = TextAlignmentOptions.Center;

        //textMeshProObject.transform.SetParent(gameObject.transform);
        textMeshProObject.transform.position = position;

        return textMeshProObject;
    }

}

[System.Serializable]
public class MapData
{
    public string img;
    public int tilesizeW;
    public int tilesizeH;
    public int mapSizeW;
    public int mapSizeH;

    public int blank1;
    public int blank2;
    public int blank3;
    public int blank4;

    public AniSplit[] ANISplit;
    public ListAnimFrame[] listAnimFrames;
    public LayerGroup[] layerGroups;
    public int[] colisionMap;
    public MapObject[] objects;
}

[System.Serializable]
public class AniSplit
{
    public int idChipset;
    public int idAnimation;
}

[System.Serializable]
public class ListAnimFrame
{
    public int[] arr;
}

[System.Serializable]
public class LayerGroup
{
    public Layer[] layer;
}

[System.Serializable]
public class Layer
{
    public int topIzq;
    public int topDer;
    public int botIzq;
    public int botDer;
}

[System.Serializable]
public class MapObject
{
    public int coordX;
    public int coordY;
    public string objectID;
}

//COLISION FUNCTION
//void OnCollisionEnter2D(Collision2D collision)
//{
//    Vector3 contactPoint = collision.contacts[0].point;
//    Vector3Int cell = tilemap.WorldToCell(contactPoint);
//    Tile tile = tilemap.GetTile<Tile>(cell);

//    if (tile != null)
//    {
//        string tileName = tile.name;

//       if (tileName == "1")
//        {
//            Debug.Log("Colisión con el tipo 1");
            // Escribe aquí el código para manejar la colisión de tipo 1.
//        }
//        else if (tileName == "2")
//        {
//            Debug.Log("Colisión con el tipo 2");
            // Escribe aquí el código para manejar la colisión de tipo 2.
//        }
//    }
//}