package org.pigtracer.lab {
  import away3d.cameras.Camera3D;
  import away3d.containers.Scene3D;
  import away3d.containers.View3D;
  import away3d.core.pick.PickingType;
  import away3d.textures.BitmapTexture;

  import org.pigtracer.lab.primitive.IUpdate;

  import flash.display.BitmapData;
  import flash.display.GradientType;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.geom.Matrix;

  /**
   * @author loki
   */
  [SWF(backgroundColor="#FFFFFF", frameRate="120", width="1024", height="1024")]
  public class ResumeBase extends Sprite {
    public function ResumeBase() {
      if (stage) {
        init();
      } else {
        addEventListener(Event.ADDED_TO_STAGE, init);
      }
    }

    protected function init(event:Event = null):void {
      removeEventListener(Event.ADDED_TO_STAGE, init);
      
      initEngine();
      initBG();
      initObjects();
      initListeners();
    }

    protected function initBG():void {
      var matrix:Matrix = new Matrix();
      var coverGradient:Shape = new Shape();
      matrix.createGradientBox(1024, 1024, Math.PI / 2, 1024 / 2, 1024 / 2);
      coverGradient.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x0], [1, 0], [0, 230], matrix);
      coverGradient.graphics.drawRect(0, 0, 1024, 1024);
      coverGradient.graphics.endFill();
      var bd:BitmapData = new BitmapData(1024, 1024);
      bd.draw(coverGradient);
      var texture:BitmapTexture = new BitmapTexture(bd);
      view.background = texture;
    }
    
    protected var camera:Camera3D;
    protected var scene:Scene3D;
    protected var view : View3D;
    protected var enterFrameGroup:Vector.<IUpdate>;

    protected function initListeners():void {
      addEventListener(Event.ENTER_FRAME, enterFrameHandler);
      stage.addEventListener(Event.RESIZE, onResize);
      onResize();
    }

    private function enterFrameHandler(event:Event):void {
      const N:int = enterFrameGroup.length;
      
      const rateX:Number = (mouseX-stage.stageWidth/2)*0.05;//+45/2;
      const rateY:Number = (mouseY-stage.stageHeight/2)*0.05;//+45/2;
      
      if (N > 0) {
        for (var i:int = 0; i < N; i++) {
          var element:IUpdate = enterFrameGroup[i];
          if (element) {
            element.update(rateX, rateY);
          }
        }
      }
      
      view.render();
    }

    private function onResize(event:Event = null):void {
      view.width = stage.stageWidth;
      view.height = stage.stageHeight;
    }

    protected function initObjects():void {
      enterFrameGroup = new Vector.<IUpdate>();
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
  }
}
