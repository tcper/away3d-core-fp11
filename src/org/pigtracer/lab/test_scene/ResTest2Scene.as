package org.pigtracer.lab.test_scene
{
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.lights.PointLight;
  import away3d.entities.Mesh;
  import away3d.primitives.CubeGeometry;
  import away3d.materials.ColorMaterial;
  import org.pigtracer.lab.primitive.IUpdate;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class ResTest2Scene extends ObjectContainer3D implements IUpdate
  {
    public function ResTest2Scene()
    {
      super();
      initLights();
      initObjects();
    }
    private var point:PointLight;
    private var lightPicker:StaticLightPicker;

    private function initLights():void
    {
      point = new PointLight();
      point.z = -300;
      lightPicker = new StaticLightPicker([point]);
      addChild(point);
    }

    private function initObjects():void {
      var mat:ColorMaterial = new ColorMaterial(0xFF0000);
      mat.lightPicker = lightPicker;
      var geom:CubeGeometry = new CubeGeometry();
      var mesh:Mesh = new Mesh(geom, mat);
      addChild(mesh);
    }

    public function update(rateX:Number, rateY:Number):void
    {
      rotationY += (rateX - rotationY)*0.1;
      rotationX += (-rateY - rotationX)*0.1;
    }
  }
}
