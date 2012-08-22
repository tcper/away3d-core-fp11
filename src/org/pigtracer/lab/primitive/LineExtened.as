package org.pigtracer.lab.primitive
{
  import com.adobe.utils.ArrayUtil;
  import away3d.arcane;
  import away3d.primitives.data.Segment;
  import away3d.primitives.LineSegment;
  import flash.geom.Vector3D;
  import away3d.entities.SegmentSet;

  /**
   * @author loki
   */
  public class LineExtened extends SegmentSet {
    private var _t:Number;
    private var _source:Vector.<Vector3D>;
    private var _segmentList:Vector.<LineSegment> = new Vector.<LineSegment>();
    private var _numVectices:int;

    private var colorOffset:Number;
    private var _startColor:uint;

    private var _startThick:Number;
    private var thickOffset:Number;
    private var lastIndex:int = 0;

    private var addedList:Vector.<int> = new Vector.<int>();
    private var notInList:Vector.<int> = new Vector.<int>();

    use namespace arcane;

    public function LineExtened(source:Vector.<Vector3D>, ref_t:Number = 0,
                                startColor:uint = 0xFF0000, endColor:uint = 0xFF0000,
                                startThick:Number = 1, endThick:Number = 1) {
      _source = source;
      _numVectices = _source.length - 2;
      //for 100 point -> 99 connects

      _startColor = startColor;
      var temp:int = endColor - startColor;
      var isBack:Boolean;
      if (temp < 0) {
        isBack = true;
        temp = Math.abs(temp);
      } else {
        isBack = false;
      }
      var _startR:Number = (( temp >> 16 ) & 0xff) / _numVectices;
      var _startG:Number = (( temp >> 8 ) & 0xff) / _numVectices  ;
      var _startB:Number = (temp & 0xff) / _numVectices  ;

      colorOffset = (_startR << 16) + (_startG << 8) + _startB;
      if (isBack) {
        colorOffset = -colorOffset;
      }

      _startThick = startThick;
      thickOffset = (endThick - _startThick) / _numVectices;

      init();
      this.t = ref_t;
    }

    private function init():void {
      const len:int = _source.length;
      for (var i:int = 1; i < len; i++) {
        var v0:Vector3D = _source[i-1];
        var v1:Vector3D = _source[i];

        var c0:uint = _startColor + colorOffset*(i-1);
        var c1:uint = c0 + colorOffset;

        var thick:Number = _startThick + thickOffset * i;
        var segment:LineSegment = new LineSegment(v0, v1, c0, c1, thick);
        _segmentList.push(segment);
      }
    }

    private function checkSegment(index:int):Boolean
    {
      const N:int = addedList.length;
      for (var i:int = 0; i < N; i++) {
        var compare:int = addedList[i];
        if (compare == index) {
          return true;
        }
      }
      return false;
    }

    private function addIndex(index:int):void {
      addedList.push(index);
    }

    private function removeIndex(index:int):void {
      const N:int = addedList[i];
      for (var i:int = 0; i < N; i++) {
        var compare:int = addedList[i];
        if (compare == index) {
          addedList.splice( i, 1 );
        }
      }
    }

    //----------------------------------
    //  t
    //----------------------------------
    public function get t():Number {
      return _t;
    }
    public function set t(value:Number):void {
      if (value < 0 || value > 1) {
        return;
      }
      if (value == _t) {
        return;
      }

      _t = value;
      var targetIndex:int = _numVectices * _t;

      //trace("[LineExtened/t]", value, _numVectices, lastIndex, targetIndex);

      var i:int = 0;
      var segment:Segment;

      if (lastIndex < targetIndex) {
        for (i = 0; i < targetIndex; i++) {
          segment = _segmentList[i];
          if (!checkSegment(i)) {
            addSegment(segment);
            addIndex(i);
          }
        }
      } else {
        for (i = lastIndex; i >= targetIndex; i--) {
          segment = _segmentList[i];
          if (checkSegment(i)) {
            removeSegment(segment);
            removeIndex(i);
          }
        }
      }

      lastIndex = targetIndex;
    }

  }
}
