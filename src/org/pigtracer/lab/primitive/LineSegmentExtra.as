package org.pigtracer.lab.primitive {
  import away3d.entities.SegmentSet;
  import com.greensock.TweenLite;
  import away3d.primitives.LineSegment;

  import flash.geom.Vector3D;

  /**
   * @author loki
   */
  public class LineSegmentExtra extends LineSegment {
    public function LineSegmentExtra(v0:Vector3D, v1:Vector3D, color0:uint = 0x333333, color1:uint = 0x333333, thickness:Number = 1) {
      _origin = new LineData(v0, v1, color0, thickness);
      super(v0, v1, color0, color1, thickness);
    }
    //----------------------------------
    //  origin
    //----------------------------------
    private var _origin:LineData;
    public function get origin():LineData {
      return _origin;
    }
    //----------------------------------
    //  target
    //----------------------------------
    private var _target:LineData;
    public function get target():LineData {
      return _target;
    }

    private var _parent:SegmentSet;

    public function set target(value : LineData) : void {
      _target = value;
    }

    public function go():void {
      if (!target) {
        return;
      }
      var targetStart:Vector3D = target.start;
      var targetEnd:Vector3D = target.end;


      motion(this.start, targetStart, false);
      motion(this.end, targetEnd, true);
    }
    public function back():void {
      if (!origin) {
        return;
      }

      var targetStart:Vector3D = _origin.start;
      var targetEnd:Vector3D = _origin.end;

      motion(this.start, targetStart, false);
      motion(this.end, targetEnd, true);
    }

    private function motion(self:Vector3D, to:Vector3D, isUpdate:Boolean):void {
      if (!isUpdate) {
        TweenLite.to(self, 5, {x:to.x, y:to.y, z:to.z});
      } else {
        TweenLite.to(self, 5, {x:to.x, y:to.y, z:to.z, onUpdate:updateSegment, onUpdateParams:[this.start, this.end, null, 0xFF0000]});
      }
    }
  }
}
