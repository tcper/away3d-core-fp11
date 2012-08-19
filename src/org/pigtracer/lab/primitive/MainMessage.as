package org.pigtracer.lab.primitive {
  import away3d.containers.ObjectContainer3D;
  import away3d.entities.Mesh;
  import away3d.events.Scene3DEvent;
  import away3d.lights.PointLight;
  import away3d.materials.ColorMaterial;
  import away3d.materials.TextureMaterial;
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.materials.methods.HardShadowMapMethod;
  import away3d.primitives.CubeGeometry;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;

  import com.greensock.TweenLite;

  import flash.display.BitmapData;
  import flash.geom.Vector3D;

  /**
   * @author loki
   */
  public class MainMessage extends ObjectContainer3D implements IUpdate {
    public function MainMessage() {
      super();
    }

    
    public var bgMaterial:TextureMaterial;
    public var colorMaterial:ColorMaterial;
    
    
    public var pointLight:PointLight;
    public var lightPicker:StaticLightPicker;
    
    private var cubePos:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0, -50, -300),
                                                           new Vector3D(Math.sqrt(3)*150, -50, 150), 
                                                           new Vector3D(-Math.sqrt(3)*150, -50, 150)];
    public var meshList:Vector.<Mesh> = new Vector.<Mesh>();
    
    public function init():void {
      initLight();
      initBG();
      initCube();
      startMotion();
    }

    private function startMotion():void {
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        TweenLite.to(meshList[i], 0.5, {delay:i*0.5, y:100});
      }
    }

    private function initCube():void {
      const N:int = cubePos.length;
      var geomList:Array = [new CubeGeometry(50, 80, 50, 3, 3, 3), 
                            new CubeGeometry(80, 50, 50, 3, 3, 3), 
                            new CubeGeometry(50, 50, 80, 3, 3, 3)];
                            
      var matList:Array = [new ColorMaterial(ColorConst.MAIN_PART_C), 
                           new ColorMaterial(ColorConst.MAIN_PART_B), 
                           new ColorMaterial(ColorConst.MAIN_PART_A)];
                           
      for (var i:int = 0; i < N; i++) {
        var mat:ColorMaterial = matList[i];
        mat.lightPicker = lightPicker;
        var mesh:Mesh = new Mesh(geomList[i], mat);
        //var mesh:Mesh = new Mesh(new CubeGeometry(), colorMaterial);
        mesh.position = cubePos[i];
        addChild(mesh);
        meshList.push(mesh);
      }
    }

    private function initLight():void {
      pointLight = new PointLight();
      pointLight.y = 700;
      
      pointLight.castsShadows = true;
      pointLight.shadowMapper.depthMapSize = 1024;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 5000;
      pointLight.fallOff = 3000;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;
      
      lightPicker = new StaticLightPicker([pointLight]);
      scene.addChild(pointLight);
    }

    private function initBG():void {
      var geom:PlaneGeometry = new PlaneGeometry(8000, 3000, 8, 8);
      var bitmapData:BitmapData = new BitmapData(16, 16, true, 0xF0FFFFFF);
      var texture:BitmapTexture = new BitmapTexture(bitmapData);
      bgMaterial = new TextureMaterial(texture);
      bgMaterial.lightPicker = lightPicker;
      bgMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bgMaterial.specular = .25;
      bgMaterial.gloss = 20;
      
      colorMaterial = new ColorMaterial(0x00FF00);
      colorMaterial.lightPicker = lightPicker;

      var mesh:Mesh = new Mesh(geom, bgMaterial);
      
      addChild(mesh);
    }

    public function update(rateX:Number, rateY:Number):void {
      rotationY += (rateX - rotationY)*0.1;
      rotationX += (-rateY - rotationX)*0.1;
    }
  }
}
