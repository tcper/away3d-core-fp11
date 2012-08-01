package org.pigtracer.lab.primitive
{
  import away3d.core.base.data.Vertex;
  import away3d.primitives.LineSegment;
  import flash.geom.Vector3D;
  import away3d.entities.SegmentSet;

  /**
   * @author loki
   */
  public class Path extends SegmentSet
  {
    public function Path(data:Vector.<Vertex>, color:uint = 0xFF0000)
    {
      const len:int = data.length;
      for (var i:int = 1; i < len; i++) {
        var last:Vertex = data[i-1];
        var current:Vertex = data[i];
        addSegment(new LineSegment(new Vector3D(last.x, last.y, last.z), new Vector3D(current.x, current.y, current.z), color, color));
      }
    }
  }
}
