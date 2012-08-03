package org.pigtracer.lab.primitive
{
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

        for (var j:int = 0; j < 3; j++) {
          var ie:Array = triangleEdges[j];

          var ia:uint = ie[0];
          var ib:uint = ie[1];

          /*if (!checkUnique(ia, ia)) {
            continue;
          }*/

          var va:Vector3D = getVertex(vertices, ia);
          var vb:Vector3D = getVertex(vertices, ib);
          edges.push(new Edge(va, vb, ia, ib));
        }
      }

      const edgeLen:int = edges.length;

      for (i = 0; i < edgeLen; i++) {
        var edge:Edge = edges[i];
        //addSegment(new LineSegment(edge.vertices[0], edge.vertices[1]))
        addSegment(new LineSegment(edge.vertices[0], edge.vertices[1], 0xFF0000, 0xFF0000));
      }
    }

    private function getVertex(source:Vector.<Number>, index:int):Vector3D {
      return new Vector3D(source[index*3], source[index*3+1], source[index*3+2]);
    }

    private function createEdge(a:int, b:int, c:int):Array {
      return [[a,b], [b,c], [c,a]];
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
    if (indices[0] == a && indices[1] == b) {
      return true;
    }

    if (indices[1] == b && indices[0] == a) {
      return true;
    }
    return false;
  }
}