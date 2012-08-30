package org.pigtracer.lab.experiment
{
  import away3d.primitives.LineSegment;
  import flash.geom.Vector3D;
  /**
   * @author loki
   */
  public class LineMeta
  {
    //----------------------------------
    //  source
    //----------------------------------
    private var _source:Vector.<Vector3D>;
    public function get source():Vector.<Vector3D> {
      return _source;
    }

    //----------------------------------
    //  startT
    //----------------------------------
    private var _startT:Number = 0;
    public function get startT():Number {
      return _startT;
    }

    //----------------------------------
    //  endT
    //----------------------------------
    private var _endT:Number = 0;
    public function get endT():Number {
      return _endT;
    }

    //----------------------------------
    //  startColor
    //----------------------------------
    private var _startColor:uint;
    public function get startColor():uint {
      return _startColor;
    }

    //----------------------------------
    //  endColor
    //----------------------------------
    private var _endColor:uint;
    public function get endColor():uint {
      return _endColor;
    }

    //----------------------------------
    //  startThick
    //----------------------------------
    private var _startThick:Number = 1;
    public function get startThick():Number {
      return _startThick;
    }

    //----------------------------------
    //  endThick
    //----------------------------------
    private var _endThick:Number = 1;
    public function get endThick():Number {
      return _endThick;
    }

    //----------------------------------
    //  numVertices
    //----------------------------------
    private var _numVertices:int;
    public function get numVertices():int {
      return _numVertices;
    }

    private var colorOffset:Number;
    private var thickOffset:Number;

    /**
     * Construct a <code>LineMeta</code>.
     */
    public function LineMeta(source:Vector.<Vector3D>, start_t_ref:Number = 0, end_t_ref:Number = 0,
                            startColor:uint = 0xFF0000, endColor:uint = 0xFF0000,
                            startThick:Number = 1, endThick:Number = 1) {
      _source = source;
      _startT = start_t_ref;
      _endT = end_t_ref;
      _startColor = startColor;
      _endColor = endColor;
      _startThick = startThick;
      _endThick = endThick;

      _numVertices = _source.length - 2;

      var temp:int = endColor - startColor;
      var isBack:Boolean;
      if (temp < 0) {
        isBack = true;
        temp = Math.abs(temp);
      } else {
        isBack = false;
      }
      var _startR:Number = (( temp >> 16 ) & 0xff) / _numVertices;
      var _startG:Number = (( temp >> 8 ) & 0xff) / _numVertices;
      var _startB:Number = (temp & 0xff) / _numVertices;

      colorOffset = (_startR << 16) + (_startG << 8) + _startB;
      if (isBack) {
        colorOffset = -colorOffset;
      }

      thickOffset = (endThick - _startThick) / _numVertices;
    }

    public function getSegment(i:int):LineSegment {
      if (i < 0 || i > _numVertices) {
        return null;
      }

      var v0:Vector3D = _source[i-1];
      var v1:Vector3D = _source[i];

      var c0:uint = _startColor + colorOffset*(i-1);
      var c1:uint = c0 + colorOffset;

      var thick:Number = _startThick + thickOffset * i;

      var segment:LineSegment = new LineSegment(v0, v1, c0, c1, thick);
      return segment;
    }

    public function generateSegments():Vector.<LineSegment> {
      var list:Vector.<LineSegment> = new Vector.<LineSegment>();
      const N:int = _source.length;
      for (var i:int = 1; i < N; i++) {
        var segment:LineSegment = getSegment(i);
        list.push(segment);
      }
      return list;
    }
  }
}
