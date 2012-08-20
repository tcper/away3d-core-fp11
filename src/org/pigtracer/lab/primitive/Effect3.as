package org.pigtracer.lab.primitive
{
  import away3d.events.MouseEvent3D;
  import away3d.filters.BloomFilter3D;
  import com.greensock.TweenLite;
  import org.pigtracer.lab.managers.LightsManager;
  import away3d.entities.Mesh;
  import flash.geom.Vector3D;
  import away3d.primitives.CubeGeometry;
  import away3d.materials.ColorMaterial;
  import away3d.containers.View3D;
  import org.pigtracer.lab.interfaces.IEffect;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Effect3 extends ObjectContainer3D implements IEffect, IUpdate{
    public function Effect3(view:View3D) {
      super();
      init();
    }

    private const N:int = 10;
    private var meshList:Vector.<MeshWithData> = new Vector.<MeshWithData>();
    private var filters:Array;

    private function init():void
    {
      initCubes();
      initFilter();
    }

    private function initFilter():void
    {
      filters = [new BloomFilter3D()];
    }

    private function initCubes():void
    {
      var geom:CubeGeometry = new CubeGeometry(50, 50, 50, 3, 3, 3);
      for (var i:int = 0; i < N; i++) {
        var mat:ColorMaterial = new ColorMaterial(0xFFFFFF*Math.random());
        mat.alpha = 0;
        mat.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;
        var origin:Vector3D = genRan2();
        var target:Vector3D = genRan1();
        var data:MeshData = new MeshData(i, origin, target, Math.random()*3);
        var mesh:MeshWithData = new MeshWithData(geom, mat);

        mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);

        mesh.data = data;
        addChild(mesh);
        meshList.push(mesh);
      }
    }

    private function mouseOutHandler(event:MouseEvent3D):void
    {
    }

    private function mouseOverHandler(event:MouseEvent3D):void
    {
    }

    private function mouseDownHandler(event:MouseEvent3D):void
    {
    }

    private function genRan1() : Vector3D {
      return new Vector3D(200*Math.random() - 100, Math.random()*200-100, 200*Math.random() - 100);
    }
    private function genRan2() : Vector3D {
      return new Vector3D(100*Math.random() - 50, 100*Math.random() - 50, 100*Math.random() - 50);
    }

    public function show():void
    {
      for (var i:int = 0; i < N; i++) {
        var mesh:MeshWithData = meshList[i];
        var data:MeshData = mesh.data as MeshData;
        TweenLite.to(mesh.material, 0.5, {alpha:1});
        TweenLite.to(mesh, 0.5, {x:data.target.x, y:data.target.y, z:data.target.z, delay:data.delay + 0.8});
      }
    }

    public function hide():void
    {
    }

    public function update(rateX:Number, rateY:Number):void
    {
      rotationX += 10;
    }
  }
}
import flash.geom.Vector3D;

class MeshData {
  public var index:int;
  public var origin:Vector3D;
  public var target:Vector3D;
  public var delay:Number;
  /**
   * Construct a <code>MeshData</code>.
   */
  public function MeshData(i:int, o:Vector3D, t:Vector3D, d:Number) {
    index = i;
    origin = o;
    target = t;
    delay = d;
  }
}