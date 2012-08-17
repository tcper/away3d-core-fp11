package org.pigtracer.lab.primitive
{
  import away3d.materials.ColorMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.entities.Mesh;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Stuff extends ObjectContainer3D
  {
    private var bgPlane:Mesh;
    private var bgGeom:PlaneGeometry;
    public var bgMaterial:ColorMaterial;

    public function Stuff()
    {
      super();

      
    }
  }
}
