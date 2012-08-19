package org.pigtracer.lab.primitive {
  import flash.geom.Vector3D;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.CubeGeometry;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Effect2 extends ObjectContainer3D {
    public function Effect2(mater:MainMessage) {
      this.master = mater;
      super();
      init();
    }
    
    private var master:MainMessage;
    public const N:int = 9;
    private var meshList:Vector.<MeshWithData> = new Vector.<MeshWithData>();
    
    public function start(motion:int):void {
      switch (motion) {
        case 0:
          
          break;
        
        case 1:
          
          break;
        
        case 2:
          
          break;
        
      }
    }

    private function init():void {
      initCube();
    }
    
    private function initCube():void {
      var geom:CubeGeometry = new CubeGeometry(30, 30, 30, 3, 3, 3);
      var material:ColorMaterial = new ColorMaterial(0xCCCCCC);
      material.lightPicker = material.lightPicker;
      for (var i:int = 0; i < N; i++) {
        var mesh:MeshWithData = new MeshWithData(geom, material);
        var origin:Vector3D = genRan();
        var target:Vector3D = origin.clone();
        target.y += 100;
        var data:MeshData = new MeshData(i, origin, target);
        mesh.data = data;
        mesh.position = data.origin;
        
        master.addChild(mesh);
        meshList.push(mesh);
        
        if (i == 0) {
          continue;
        }
        
        for (var j:int = 0; j < 100; j++) {
          
        }
      }      
    }
    private function genRan() : Vector3D {
      return new Vector3D(1000*Math.random() - 500, -50, 1000*Math.random() - 500);
    }
  }
}
import flash.geom.Vector3D;

class MeshData {
  public var index:int;
  public var origin:Vector3D;
  public var target:Vector3D;
  /**
   * Construct a <code>MeshData</code>.
   */
  public function MeshData(i:int, o:Vector3D, t:Vector3D) {
    index = i;
    origin = o;
    target = t;
  }
}