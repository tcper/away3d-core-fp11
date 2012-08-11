package org.pigtracer.lab.primitive
{
  import away3d.arcane;
  import flash.geom.Vector3D;
  import away3d.core.managers.Stage3DProxy;

  import flash.display3D.VertexBuffer3D;
  import flash.display3D.IndexBuffer3D;
  import flash.geom.Matrix;

  import away3d.materials.MaterialBase;
  import away3d.animators.IAnimator;
  import away3d.core.base.IRenderable;
  import away3d.entities.Entity;
  /**
   * @author loki
   */

  public class Dot
  {
    /**
     * Construct a <code>Dot</code>.
     */

    public var pos:Vector3D;
    public var color:uint;
    public var size:int;
    public var alpha:Number;
    public var index:int;

    public function Dot(pos:Vector3D, color:uint = 0xFFFFFF, size:int = 1) {
      super();
      this.pos = pos;
      this.color = color;
      this.size = size;
    }
  }
}
