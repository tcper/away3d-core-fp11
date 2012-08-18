package org.pigtracer.lab {
  import away3d.materials.methods.HardShadowMapMethod;
  import away3d.entities.Mesh;
  import away3d.materials.TextureMaterial;
  import away3d.textures.BitmapTexture;
  import flash.display.BitmapData;
  import away3d.primitives.PlaneGeometry;
  import flash.events.Event;
  import away3d.paths.CubicPath;
  import away3d.paths.IPath;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;

  import com.greensock.TweenLite;
  import com.greensock.easing.Quint;

  import org.pigtracer.lab.primitive.LineExtened;

  import flash.geom.Vector3D;

  /**
   * @author loki
   */
  public class ManyLineAnimate extends BaseScene {
    public function ManyLineAnimate() {
      super();
    }
    private var lineList:Array = [];

    
    override protected function initObjects():void {
      super.initObjects();
      view.backgroundColor = 0xFFFFFF;
      
      pointLight.y = 100;
      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      //pointLight.y = 100;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      //pointLight.radius = 400;
      //pointLight.fallOff = 500;
      pointLight.ambient = 0xeeeee;
      pointLight.ambient = .3;
      
      
      var geom:PlaneGeometry = new PlaneGeometry(10000, 10000, 8, 8);
      var bitmapData:BitmapData = new BitmapData(16, 16, false, 0xFFFFFF);
      var texture:BitmapTexture = new BitmapTexture(bitmapData);
      var material:TextureMaterial = new TextureMaterial(texture);
      material.shadowMethod = new HardShadowMapMethod(pointLight);
      material.specular = .25;
      material.gloss = 20;
      material.bothSides = true;
      material.lightPicker = lightPicker;
      
      var plane:Mesh = new Mesh(geom, material);
      //plane.rotationX = 90;
      scene.addChild(plane);
      
      
      for (var i:int = 0; i < 20; i++) {
        var path:IPath = generateQuadCurve();
        
        var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
        for (var j:int = 0; j < 100; j++) {
          var t1:Number = j / 100;
          var segment:IPathSegment = path.segments[0];
          newList.push(segment.getPointOnSegment(t1));
        }
        
        var line:LineExtened = new LineExtened(newList, 0, 0xFFFFFF, 0x00FF00, 10, 1);
        
        lineList.push(line);
        TweenLite.to(line, 0.5, {t:1, delay:10*Math.random()});
        scene.addChild(line);
      }
      
    }
    
    
    override protected function enterFrameHandler(event : Event) : void {
      //panIncrement = -4;
      super.enterFrameHandler(event);
    }
    
    
    private function generateCubeCurve():CubicPath {
      var path:CubicPath;
      
      return path;
    }
    
    private function generateQuadCurve():QuadraticPath {
      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(genRan(100, 0),genRan(100, 0),genRan(100, 0)),new Vector3D(genRan(500, 0),genRan(500, 500, 1000),genRan(500, 0)),new Vector3D(genRan(1000, 0),genRan(1000, 800, 2000),genRan(300, 0))];
      var path:QuadraticPath = new QuadraticPath(list);
      return path;
    }
    
    private function genRan(scale:int, base:int, max:int = int.MAX_VALUE):Number {
      var temp:Number;
      if (base == 0) {
        temp = 2*scale*Math.random() - scale;
        return Math.min(max, temp);
      } else {
        temp = max - base;
        return max - Math.random()*temp;
      }
    }

  }
}
