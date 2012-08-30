package org.pigtracer.lab.experiment
{
  import away3d.primitives.LineSegment;
  import flash.geom.Vector3D;
  import away3d.entities.SegmentSet;

  /**
   * @author loki
   */
  public class LIneExperiment extends SegmentSet
  {
    //----------------------------------
    //  meta
    //----------------------------------
    private var _meta:LineMeta;
    public function get meta():LineMeta {
      return _meta;
    }

    public function LIneExperiment(data:LineMeta)
    {
      _meta = data;
      super();
      initSegment();
    }

    //----------------------------------
    //  startT
    //----------------------------------
    private var _startT:Number;
    public function get startT():Number {
      return _startT;
    }
    public function set startT(value:Number):void {
      if (value < 0 || value > 1) {
        return;
      }
      _startT = value;
      updateSegments();
    }

    //----------------------------------
    //  endT
    //----------------------------------
    private var _endT:Number;
    public function get endT():Number {
      return _endT;
    }
    public function set endT(value:Number):void {
      if (value < 0 || value > 1) {
        return;
      }
      _endT = value;
      updateSegments();
    }
    //==========================================================================
    //  Variables
    //==========================================================================
    private var _segmentList:Vector.<LineSegment>;

    private function initSegment():void {
      _segmentList = _meta.generateSegments();
      for (var i:int = 0; i < _meta.numVertices; i++) {
        addSegment(_segmentList[i]);
      }
    }

    private function updateSegments():void {
      var startIndex:int = _meta.numVertices * _startT;
      var endIndex:int = _meta.numVertices * endT;

      updateStartSegment(startIndex);
      updateEndSegment(endIndex);
    }

    private function updateEndSegment(endIndex:int):void
    {
      
    }

    private function updateStartSegment(startIndex:int):void
    {
    }
  }
}
