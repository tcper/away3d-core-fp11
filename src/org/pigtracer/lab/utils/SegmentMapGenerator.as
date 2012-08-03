package org.pigtracer.lab.utils
{
  import org.pigtracer.lab.primitive.WireframeMesh;
  import away3d.core.base.SubGeometry;
  import away3d.entities.Mesh;
  import away3d.entities.SegmentSet;
  /**
   * @author loki
   */
  public class SegmentMapGenerator
  {
    public static function generateWireframe(mesh:Mesh):WireframeMesh {
      var target:WireframeMesh = new WireframeMesh();
      for (var i:int = 0; i < mesh.subMeshes.length; i++) {
        drawLines(mesh.subMeshes[i].subGeometry, target);
      }
      return target;
    }

    private static function drawLines(subGeom:SubGeometry, target:WireframeMesh):void {
      //var sprite : Sprite = new Sprite();
      //var g : Graphics = sprite.graphics;
      var uvs : Vector.<Number> = subGeom.vertexData;
      var vertexList:Vector.<Number> = subGeom.vertexData;
      var i : uint, len : uint = uvs.length;
      //var w : Number = bitmapData.width, h : Number = bitmapData.height;
      var texSpaceV : Vector.<Number> = new Vector.<Number>(len, true);
      var indices : Vector.<uint> = subGeom.indexData;
      var indexClone : Vector.<uint>;
/*
      do {
        texSpaceV[i] = vertexList[i]; ++i;
        texSpaceV[i] = vertexList[i];
      } while (++i < len);*/

      len = indices.length;
      indexClone = new Vector.<uint>(len, true);
      i = 0;
      // awesome, just to convert from uint to int vector -_-
      do {
        indexClone[i] = indices[i];
      } while(++i < len);

      //trace("[SegmentMapGenerator/drawLines]", texSpaceV, texSpaceV.length);
      //trace("[SegmentMapGenerator/drawLines]", indexClone, indexClone.length);
      //trace("[SegmentMapGenerator/drawLines]", subGeom.vertexData, subGeom.vertexData.length);
      //trace("[SegmentMapGenerator/drawLines]", subGeom.indexData, subGeom.indexData.length);
      
      //target.drawConnects(texSpaceV, indexClone);
      target.drawConnects(subGeom.vertexData, subGeom.indexData);

    }
  }
}
