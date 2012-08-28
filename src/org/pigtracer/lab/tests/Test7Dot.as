package org.pigtracer.lab.tests {
  import away3d.core.base.Geometry;
  import away3d.entities.Mesh;
  import away3d.materials.TextureMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Graphics;
  import flash.display.Shape;
  import flash.events.Event;
  import flash.geom.Matrix;
  import flash.geom.Matrix3D;
  import flash.geom.Vector3D;

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
      material.bothSides = true;

      var geom:PlaneGeometry = new PlaneGeometry(16, 16, 1, 1, true);

      /*var plane:Mesh = new Mesh(geom, material);
      plane.rotationX = 90;
      mesh = new Mesh(new Geometry());
      mesh.addChild(plane);*/
      mesh = new Mesh(geom, material);

      scene.addChild(mesh);
    }

    override protected function enterFrameHandler(event : Event) : void {
      super.enterFrameHandler(event);


      //var matrix:Matrix3D = new Matrix3D();
      //matrix.position = camera.position;
      //matrix.appendRotation(90, Vector3D.X_AXIS);
      //var p:Vector3D = matrix.position;

      //mesh.lookAt(p);
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
