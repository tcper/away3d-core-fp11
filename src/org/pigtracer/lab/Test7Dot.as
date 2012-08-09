package org.pigtracer.lab {
  import flash.events.Event;
  import away3d.materials.TextureMaterial;
  import away3d.entities.Mesh;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Graphics;
  import flash.display.Shape;
  import flash.geom.Matrix;

  /**
   * @author loki
   */
  public class Test7Dot extends BaseScene
  {
    public function Test7Dot()
    {
      super();
    }

    private var texture:BitmapTexture;
    private var material:TextureMaterial;
    private var mesh:Mesh;

    override protected function initObjects():void
    {
      addChild(new Bitmap(createBitmapData()));

      var dotList:Array = [];
      for (var i:int = 0; i < 100; i++) {

        //dotList.push();
      }

      texture = new BitmapTexture(createBitmapData());
      material = new TextureMaterial(texture, true, true);
      material.lightPicker = lightPicker;

      var geom:PlaneGeometry = new PlaneGeometry(16, 16, 2, 2, true, true);
      mesh = new Mesh(geom, material);
      scene.addChild(mesh);
    }

    override protected function enterFrameHandler(event : Event) : void {
      super.enterFrameHandler(event);
      mesh.lookAt(camera.position);
    }

    private function createBitmapData():BitmapData {
      var bmd:BitmapData = new BitmapData(128, 128, true, 0x00000000);

      var shape:Shape = new Shape();
      var g:Graphics = shape.graphics;
      g.beginFill(0xFFFFFF);
      g.drawCircle(64, 64, 64);
      g.endFill();
      bmd.draw(shape);
      return bmd;
    }

  }
}
