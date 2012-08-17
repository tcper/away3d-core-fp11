package org.pigtracer.lab.primitive
{
  import com.greensock.TweenLite;
  import flash.geom.Vector3D;
  import away3d.events.MouseEvent3D;
  import away3d.primitives.CubeGeometry;
  import away3d.materials.ColorMaterial;
  import away3d.entities.Mesh;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class CubeUnion extends ObjectContainer3D
  {
    private var _cubeList:Vector.<Mesh> = new Vector.<Mesh>();
    private var _overPosition:Vector.<Vector3D> = new Vector.<Vector3D>();

    private const CUBE:int = 5;
    public var material:ColorMaterial;
    private var geom:CubeGeometry;

    public function CubeUnion()
    {
      super();
      material = new ColorMaterial(0xFFFFFF);
      geom = new CubeGeometry();
      initializeCubes();
      addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
      addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);
      mouseEnabled = true;
      mouseChildren = true;
    }


    private function initializeCubes():void {
      for (var i:int = 0; i < CUBE; i++) {
        var mesh:Mesh = new Mesh(geom, material);
        mesh.mouseEnabled = true;
        mesh.mouseChildren = true;
        addChild(mesh);

        var pos:Vector3D = new Vector3D(getRandom(), getRandom(), getRandom());

        _overPosition.push(pos);
        _cubeList.push(mesh);
      }
    }
    private function getRandom():Number {
      return Math.random()*100 - 50;
    }

    private function mouseOutHandler(event:MouseEvent3D):void
    {
      for (var i:int = 0; i < CUBE; i++) {
        var target:Mesh = _cubeList[i];
        TweenLite.to(target, 1, {x:0, y:0, z:0});
      }
    }

    private function mouseOverHandler(event:MouseEvent3D):void
    {
      for (var i:int = 0; i < CUBE; i++) {
        var target:Mesh = _cubeList[i];
        var pos:Vector3D = _overPosition[i];
        TweenLite.to(target, 0.5, {x:pos.x, y:pos.y, z:pos.z});
      }
    }
  }
}
