package org.pigtracer.lab.tests
{
  import away3d.debug.Debug;
  import away3d.extrusions.Elevation;
  import away3d.materials.TextureMaterial;
  import away3d.textures.BitmapTexture;
  import away3d.utils.Cast;
  import com.adobe.images.PNGEncoder;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.filesystem.File;
  import flash.filesystem.FileMode;
  import flash.filesystem.FileStream;
  import flash.geom.Point;
  import flash.utils.ByteArray;



  /**
   * @author loki
   */
  [SWF(width="1024", height="768", backgroundColor="0xFFFFFF", frameRate="60")]
  public class Test6Terrain extends BaseScene
  {
    public function Test6Terrain()
    {
      Debug.active = true;
      super();
      initBitmap();
    }

    private var terrainBitmap:BitmapData;
    private var _offsetPoint:Point = new Point();
    private var _seed:int;
    private var elevation:Elevation;

    private function initBitmap():void
    {
      terrainBitmap = new BitmapData(100, 100, false);
      _seed = int(Math.random() * 10000);
      var bitmap:Bitmap = new Bitmap(terrainBitmap);
      addChild(bitmap);
      terrainBitmap.perlinNoise(50, 50, 1, _seed, true, false, 7, true, [_offsetPoint]);

      var terrainBD:BitmapData = new BitmapData(128, 128);
      var texture:BitmapTexture = new BitmapTexture(terrainBD);
      var material:TextureMaterial = new TextureMaterial(texture);
      material.lightPicker = lightPicker;
      elevation = new Elevation(material, terrainBitmap);

      scene.addChild(elevation);
    }


    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);
      _offsetPoint.x += 1;
      _offsetPoint.y -= 1;
      terrainBitmap.perlinNoise(50, 50, 1, _seed, true, false, 7, true, [_offsetPoint]);
      //elevation.updateImplicitVisibility();
      elevation.up();
    }

  }
}
