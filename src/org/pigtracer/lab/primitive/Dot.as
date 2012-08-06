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
  use namespace arcane;
  public class Dot extends Entity implements IRenderable
  {
    /**
     * Construct a <code>Dot</code>.
     */

    private var _pos:Vector3D;
    private var _color:uint;
    private var _size:int;
    private var _material : MaterialBase;

    public function Dot(pos:Vector3D, color:uint = 0xFFFFFF, size:int = 1) {
      super();
      _pos = pos;
      _color = color;
      _size = size;

      material = new DotMaterial();
    }

    public function getVertexBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getCustomBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getSecondaryUVBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getVertexNormalBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getVertexTangentBuffer(stage3DProxy:Stage3DProxy):VertexBuffer3D
    {
      return null;
    }

    public function getIndexBuffer(stage3DProxy:Stage3DProxy):IndexBuffer3D
    {
      return null;
    }

    public function get numTriangles():uint
    {
      return 0;
    }

    public function get sourceEntity():Entity
    {
      return null;
    }

    public function get castsShadows():Boolean
    {
      return false;
    }

    public function get vertexData():Vector.<Number>
    {
      return null;
    }

    public function get indexData():Vector.<uint>
    {
      return null;
    }

    public function get UVData():Vector.<Number>
    {
      return null;
    }

    public function get uvTransform():Matrix
    {
      return null;
    }

    public function get vertexBufferOffset():int
    {
      return 0;
    }

    public function get normalBufferOffset():int
    {
      return 0;
    }

    public function get tangentBufferOffset():int
    {
      return 0;
    }

    public function get UVBufferOffset():int
    {
      return 0;
    }

    public function get secondaryUVBufferOffset():int
    {
      return 0;
    }

    public function get material():MaterialBase
    {
      return _material;
    }

    public function set material(value:MaterialBase):void
    {
      if (value == _material) return;
      if (_material) _material.removeOwner(this);
      _material = value;
      if (_material) _material.addOwner(this);
    }

    public function get animator():IAnimator
    {
      return null;
    }
  }
}
