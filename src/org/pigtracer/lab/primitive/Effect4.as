package org.pigtracer.lab.primitive
{
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import away3d.paths.IPath;
  import away3d.containers.Scene3D;
  import away3d.materials.methods.HardShadowMapMethod;
  import away3d.lights.DirectionalLight;
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.lights.PointLight;
  import com.greensock.TweenLite;
  import away3d.events.MouseEvent3D;
  import flash.geom.Vector3D;
  import away3d.primitives.CubeGeometry;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.containers.ObjectContainer3D;

  import org.pigtracer.lab.interfaces.IEffect;
  import org.pigtracer.lab.primitive.IUpdate;

  /**
   * @author loki
   */
  [SWF(width="1600", height="1024", backgroundColor="0xFFFFFF", frameRate="120")]
  public class Effect4 extends ObjectContainer3D implements IEffect, IUpdate
  {
    public function Effect4(scene:Scene3D)
    {
      _s = scene;
      super();
      init();
    }

    private var _s:Scene3D;
    private const N:int = 4;
    private var CLASS_N:int = 3;

    private var currentClassType:int = 0;
    private var meshList:Vector.<MeshWithData> = new Vector.<MeshWithData>();

    private var sceneList:Array = [];
    private var sceneLineList:Array = [];

    private var lineList:Vector.<LineExtened> = new Vector.<LineExtened>();

    private var pointLight:PointLight;
    private var lightPicker:StaticLightPicker;

    private function init():void
    {
      initLights();
      initBackground();
      initMeshes();
      initLines();
    }

    private function initLines():void {
      var colorList:Array = [ColorConst.MAIN_PART_A, ColorConst.MAIN_PART_B, ColorConst.MAIN_PART_C];
      for (var i:int = 1; i < CLASS_N; i++) {
        var lastMeshList:Vector.<Mesh> = sceneList[i-1];
        var currentMeshList:Vector.<Mesh> = sceneList[i];
        var lineList:Vector.<LineExtened> = new Vector.<LineExtened>();

        for (var j:int = 0; j < N; j++) {
          var start:Vector3D = lastMeshList[j].position;
          var end:Vector3D = currentMeshList[j].position;
          var path:IPath = generateQuadCurve(start.clone(), end.clone());

          var list:Vector.<Vector3D> = new Vector.<Vector3D>();
          for (var k:int = 0; k < 100; k++) {
            var t1:Number = k / 100;
            var segment:IPathSegment = path.segments[0];
            list.push(segment.getPointOnSegment(t1));
          }

          var color:uint = colorList[i];
          var line:LineExtened = new LineExtened(list, 1, color, color, 5, 5);
          lineList.push(line);
          addChild(line);
        }
        sceneLineList.push(lineList);
      }
    }


    private function generateQuadCurve(start:Vector3D, end:Vector3D):QuadraticPath{
      var temp:Vector3D = end.subtract(start);
      temp.x += (Math.random()*800-400);
      temp.y *= Math.random();
      temp.z *= Math.random();
      var middle:Vector3D = start.add(temp);
      var list:Vector.<Vector3D> = new <Vector3D>[start,
                                                  middle,
                                                  end];
      var path:QuadraticPath = new QuadraticPath(list);
      return path;
    }

    private function initLights():void
    {
       pointLight = new PointLight();
       pointLight.z = -300;
       lightPicker = new StaticLightPicker([pointLight]);

      pointLight.castsShadows = true;
      pointLight.shadowMapper.depthMapSize = 1024;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 1000;
      pointLight.fallOff = 1000;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;
      _s.addChild(pointLight);
    }

    private function initMeshes():void
    {
      var geom:CubeGeometry = new CubeGeometry(30, 30, 30);
      var mat:ColorMaterial = new ColorMaterial(0xCCCCCC);
      mat.lightPicker = lightPicker;

      for (var i:int = 0; i < CLASS_N; i++) {
        var meshList:Vector.<Mesh> = new Vector.<Mesh>();
        for (var j:int = 0; j < N; j++) {
          var mesh:Mesh = new Mesh(geom, mat);
          if (j%2 == 0) {
            mesh.position = getPos(i, j/2);
          } else {
            var lastMesh:Mesh = meshList[j-1];
            var pos:Vector3D = lastMesh.position.clone();
            mesh.position = pos.add(new Vector3D(100, -100, 50));
          }
          if (j == 0) {
            mesh.mouseEnabled = true;
            mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
          }

          addChild(mesh);
          meshList.push(mesh);
        }
        sceneList.push(meshList);
      }
    }

    private function getPos(i:int, j:int):Vector3D
    {
      if (j == 0) {
        return new Vector3D(50*Math.random()-300, 50*Math.random() + 200, i*1000);
      } else {
        return new Vector3D(50*Math.random(), 50*Math.random() + 200, i*1000);
      }
    }

    private function mouseDownHandler(event:MouseEvent3D):void
    {
      var mesh:MeshWithData = event.object as MeshWithData;
      var data:MeshData = mesh.data as MeshData;

    }


    private function initBackground():void
    {
      var geom:PlaneGeometry = new PlaneGeometry(800, 800);
      var mat:ColorMaterial = new ColorMaterial(0xFFFFFF);
      mat.lightPicker = lightPicker;
      mat.shadowMethod = new HardShadowMapMethod(pointLight);
      mat.specular = .25;
      mat.gloss = 20;
      var mesh:Mesh = new Mesh(geom, mat);
      mesh.rotationX = 270;
      addChild(mesh);
    }

    public function show():void
    {
    }

    public function hide():void
    {
    }

    public function update(rateX:Number, rateY:Number):void
    {
      rotationY += (rateX - rotationY)*0.1;
      rotationX += (-rateY - rotationX)*0.1;
    }
  }
}

class MeshData {
  public var index:int;
  /**
   * Construct a <code>MeshData</code>.
   */
  public function MeshData(i:int) {
    index = i;
  }
}
