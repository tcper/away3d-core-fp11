package org.pigtracer.lab.primitive
{
  import com.greensock.TweenLite;
  import away3d.primitives.LineSegment;
  import away3d.primitives.data.Segment;
  import flash.geom.Vector3D;
  import away3d.arcane;
  import away3d.entities.SegmentSet;

  /**
   * @author loki
   */
  use namespace arcane;

  public class Line extends SegmentSet
  {


    public function Line(start:Vector3D, end:Vector3D)
    {
      addSegment(new LineSegment(start, end, 0xFF0000, 0xFF0000, 1));
    }

    public function changeEnd():void {
      var segment:Segment = getSegment(0);
      TweenLite.to(segment.end, 1, {x:segment.end.x + 100, onUpdate:updateSegment, onUpdateParams:[segment]});
      //updateSegment(segment);
    }


    protected function updateOfAddSegment(index:uint, v0:Vector3D, v1:Vector3D):void {
    }

  }
}
