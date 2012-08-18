package org.pigtracer.lab.primitive {
  import away3d.containers.ObjectContainer3D;
  import away3d.entities.Mesh;
  import away3d.materials.TextureMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;

  import flash.display.BitmapData;

  /**
   * @author loki
   */
  public class Stuff extends ObjectContainer3D
  {
    private var bgPlane:Mesh;
    private var bgGeom:PlaneGeometry;
    public var bgMaterial:TextureMaterial;

    public function Stuff()
    {
      super();

      initilialize();
    }

    private function initilialize():void {
      initBG();
      initObjects();
      initListener();
    }


    private function initObjects():void {
    }
    
    private function initListener():void {
    }

    private function initBG():void {
      bgGeom = new PlaneGeometry(1000, 10000, 8, 8, true, true);
      var bitmapData:BitmapData = new BitmapData(2, 2, false, 0x0000ff);
      var bitmapTexture:BitmapTexture = new BitmapTexture(bitmapData);
      bgMaterial = new TextureMaterial(bitmapTexture);
      
      //bgMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bgMaterial.specular = .25;
      bgMaterial.gloss = 20;
      bgMaterial.bothSides = true;
      
      bgPlane = new Mesh(bgGeom, bgMaterial);
      addChild(bgPlane);
    }
  }
}
