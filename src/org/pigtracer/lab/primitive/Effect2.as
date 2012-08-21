package org.pigtracer.lab.primitive
{
  import org.pigtracer.lab.data.Effect2Pos;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import away3d.events.MouseEvent3D;
  import org.pigtracer.lab.managers.LightsManager;
  import away3d.containers.View3D;
  import com.greensock.TweenLite;
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import org.pigtracer.lab.data.QualityData;
  import org.pigtracer.lab.interfaces.IEffect;
  import flash.geom.Vector3D;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.CubeGeometry;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Effect2 extends ObjectContainer3D implements IEffect, IUpdate{
    public function Effect2(mater:MainMessage, container:DisplayObjectContainer, view:View3D) {
      this.master = mater;
      this.container = container;
      this.view = view;

      super();
      init();
    }

    private var master:MainMessage;
    private var qd:QualityData;
    private var view:View3D;
    private var container:DisplayObjectContainer;
    private var defaultMat:ColorMaterial;

    private var effect2Data:Effect2Pos;

    public const N:int = 9;
    private var meshList:Vector.<MeshWithData> = new Vector.<MeshWithData>();
    private var matList:Vector.<ColorMaterial> = new Vector.<ColorMaterial>();
    private var lineList:Vector.<LineExtened> = new Vector.<LineExtened>();

    public function update(rateX:Number, rateY:Number):void
    {
      for (var i:int = 0; i < N; i++) {
        var flag:DisplayObject = qd.CN[i];
        var mesh:Mesh = meshList[i];
        var flagPos:Vector3D = view.project(mesh.scenePosition);
        flag.x = flagPos.x;
        flag.y = flagPos.y;
      }
    }

    private function init():void {
      initMat();
      initCube();
      initNames();
    }

    private function initMat():void
    {
      var mat1:ColorMaterial = new ColorMaterial(ColorConst.MAIN_PART_A);
      var mat2:ColorMaterial = new ColorMaterial(ColorConst.MAIN_PART_B);
      var mat3:ColorMaterial = new ColorMaterial(ColorConst.MAIN_PART_C);

      mat1.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;
      mat2.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;
      mat3.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;

      matList.push(mat1, mat2, mat3);
    }

    private function initNames():void
    {
      qd = new QualityData();
      const N:int = qd.CN.length;
      for (var i:int = 0; i < N; i++) {
        var flag:DisplayObject = qd.CN[i];
        flag.visible = false;
        container.addChild(flag);
      }
    }

    private function initCube():void {
      effect2Data = new Effect2Pos();

      var geom:CubeGeometry = new CubeGeometry(30, 30, 30, 3, 3, 3);
      defaultMat = new ColorMaterial(0xCCCCCC);
      defaultMat.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;

      for (var i:int = 0; i < N; i++) {
        var mesh:MeshWithData = new MeshWithData(geom, defaultMat);
        var origin:Vector3D = genRan(i);
        var target:Vector3D = origin.clone();
        target.y += 100;
        var data:MeshData = new MeshData(i, origin, target);
        mesh.data = data;
        mesh.position = data.origin;
        mesh.mouseEnabled = true;

        mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);

        master.addChild(mesh);
        meshList.push(mesh);

        if (i == 0) {
          continue;
        }

        var start:Vector3D = meshList[i-1].position.add(new Vector3D(0, 100));
        var end:Vector3D = meshList[i].position.add(new Vector3D(0, 70));
        var temp:Vector3D = end.subtract(start);
        temp.x *= Math.random();
        temp.y *= Math.random();
        temp.y += 300;
        temp.z *= Math.random();
        var middle:Vector3D = start.add(temp);
        var path:QuadraticPath = new QuadraticPath(new <Vector3D>[start, middle, end]);
        var newList:Vector.<Vector3D> = new Vector.<Vector3D>();

        for (var j:int = 0; j < 100; j++)
        {
          var t1:Number = j / 100;
          var segment:IPathSegment = path.segments[0];
          newList.push(segment.getPointOnSegment(t1));
        }
        var color:uint = getColor(i);
        var line:LineExtened = new LineExtened(newList, 0, color, color, 5, 5);
        lineList.push(line);
        addChild(line);
      }
    }

    private function getColor(factor:int):uint
    {
      var list:Array = [ColorConst.MAIN_PART_A, ColorConst.MAIN_PART_B, ColorConst.MAIN_PART_C];
      return list[factor%3];
    }

    private function genRan(index:int) : Vector3D {
      var pos:Array = effect2Data.getPos(index);
      return new Vector3D(pos[0], -50, pos[1]);
    }

    public function show():void
    {
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        var flag:DisplayObject = qd.CN[i];

//        flag.visible = true;
//        TweenLite.to(flag, 0.5, {alpha:1});
        TweenLite.to(mesh, 0.5, {y:50});
      }
    }

    public function hide():void
    {
      const LN:int = lineList.length;
      for (var j:int = 0; j < LN; j++) {
        var line:LineExtened = lineList[j];
        TweenLite.to(line, 0.5, {delay:j*0.3, t:0});
      }

      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        var flag:DisplayObject = qd.CN[i];
        TweenLite.to(flag, 0.5, {alpha:0});
        TweenLite.to(mesh, 0.5, {delay:3, y:-50});
      }
    }

    private function mouseOutHandler(event:MouseEvent3D):void
    {
      var mesh:MeshWithData = event.object as MeshWithData;
      var data:MeshData = mesh.data as MeshData;
      var index:int = data.index;
      var classType:int = index / 3;
      var startIndex:int = classType * 3;
      var matIndex:int = 0;
      for (var i:int = startIndex; i < startIndex + 3; i++) {
        var mt:Mesh = meshList[i];
        mt.material = defaultMat;
        matIndex++;
      }
    }

    private function mouseOverHandler(event:MouseEvent3D):void
    {
      var mesh:MeshWithData = event.object as MeshWithData;
      var data:MeshData = mesh.data as MeshData;
      var index:int = data.index;
      var classType:int = index / 3;
      var startIndex:int = classType * 3;
      var matIndex:int = 0;
      for (var i:int = startIndex; i < startIndex + 3; i++) {
        var mt:Mesh = meshList[i];
        mt.material = matList[matIndex];
        matIndex++;
      }
    }

    private function mouseDownHandler(event:MouseEvent3D):void
    {
      var mesh:MeshWithData = event.object as MeshWithData;
      var data:MeshData = mesh.data as MeshData;
      var index:int = data.index;
      var classType:int = index / 3;

      for (var i:int = 0; i < 2; i++) {
        var lineIndex:int = classType * 3 + i;
        TweenLite.to(lineList[lineIndex], 0.5, {delay:i*0.5, t:1});
      }

      for (var j:int = 0; j < 3; j++) {
        var flag:DisplayObject = qd.CN[j + classType*3];
        flag.alpha = 0;
        flag.visible = true;
        TweenLite.to(flag, 0.5, {alpha:1});
      }
    }

  }
}
import flash.geom.Vector3D;

class MeshData {
  public var index:int;
  public var origin:Vector3D;
  public var target:Vector3D;
  /**
   * Construct a <code>MeshData</code>.
   */
  public function MeshData(i:int, o:Vector3D, t:Vector3D) {
    index = i;
    origin = o;
    target = t;
  }
}