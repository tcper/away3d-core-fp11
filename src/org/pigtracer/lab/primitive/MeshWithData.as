package org.pigtracer.lab.primitive {
  import away3d.entities.Mesh;
  import away3d.core.base.Geometry;
  import away3d.materials.MaterialBase;

  /**
   * @author loki
   */
  public class MeshWithData extends Mesh {
    public function MeshWithData(geometry:Geometry, material:MaterialBase = null) {
      super(geometry, material);
    }
    public var data:Object;
  }
}
