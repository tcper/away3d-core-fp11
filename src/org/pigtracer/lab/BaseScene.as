package org.pigtracer.lab
{
  import flash.geom.Matrix3D;
  import flash.geom.Vector3D;
  import flash.ui.Keyboard;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.events.Event;
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.lights.PointLight;
  import away3d.controllers.HoverController;
  import away3d.core.pick.PickingType;
  import away3d.cameras.Camera3D;
  import away3d.containers.Scene3D;
  import away3d.containers.View3D;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.Sprite;

  /**
   * @author loki
   */
   
  [SWF(backgroundColor="#FFFFFF", frameRate="120", width="1024", height="768")]
  public class BaseScene extends Sprite {
    public function BaseScene() {
      init();
    }
    //==========================================================================
    //  Variables
    //==========================================================================
    protected var lightPicker:StaticLightPicker;
    protected var pointLight:PointLight;
    protected var cameraController:HoverController;
    protected var camera:Camera3D;
    protected var scene:Scene3D;
    protected var view : View3D;

    private var move:Boolean = false;
    private var lastPanAngle:Number;
    private var lastTiltAngle:Number;
    private var lastMouseX:Number;
    private var lastMouseY:Number;
    private var tiltSpeed:Number = 4;
    private var panSpeed:Number = 4;
    private var distanceSpeed:Number = 4;
    private var tiltIncrement:Number = 0;
    protected var panIncrement:Number = 0;
    private var distanceIncrement:Number = 0;
    //==========================================================================
    //  Private methods
    //==========================================================================
    protected function init():void {
      initEngine();
      initController();
      initLights();
      initMaterials();
      initObjects();
      initListeners();
    }

    protected function initController():void {
      // origin cameraController = new HoverController(camera, null, 180, 20, 1000, 5);
      cameraController = new HoverController(camera, null, 180, 20, 800, 5);
      //cameraController = new HoverController(camera, null, 30, 180, 1000, 5);
      var m:Matrix3D = new Matrix3D(new <Number>[-0.9933727383613586,-8.684340002673707e-8,0.1149372085928917,0,-0.019810523837804794,0.9850342273712158,-0.17121653258800507,0,-0.1132170706987381,-0.17235881090164185,-0.9785061478614807,0,114.4997787475586,174.31149291992188,989.5927124023438,1]);
      camera.transform = m;
    }

    protected function initEngine():void {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;

      view = new View3D();
      view.forceMouseMove = true;
      scene = view.scene;
      camera = view.camera;

      view.mousePicker = PickingType.RAYCAST_BEST_HIT;

      addChild(view);
    }
    private function onResize(event:Event = null):void
    {
      view.width = stage.stageWidth;
      view.height = stage.stageHeight;
    }
    
    protected function initLights():void {
      pointLight = new PointLight();
      scene.addChild(pointLight);
      lightPicker = new StaticLightPicker([pointLight]);
    }

    protected function initMaterials():void {

    }

    protected function initObjects():void {
    }

    protected function initListeners():void {
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
      view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      stage.addEventListener(Event.RESIZE, onResize);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      onResize();
    }

    //==========================================================================
    //  Event handlers
    //==========================================================================

    protected function onKeyUp(event:KeyboardEvent):void {
      switch (event.keyCode) {
        case Keyboard.UP:
        case Keyboard.W:
        case Keyboard.DOWN:
        case Keyboard.S:
          tiltIncrement = 0;
          break;
        case Keyboard.LEFT:
        case Keyboard.A:
        case Keyboard.RIGHT:
        case Keyboard.D:
          panIncrement = 0;
          break;
        case Keyboard.Z:
        case Keyboard.X:
          distanceIncrement = 0;
          break;
      }
    }

    protected function onKeyDown(event:KeyboardEvent):void {
      switch (event.keyCode) {
        case Keyboard.UP:
        case Keyboard.W:
          tiltIncrement = tiltSpeed;
          break;
        case Keyboard.DOWN:
        case Keyboard.S:
          tiltIncrement = -tiltSpeed;
          break;
        case Keyboard.LEFT:
        case Keyboard.A:
          panIncrement = panSpeed;
          break;
        case Keyboard.RIGHT:
        case Keyboard.D:
          panIncrement = -panSpeed;
          break;
        case Keyboard.Z:
          distanceIncrement = distanceSpeed;
          break;
        case Keyboard.X:
          distanceIncrement = -distanceSpeed;
          break;
      }
    }

    protected function onMouseUp(event:MouseEvent):void {
      move = false;
      stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    private function onMouseDown(event:MouseEvent):void {
      move = true;
      if (cameraController) {
        lastPanAngle = cameraController.panAngle;
        lastTiltAngle = cameraController.tiltAngle;
      }
      lastMouseX = stage.mouseX;
      lastMouseY = stage.mouseY;
      stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    protected function onStageMouseLeave(event:Event):void {
      move = false;
      stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    protected function enterFrameHandler(event:Event):void {
            // Update camera.

      if (cameraController) {
        if (move) {
          cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
          cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;

        }
        cameraController.panAngle += panIncrement;
        cameraController.tiltAngle += tiltIncrement;
        cameraController.distance += distanceIncrement;

//        trace(cameraController.panAngle, cameraController.tiltAngle, cameraController.distance);
//        trace(camera.transform.rawData);
      }

      // Move light with camera.
      //pointLight.position = camera.position;

      // Render 3D.
      view.render();
    }

  }
}
