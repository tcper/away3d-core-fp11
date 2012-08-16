package org.pigtracer.lab
{
  import away3d.containers.ObjectContainer3D;
  import com.greensock.TweenLite;
  import flash.events.Event;
  import away3d.animators.PathAnimator;
  import away3d.paths.QuadraticPath;
  import away3d.materials.methods.HardShadowMapMethod;
  import away3d.materials.TextureMaterial;
  import flash.display.BitmapData;
  import away3d.textures.BitmapTexture;
  import away3d.primitives.PlaneGeometry;
  import flash.geom.Vector3D;
  import away3d.primitives.WireframeSphere;
  import away3d.materials.ColorMaterial;
  import away3d.entities.Mesh;
  import away3d.primitives.CubeGeometry;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class Test10 extends BaseScene
  {
    private var material:ColorMaterial;
    private var pathAnimator:PathAnimator;
    private var container:ObjectContainer3D;

    public function Test10()
    {
      super();
      view.backgroundColor = 0xffffff;
    }

    override protected function initLights():void
    {
      super.initLights();

      //pointLight.ambientColor = 0xFF0000;
    }
    override protected function initMaterials():void
    {
      super.initMaterials();
      material = new ColorMaterial(0xEEEEEE);
      material.lightPicker = lightPicker;

      pointLight.z = 300;
      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      //pointLight.y = 100;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 400;
      pointLight.fallOff = 500;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;

      trace(pointLight.position);


    }
    override protected function initObjects():void
    {
      super.initObjects();

      container = new ObjectContainer3D();
      scene.addChild(container);

      var geom:CubeGeometry = new CubeGeometry();

      for (var i:int = 0; i < 10; i++) {
        var mesh:Mesh = new Mesh(geom, material);
        mesh.position = new Vector3D(200*Math.random(), Math.random()*200, Math.random()*200);
        container.addChild(mesh);
      }

      var planeGeom:PlaneGeometry = new PlaneGeometry(5000, 5000, 8, 8, true, true);
      var bitmap:BitmapData = new BitmapData(16, 16, false, 0x00FF00);
      var bitmapTexure:BitmapTexture = new BitmapTexture(bitmap);
      var bitmapMaterial:TextureMaterial = new TextureMaterial(bitmapTexure);

      bitmapMaterial.lightPicker = lightPicker;

      bitmapMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bitmapMaterial.specular = .25;
      bitmapMaterial.gloss = 20;
      bitmapMaterial.bothSides = true;

      var planeMesh:Mesh = new Mesh(planeGeom, bitmapMaterial);
      planeMesh.rotationX = 90;
      container.addChild(planeMesh);

      var sphere:WireframeSphere = new WireframeSphere(10, 10, 10, 0xFF0000);
      sphere.position = pointLight.position;
      container.addChild(sphere);


      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0,0,0),
                                                  new Vector3D(500, 0, 0),
                                                  new Vector3D(0, 0, 1000)];

      var cubicPath:QuadraticPath = new QuadraticPath(list);
      pathAnimator = new PathAnimator(cubicPath, camera);

      TweenLite.to(pathAnimator, 2, {t:1});
    }

    override protected function enterFrameHandler(event:Event):void
    {

//      var xoffset:Number = mouseX - stage.stageWidth/2;
//      var yoffset:Number = mouseY - stage.stageHeight/2;
      var rateX:Number = (mouseX-(stage.stageWidth/2-2))*0.1//+45/2;
      var rateY:Number = (mouseY-(stage.stageHeight/2-2))*0.1//+45/2;


      container.rotationY += (rateX-container.rotationY)*0.1;
      container.rotationX += (-rateY-container.rotationX)*0.1;

      camera.lookAt(new Vector3D());
      view.render();
    }


  }
}
