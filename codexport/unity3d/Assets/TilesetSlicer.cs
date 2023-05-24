using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TilesetSlicer
{
    public Texture2D tileset;
    public int tileWidth = 16;
    public int tileHeight = 16;

    public int tilesPerRow;
    public int tilesPerColumn;

    public int offsetX = 0;
    public int offsetY = 0;

    private Sprite[,] slicedSprites;

    public TilesetSlicer(Texture2D img, int width, int height)
    {
        tileset = img;

        tileWidth = width;
        tileHeight = height;

        tilesPerRow = tileset.width / tileWidth;
        offsetX = tileset.width - tilesPerRow * tileWidth;
        tilesPerColumn = tileset.height / tileHeight;
        offsetY = tileset.height - tilesPerColumn * tileHeight;
        slicedSprites = new Sprite[tilesPerRow, tilesPerColumn];

        for (int i = 0; i < tilesPerColumn; i++)
        {
            for (int j = 0; j< tilesPerRow; j++)
            {
                Sprite sprite = CreateSpriteFromTileset(j, i);
                slicedSprites[j, i] = sprite;
            }
        }
    }

    private Sprite CreateSpriteFromTileset(int x, int y)
    {
        Rect spriteRect = new Rect(x * tileWidth, y * tileHeight + offsetY, tileHeight, tileWidth);
        Sprite sprite = Sprite.Create(tileset, spriteRect, new Vector2(0.5f, 0.5f), tileWidth);
        return sprite;
    }

    public Sprite GetSprite(int x, int y)
    {
        return slicedSprites[x, y];
    }
}
