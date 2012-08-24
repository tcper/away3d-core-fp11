package org.pigtracer.lab.primitive
{
  import away3d.cameras.Camera3D;
  import flash.events.MouseEvent;
  import flash.display.Sprite;
  import away3d.containers.View3D;
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import org.pigtracer.lab.data.Effect4Bitmap;
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
  public class Effect4 extends ObjectContainer3D implements IEffect, IUpdate
  {
    public function Effect4(view:View3D, container:DisplayObjectContainer)
    {
      _s = view.scene;
      this.view = view;
      camera = view.camera;
      this.container = container;
      super();
      init();
    }

    private var _s:Scene3D;
    private var view:View3D;
    private var camera:Camera3D;
    private const N:int = 4;
    private var CLASS_N:int = 3;
    private const SCENE_DEPTH:int = 1000;

    private var currentScene:int = -1;
    private var currentLabelList:Array;
    private var container:DisplayObjectContainer;

    private var sceneList:Array = [];
    private var sceneLineList:Array = [];

    private var lineList:Vector.<LineExtened> = new Vector.<LineExtened>();

    private var pointLight:PointLight;
    private var lightPicker:StaticLightPicker;

    private var labelBitmap:Effect4Bitmap;

    private var goButton:Sprite;

    private function init():void
    {
      initLights();
      //initBackground();
      initMeshes();
      initLabels();
      initLines();
      initButtons();
    }

    private function initButtons():void
    {
      goButton = labelBitmap.goButton;
      goButton.y = -goButton.height;
      goButton.x = container.stage.stageWidth - goButton.width;
      container.addChild(goButton);


      goButton.addEventListener(MouseEvent.CLICK, goClickHandler);
    }

    private function goClickHandler(event:MouseEvent):void
    {
      var nextScene:int;
      if (currentScene + 1 >= CLASS_N) {
        nextScene = 0;
      } else {
        nextScene = currentScene + 1;
      }
      changeSceneLabels(nextScene);
      changeScene(nextScene);
      changeCamera(nextScene);
      currentScene = nextScene;
    }

    private function changeCamera(nextScene:int):void
    {
      var lookat:Vector3D = CameraPos.S4_LOOKAT_POS[nextScene];
      camera.lookAt(lookat);
      var pos:Vector3D = CameraPos.S4_POS[nextScene];
      TweenLite.to(camera, 1, {z:pos.z, x:pos.x, y:pos.y});
    }

    private function changeScene(currentSceneIndex:int):void
    {
      var lineList:Vector.<LineExtened>;
      var line:LineExtened;
      var i:int;

      if (currentSceneIndex == 0) {
        disableAllLines();
      } else {
        lineList = sceneLineList[currentSceneIndex - 1];
        for (i = 0; i < N; i++) {
          line = lineList[i];
          TweenLite.to(line, 1, {t:1});
        }
      }
    }
    private function disableAllLines():void {
      const LN:int = sceneLineList.length;
      var i:int;
      var line:LineExtened;
      for (i = 0; i < LN; i++) {
        lineList = sceneLineList[i];
        for (var j:int = 0; j < N; j++) {
          line = lineList[j];
          TweenLite.to(line, 1, {t:0});
        }
      }
    }

    private function initLabels():void
    {
      labelBitmap = new Effect4Bitmap();
      //changeSceneLabels(0);
    }

    private function changeSceneLabels(index:int):void {
      if (index == currentScene) {
        return;
      }

      var lastSceneList:Array = labelBitmap.getLabelsByScene(currentScene);
      if (lastSceneList) {
        labelVisible(lastSceneList, false);
      }

      var current:Array = labelBitmap.getLabelsByScene(index);
      labelVisible(current, true);

      currentScene = index;
      currentLabelList = current;
    }

    private function labelVisible(list:Array, isVisible:Boolean):void {
      const N:int = list.length;
      for (var i:int = 0; i < N; i++) {
        var target:DisplayObject = list[i];
        if (isVisible) {
          container.addChild(target);
          TweenLite.to(target, 1, {alpha:1});
        } else {
          TweenLite.to(target, 1, {alpha:0});
        }
      }
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
          var line:LineExtened = new LineExtened(list, 0, color, color, 5, 5);
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
       pointLight.z = 300;
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
            trace("[Effect4/initMeshes]", mesh.position.z);
          } else {
            var lastMesh:Mesh = meshList[j-1];
            var pos:Vector3D = lastMesh.position.clone();
            mesh.position = pos.add(new Vector3D(100, -150, 50));
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
        return new Vector3D(50*Math.random()-300, 50*Math.random() + 100, i*SCENE_DEPTH);
      } else {
        return new Vector3D(50*Math.random(), 50*Math.random() + 200, i*SCENE_DEPTH);
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
      TweenLite.to(goButton, 1, {y:0});
      currentScene = -1;
      changeSceneLabels(0);
      addChild(pointLight);
    }

    public function hide():void
    {
      TweenLite.to(goButton, 1, {y:-goButton.height});
      for (var i:int = 0; i < CLASS_N; i++) {
        var labelList:Array = labelBitmap.getLabelsByScene(i);
        labelVisible(labelList, false);
      }
      disableAllLines();
      removeChild(pointLight);
    }

    public function update(rateX:Number, rateY:Number):void
    {
      rotationY += (rateX - rotationY)*0.1;
      rotationX += (-rateY - rotationX)*0.1;

      if (currentScene < 0 || currentScene >= sceneList.length) {
        return;
      }
      if (!currentLabelList) {
        return;
      }

      var meshList:Vector.<Mesh> = sceneList[currentScene];
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        var label:DisplayObject = currentLabelList[i];
        var mesh:Mesh = meshList[i];

        var pos:Vector3D = view.project(mesh.scenePosition);
        label.x = pos.x;
        label.y = pos.y;
      }
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
