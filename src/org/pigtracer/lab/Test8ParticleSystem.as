package org.pigtracer.lab
{
  import flash.events.Event;
  import away3d.entities.Mesh;
  import flash.geom.Point;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import org.pigtracer.lab.primitive.DotManager;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  [SWF(backgroundColor="#FFFFFF", frameRate="60", width="1024", height="768")]
  public class Test8ParticleSystem extends BaseScene
  {
    public function Test8ParticleSystem()
    {
      super();
    }

    private var terrainBitmap:BitmapData;
    private var _offsetPoint:Point = new Point();
    private var _seed:int;
    private var dotManager:DotManager;

    override protected function initObjects():void
    {

      terrainBitmap = new BitmapData(100, 100, false);
      _seed = int(Math.random() * 10000);
      var bitmap:Bitmap = new Bitmap(terrainBitmap);
      terrainBitmap.perlinNoise(50, 50, 1, _seed, true, false, 7, true, [_offsetPoint]);
      addChild(bitmap);

      dotManager = new DotManager(terrainBitmap);
      const len:int = dotManager.renderList.length;
      for (var i:int = 0; i < len; i++) {
        var mesh:Mesh = dotManager.renderList[i];
        scene.addChild(mesh);
      }
    }

    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);

      _offsetPoint.x += 1;
      _offsetPoint.y -= 1;
      terrainBitmap.perlinNoise(50, 50, 1, _seed, true, false, 7, true, [_offsetPoint]);

      dotManager.update();
    }
  }
}
