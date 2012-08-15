package org.pigtracer.lab
{
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
    public function Test10()
    {
      super();
      view.backgroundColor = 0xffffff;
    }

    override protected function initLights():void
    {
      super.initLights();

      pointLight.ambientColor = 0xFF0000;
    }
    override protected function initMaterials():void
    {
      super.initMaterials();
      material = new ColorMaterial(0xEEEEEE);
      material.lightPicker = lightPicker;

      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      pointLight.y = 120;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 400;
      pointLight.fallOff = 500;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .5;
    }
    override protected function initObjects():void
    {
      super.initObjects();

      var geom:CubeGeometry = new CubeGeometry();

      for (var i:int = 0; i < 10; i++) {
        var mesh:Mesh = new Mesh(geom, material);
        mesh.position = new Vector3D(200*Math.random(), Math.random()*200, Math.random()*200);
        scene.addChild(mesh);
      }

      var planeGeom:PlaneGeometry = new PlaneGeometry(1000, 1000);
      var bitmap:BitmapData = new BitmapData(16, 16, false, 0x00FF00);
      var bitmapTexure:BitmapTexture = new BitmapTexture(bitmap);
      var bitmapMaterial:TextureMaterial = new TextureMaterial(bitmapTexure);

      bitmapMaterial.lightPicker = lightPicker;

      bitmapMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bitmapMaterial.specular = .25;
      bitmapMaterial.gloss = 20;

      var planeMesh:Mesh = new Mesh(planeGeom, bitmapMaterial);
      planeMesh.rotationX = 90;
      scene.addChild(planeMesh);

    }

  }
}
