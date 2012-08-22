package org.pigtracer.lab.managers
{
  import org.pigtracer.lab.primitive.CameraPos;
  import flash.geom.Vector3D;
  import flash.display.DisplayObjectContainer;
  import flash.events.MouseEvent;
  import flash.display.Sprite;
  import org.pigtracer.lab.data.Scene3Bitmap;
  import org.pigtracer.lab.primitive.CloseFlag;
  import com.greensock.TweenLite;
  import away3d.cameras.Camera3D;
  import org.pigtracer.lab.events.SceneEvent;
  import org.pigtracer.lab.primitive.IUpdate;
  import flash.events.EventDispatcher;
  import away3d.containers.View3D;
  /**
   * @author loki
   */
  public class SceneDetailManager implements IUpdate
  {
    /**
     * Construct a <code>SceneDetailManager</code>.
     */
    public function SceneDetailManager(view:View3D,
                                       sceneDispatcher:EventDispatcher,
                                       enterFrameGroup:Vector.<IUpdate>,
                                       closeFlag:CloseFlag,
                                       container:DisplayObjectContainer) {

      this.view = view;
      this.container = container;
      this.closeFlag = closeFlag;
      this.enterframeGroup = enterframeGroup;

      this.sceneDispatcher = sceneDispatcher;
      sceneDispatcher.addEventListener(SceneEvent.CHANGE_SCENE, sceneChangeHandler);

      var backBitmap:Scene3Bitmap = new Scene3Bitmap();
      backButton = backBitmap.backButton;
      backButton.y = -backButton.height;
      container.addChild(backButton);
      backButton.addEventListener(MouseEvent.CLICK, backClickHandler);
    }

    private var backButton:Sprite;
    private var view:View3D;
    private var closeFlag:CloseFlag;
    private var container:DisplayObjectContainer;
    private var enterframeGroup:Vector.<IUpdate>;
    private var tempTarget:Vector3D;
    private var sceneDispatcher:EventDispatcher;

    private function showBack():void {
      TweenLite.to(backButton, 1, {y:0});
    }
    private function hideBack():void {
      TweenLite.to(backButton, 1, {y:-backButton.height});
    }
    private function removeFromGroup(target:IUpdate):void {
      const N:int = enterframeGroup.length;
      for (var i:int = 0; i < N; i++) {
        var compare:IUpdate = enterframeGroup[i];
        if (compare == target) {
          enterframeGroup.splice( i, 1 );
        }
      }
    }
    private function moveCamera():void
    {
      tempTarget = CameraPos.MAIN_SCENE_LOOKAT.clone();
      var target:Vector3D = CameraPos.S1_LOOKAT;
      TweenLite.to(tempTarget, 1, {x:target.x, y:target.y, z:target.z, onUpdate:updateCamera});
      //enterframeGroup.push(this);
    }
    private function moveCameraBack():void
    {
      tempTarget = CameraPos.S1_LOOKAT.clone();
      var target:Vector3D = CameraPos.MAIN_SCENE_LOOKAT;
      TweenLite.to(tempTarget, 1, {x:target.x, y:target.y, z:target.z, onUpdate:updateCamera});
    }

    private function updateCamera():void {
      var camera:Camera3D = view.camera;
      camera.lookAt(tempTarget);
    }

    private function sceneChangeHandler(event:SceneEvent):void
    {
      trace(event.index);
      if (event.index < 3) {
        return;
      }

      moveCamera();

      closeFlag.hide();
      showBack();
    }

    private function backClickHandler(event:MouseEvent):void
    {

      moveCameraBack();

      closeFlag.show();
      hideBack();
      sceneDispatcher.dispatchEvent(new SceneEvent(SceneEvent.CHANGE_SCENE, 2));
    }

    public function update(rateX:Number, rateY:Number):void
    {
    }

  }
}
