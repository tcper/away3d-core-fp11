package org.pigtracer.lab.primitive
{
  import away3d.core.base.data.Vertex;
  /**
   * @author loki
   */
  public class LineParser
  {
    private var _vertices:Vector.<Vertex>;

    public function parse(source:String):Path {
      var lineList:Array = source.split("\n");
      const len:int = lineList.length;
      var trunk:Array;
      _vertices = new Vector.<Vertex>();

      for (var i:int = 0; i < len; i++) {
        var line:String = lineList[i];
        trunk = line.replace("  "," ").split(" ");
        parseLine(trunk);
      }
      return new Path(_vertices);
    }

    private function parseLine(trunk:Array):void
    {
      switch (trunk[0]) {
        case "v":
          parsePoint(trunk);
          break;
      }
    }

    private function parsePoint(trunk:Array):void
    {
      _vertices.push(new Vertex(parseFloat(trunk[1]), parseFloat(trunk[2]), -parseFloat(trunk[3])));
    }
  }
}
