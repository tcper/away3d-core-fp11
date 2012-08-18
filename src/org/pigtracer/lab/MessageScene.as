package org.pigtracer.lab {
  import org.pigtracer.lab.primitive.LineExtened;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import com.greensock.TweenLite;
  import flash.geom.Vector3D;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.CubeGeometry;
  import away3d.entities.Mesh;
  import away3d.textures.BitmapTexture;
  import flash.display.BitmapData;
  import away3d.primitives.PlaneGeometry;
  import away3d.materials.TextureMaterial;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class MessageScene extends ObjectContainer3D {
    
    public var bgMaterial:TextureMaterial;
    public var colorMaterial:ColorMaterial;
    
    private var meshList:Vector.<Mesh> = new Vector.<Mesh>();
    private var lineList:Vector.<LineExtened> = new Vector.<LineExtened>();
    
    public function MessageScene() {
      super();
      init();
    }
    
    public function start():void {
      for (var i:int = 0; i < meshList.length; i++) {
        TweenLite.to(meshList[i], 0.3, {delay:Math.random()*1, y:70});
      }
    }

    public function start2() : void {
      for (var i:int = 0; i < lineList.length; i++) {
        TweenLite.to(lineList[i], 0.5, {delay:i, t:1});
      }
    }


    private function init() : void {
      initBG();
      initMessage();
    }
    
    private function initBG() : void {
      var geom:PlaneGeometry = new PlaneGeometry(1000, 1000, 8, 8);
      var bitmapData:BitmapData = new BitmapData(16, 16, false, 0xFFFFFF);
      var texture:BitmapTexture = new BitmapTexture(bitmapData);
      bgMaterial = new TextureMaterial(texture);
      var mesh:Mesh = new Mesh(geom, bgMaterial);
      addChild(mesh);
    }

    private function initMessage() : void {
      var geom:CubeGeometry = new CubeGeometry(50, 50, 50, 3, 3);
      colorMaterial = new ColorMaterial(0x00FF00);
      for (var i:int = 0; i < 5; i++) {
        var mesh:Mesh = new Mesh(geom, colorMaterial);
        mesh.position = genRan();
        addChild(mesh);
        meshList.push(mesh);
        
        if (i > 0) {
          var start:Vector3D = meshList[i-1].position.add(new Vector3D(0, 120));
          var end:Vector3D = meshList[i].position.add(new Vector3D(0, 120));
          var temp:Vector3D = end.subtract(start);
          temp.x = start.x;
          temp.y *= Math.random();
          temp.z *= Math.random();
          var middle:Vector3D = start.add(temp);
          var path:QuadraticPath = new QuadraticPath(new <Vector3D>[start, middle, end]);
          var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
          for (var j:int = 0; j < 100; j++) {
            var t1:Number = j/100;
            var segment:IPathSegment = path.segments[0];
            newList.push(segment.getPointOnSegment(t1));
          }
          var color:uint = 0xFFFFFF*Math.random();
          var line:LineExtened = new LineExtened(newList, 0, color, color, 5, 5);
          lineList.push(line);
          addChild(line);
        }
      }
    }

    private function genRan() : Vector3D {
      return new Vector3D(1000*Math.random() - 500, -50, 1000*Math.random() - 500);
    }

  }
}
