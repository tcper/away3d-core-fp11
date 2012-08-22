package org.pigtracer.lab.primitive
{
  import org.pigtracer.lab.events.SceneEvent;
  import flash.events.MouseEvent;
  import org.pigtracer.lab.data.Effect3DetailBitmap;
  import flash.display.Sprite;
  import flash.display.DisplayObjectContainer;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import away3d.events.MouseEvent3D;
  import away3d.filters.BloomFilter3D;
  import com.greensock.TweenLite;
  import org.pigtracer.lab.managers.LightsManager;
  import away3d.entities.Mesh;
  import flash.geom.Vector3D;
  import away3d.primitives.CubeGeometry;
  import away3d.materials.ColorMaterial;
  import away3d.containers.View3D;
  import org.pigtracer.lab.interfaces.IEffect;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Effect3 extends ObjectContainer3D implements IEffect, IUpdate{
    public function Effect3(view:View3D, container:DisplayObjectContainer) {
      this.container = container;
      this.view = view;
      meshContainer = new ObjectContainer3D();
      super();
      addChild(meshContainer);
      init();
    }

    private const N:int = 10;
    private var container:DisplayObjectContainer;
    private var meshList:Vector.<MeshWithData> = new Vector.<MeshWithData>();
    private var filters:Array;
    private var timer:Timer = new Timer(4000, 1);

    private var view:View3D;
    private var detailButton:Sprite;

    private var meshContainer:ObjectContainer3D;

    //----------------------------------
    //  listener
    //----------------------------------
    private var _listener:MainCubeListener;
    public function get listener():MainCubeListener {
      return _listener;
    }
    public function set listener(value:MainCubeListener):void {
      _listener = value;
      _listener.sceneDispatcher.addEventListener(SceneEvent.CHANGE_SCENE, sceneChangeHandler);
    }

    private function sceneChangeHandler(event:SceneEvent):void
    {
      if (event.index != 2) {
        return;
      }
      TweenLite.to(detailButton, 1, {y:container.stage.stageHeight - detailButton.height});
    }

    private function init():void
    {
      initCubes();
      initRefCube();
      initFilter();
      initButtons();
      visible = false;
    }

    private function initRefCube():void
    {
      var geom:CubeGeometry = new CubeGeometry(30, 30, 30, 3, 3, 3);
      for (var i:int = 0; i < N; i++) {
        var mat:ColorMaterial = new ColorMaterial(0xFFFFFF*Math.random());
        mat.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;
        var mesh:Mesh = new Mesh(geom, mat);
        mesh.position = getRan3(i);
        addChild(mesh);
      }
    }

    private function initButtons():void
    {
      var data:Effect3DetailBitmap = new Effect3DetailBitmap();
      detailButton = data.detailButton;
      detailButton.x = container.stage.stageWidth - detailButton.width;
      detailButton.y = container.stage.stageHeight;
      container.addChild(detailButton);

      detailButton.addEventListener(MouseEvent.CLICK, detailClickHandler);
      detailButton.addEventListener(MouseEvent.MOUSE_OVER, detailOverHandler);
      detailButton.addEventListener(MouseEvent.MOUSE_OUT, detailOutHandler);
    }

    private function detailOutHandler(event:MouseEvent):void
    {
      view.filters3d = [];
    }

    private function detailOverHandler(event:MouseEvent):void
    {
      view.filters3d = filters;
    }

    private function detailClickHandler(event:MouseEvent):void
    {
      if (!listener) {
        return;
      }
      TweenLite.to(detailButton, 1, {y:container.stage.stageHeight});
      listener.sceneDispatcher.dispatchEvent(new SceneEvent(SceneEvent.CHANGE_SCENE, 3));
    }

    private function initFilter():void
    {
      filters = [new BloomFilter3D()];
    }

    private function initCubes():void
    {
      var geom:CubeGeometry = new CubeGeometry(50, 50, 50, 3, 3, 3);
      for (var i:int = 0; i < N; i++) {
        var mat:ColorMaterial = new ColorMaterial(0xFFFFFF*Math.random());
        mat.alpha = 0;
        mat.lightPicker = LightsManager.getInstance().mainMessageLights.lightPicker;
        var origin:Vector3D = genRan2();
        var target:Vector3D = genRan1();
        var data:MeshData = new MeshData(i, origin, target, Math.random()*3);
        var mesh:MeshWithData = new MeshWithData(geom, mat);

        mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, mouseDownHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OVER, mouseOverHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OUT, mouseOutHandler);

        mesh.data = data;
        meshContainer.addChild(mesh);
        meshList.push(mesh);
      }
    }

    private function mouseOutHandler(event:MouseEvent3D):void
    {
    }

    private function mouseOverHandler(event:MouseEvent3D):void
    {
    }

    private function mouseDownHandler(event:MouseEvent3D):void
    {
    }

    private function genRan1() : Vector3D {
      return new Vector3D(200*Math.random() - 100, Math.random()*200-100, 200*Math.random() - 100);
    }
    private function genRan2() : Vector3D {
      return new Vector3D(100*Math.random() - 50, 100*Math.random() - 50, 100*Math.random() - 50);
    }
    private function getRan3(i:int):Vector3D {
      return new Vector3D(400*Math.random() - 200, i* 100 + 160, 400*Math.random() - 200);
    }

    public function show():void
    {
      visible = true;
      for (var i:int = 0; i < N; i++) {
        var mesh:MeshWithData = meshList[i];
        var data:MeshData = mesh.data as MeshData;
        TweenLite.to(mesh.material, 0.5, {alpha:1});
        TweenLite.to(mesh, 0.5, {x:data.target.x, y:data.target.y, z:data.target.z, delay:data.delay + 0.8});
      }

    }

    public function hide():void
    {
      for (var i:int = 0; i < N; i++) {
        var mesh:MeshWithData = meshList[i];
        var data:MeshData = mesh.data as MeshData;
        TweenLite.to(mesh.material, 0.5, {alpha:0, delay:data.delay + 0.8});
        TweenLite.to(mesh, 0.5, {x:data.origin.x, y:data.origin.y, z:data.origin.z, delay:data.delay + 0.8});
      }
      TweenLite.to(detailButton, 1, {y:container.stage.stageHeight});

      timer.addEventListener(TimerEvent.TIMER_COMPLETE, hideCompleteHandler);
      timer.reset();
      timer.start();
    }

    private function hideCompleteHandler(event:TimerEvent):void
    {
      this.visible = false;
    }

    public function update(rateX:Number, rateY:Number):void
    {
      meshContainer.rotationX += 2;
    }
  }
}
import flash.geom.Vector3D;

class MeshData {
  public var index:int;
  public var origin:Vector3D;
  public var target:Vector3D;
  public var delay:Number;
  /**
   * Construct a <code>MeshData</code>.
   */
  public function MeshData(i:int, o:Vector3D, t:Vector3D, d:Number) {
    index = i;
    origin = o;
    target = t;
    delay = d;
  }
}