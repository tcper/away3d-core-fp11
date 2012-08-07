package org.pigtracer.lab
{
  import org.pigtracer.lab.utils.SegmentMapGenerator;
  import away3d.materials.utils.WireframeMapGenerator;
  import org.pigtracer.lab.primitive.WireframeMesh;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.PlaneGeometry;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class Test7Dot extends BaseScene
  {
    public function Test7Dot()
    {
      super();
    }

    override protected function initObjects():void
    {
      var geom:PlaneGeometry = new PlaneGeometry();
      var mat:ColorMaterial = new ColorMaterial();
      var mesh:Mesh = new Mesh(geom, mat);
      var wireframe:WireframeMesh = SegmentMapGenerator.generateWireframe(mesh);
      scene.addChild(wireframe);
    }

  }
}
