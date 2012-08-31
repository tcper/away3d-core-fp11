package org.pigtracer.lab.experiment
{
  import away3d.primitives.data.Segment;
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
      initValues();
      initSegment();
    }

    private function initValues():void
    {
      currentStartIndex = _meta.numVertices * _meta.startT;
      currentEndIndex = _meta.numVertices * _meta.endT;
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

      if (!startValidCheck(value)){
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

      if (!endValidCheck(value)) {

      }

      _endT = value;
      updateSegments();
    }

    //==========================================================================
    //  Variables
    //==========================================================================
    private var currentEndIndex:int;
    private var currentStartIndex:int;

    private var _segmentList:Vector.<LineSegment>;

    private function initSegment():void {
      _segmentList = _meta.generateSegments();
      for (var i:int = currentStartIndex; i < currentEndIndex; i++) {
        addSegment(_segmentList[i]);
      }
      removeSegment(_segmentList[0]);
    }

    private function updateSegments():void {
      var startIndex:int = _meta.numVertices * _startT;
      var endIndex:int = _meta.numVertices * endT;
      updateStartSegment(startIndex);
      //updateEndSegment(endIndex);
    }

    private function updateEndSegment(endIndex:int):void
    {
      if (endIndex == currentEndIndex) {
        return;
      }
      var i:int;
      var segment:Segment;

      if (endIndex > currentEndIndex) {
        for (i = currentEndIndex + 1; i < endIndex; i++) {
          segment = _segmentList[i];
          addSegment(segment);
        }
      } else {
        for (i = currentEndIndex; i > endIndex; i--) {
          segment = _segmentList[i];
          removeSegment(segment);
        }
      }

      currentEndIndex = endIndex;
    }

    private function updateStartSegment(startIndex:int):void
    {
      if (currentStartIndex == startIndex) {
        return;
      }

      var i:int;
      var segment:Segment;


      if (startIndex > currentStartIndex) {
        for (i = currentStartIndex; i < startIndex; i++) {
          segment = _segmentList[i];
          removeSegment(segment);
        }
      } else {
        for (i = currentStartIndex; i > startIndex; i--) {
          segment = _segmentList[i];
          addSegment(segment);
        }
      }

      currentStartIndex = startIndex;
    }

    private function endValidCheck(value:Number):Boolean
    {
      if (value > _startT) {
        return true;
      }
      return false;
    }

    private function startValidCheck(value:Number):Boolean
    {
      if (value < _endT) {
        return true;
      }
      return false;
    }
  }
}
