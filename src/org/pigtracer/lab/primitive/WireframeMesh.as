package org.pigtracer.lab.primitive {
  import flash.trace.Trace;
  import away3d.arcane;
  import away3d.primitives.LineSegment;
  import flash.geom.Vector3D;
  import away3d.primitives.data.Segment;
  import away3d.entities.SegmentSet;

  /**
   * @author loki
   */
  public class WireframeMesh extends SegmentSet
  {
    public function WireframeMesh()
    {
      super();
    }
    //==========================================================================
    //  Variables
    //==========================================================================
    private var edges:Vector.<Edge> = new Vector.<Edge>();
    public function drawConnects(vertices:Vector.<Number>, indices:Vector.<uint>):void {
      
      const len:int = indices.length;
      for (var i:int = 0; i < len; i+=3) {
        var indexa:uint = indices[i];
        var indexb:uint = indices[i+1];
        var indexc:uint = indices[i+2];

        var triangleEdges:Array = createEdge(indexa, indexb, indexc);

        //-----
//        var v:Vector3D = getVertex(vertices, i);
//        trace(i/3, v);
        //-----

        for (var j:int = 0; j < 3; j++) {
          var ie:Array = triangleEdges[j];

          var ia:uint = ie[0];
          var ib:uint = ie[1];
          //trace("[WireframeMesh/ia ib]", ia, ib);

          if (!checkUnique(ia, ib)) {
            continue;
          }

          var va:Vector3D = getVertex(vertices, ia);
          var vb:Vector3D = getVertex(vertices, ib);
          
          if (!checkVec(va, vb)) {
            continue;
          }
          
          edges.push(new Edge(va, vb, ia, ib));
        }
      }

      const edgeLen:int = edges.length;

      for (i = 0; i < edgeLen; i++) {
        var edge:Edge = edges[i];
        //trace("[WireframeMesh/drawConnects]", i, edge.indices[0], edge.indices[1]);

        //addSegment(new LineSegment(edge.vertices[0], edge.vertices[1]))
        var lse:LineSegmentExtra = new LineSegmentExtra(edge.vertices[0], edge.vertices[1], 0xFF0000, 0xFF0000);
        lse.target = new LineData(generateRandom(), generateRandom(), 0xFF0000);
        addSegment(lse);
      }
    }


    public function go():void {
      const len:int = _segments.length;
      for (var i:int = 0; i < len; i++) {
        var lse:LineSegmentExtra = _segments[i] as LineSegmentExtra;
        lse.go();
      }
    }

    public function back():void {
      const len:int = _segments.length;
      for (var i:int = 0; i < len; i++) {
        var lse:LineSegmentExtra = _segments[i] as LineSegmentExtra;
        lse.back();
      }
    }

    private function generateRandom() : Vector3D {
      return new Vector3D(Math.random()*100 - 50, Math.random()*100 - 50, Math.random()*100 - 50);
    }

    private function getVertex(source:Vector.<Number>, index:int):Vector3D {
      return new Vector3D(source[index*3], source[index*3+1], source[index*3+2]);
    }

    private function createEdge(a:int, b:int, c:int):Array {
      return [[a,b], [b,c], [c,a]];
    }
    
    private function checkVec(v1:Vector3D, v2:Vector3D):Boolean {
      const len:int = edges.length;
      for (var i:int = 0; i < len; i++) {
        var edge:Edge = edges[i];
        var ev1:Vector3D = edge.vertices[0];
        var ev2:Vector3D = edge.vertices[1];
        if (ev1.equals(v1) && ev2.equals(v2)) {
          return false;
        }
        
        if (ev2.equals(v1) && ev1.equals(v2)) {
          return false;
        }
      }
      return true;
    }
    
    private function checkUnique(a:uint, b:uint):Boolean {
      const len:int = edges.length;
      for (var i:int = 0; i < len; i++) {
        var edge:Edge = edges[i];
        if (edge.check(a, b)) {
          return false;
        }
      }
      return true;
    }



  }
}


import flash.geom.Vector3D;


class Edge {
  public var indices:Vector.<uint>;
  public var vertices:Vector.<Vector3D>;

  public function Edge(a:Vector3D, b:Vector3D, indexa:uint, indexb:uint) {
    vertices = new <Vector3D>[a, b];
    indices = new <uint>[indexa, indexb];
  }

  public function check(a:uint, b:uint):Boolean {

    if ((indices[0] == a) && (indices[1] == b)) {
      return true;
    }

    if ((indices[0] == b) && (indices[1] == a)) {
      return true;
    }
    return false;
  }
}