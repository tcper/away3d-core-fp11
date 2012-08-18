package org.pigtracer.lab.primitive {
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
    
    public function LineExtened(source:Vector.<Vector3D>, t:Number = 0, 
                                startColor:uint = 0xFF0000, endColor:uint = 0xFF0000,
                                startThick:Number = 1, endThick:Number = 1) {
      _source = source;
      _numVectices = _source.length - 1;
      _t = t;
      
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
      var lastIndex:int = _t;
      _t = value;
      var targetIndex:int = _numVectices * _t;
      var i:int = 0;
      var segment:Segment;
      
      if (lastIndex < targetIndex) {
        for (i = lastIndex + 1; i < targetIndex; i++) {
          segment = _segmentList[i];
          addSegment(segment);
        }
      } else {
        for (i = lastIndex; i > targetIndex; i--) {
          segment = _segmentList[i];
          removeSegment(segment);
        }
      }
    }
  }
}
