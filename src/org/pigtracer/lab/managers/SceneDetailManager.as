package org.pigtracer.lab.managers
{
  import org.pigtracer.lab.primitive.Effect4;
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
      this.enterframeGroup = enterFrameGroup;

      effect4 = new Effect4(view, container);
      effect4.position = CameraPos.S4;
      view.scene.addChild(effect4);

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

    private var effect4:Effect4;

    private function showBack():void {
      TweenLite.to(backButton, 1, {y:0});
    }
    private function hideBack():void {
      TweenLite.to(backButton, 1, {y:-backButton.height});
    }
    private function removeFromGroup(target:IUpdate):void {

      var index:int = 0;
      for each (var compare:IUpdate in enterframeGroup) {
        if (compare == target) {
          enterframeGroup.splice( index, 1 );
        }
        index++;
      }
    }
    private function moveCamera():void
    {
      tempTarget = CameraPos.MAIN_SCENE_LOOKAT.clone();
      var target:Vector3D = CameraPos.S1_LOOKAT;
      TweenLite.to(tempTarget, 1, {x:target.x, y:target.y, z:target.z, onUpdate:updateCamera});

      var camera:Camera3D = view.camera;
      TweenLite.to(camera, 1, {y:CameraPos.S1.y, z:CameraPos.S1.z, x:CameraPos.S1.x});
      //enterframeGroup.push(this);
    }
    private function moveCameraBack():void
    {
      tempTarget = CameraPos.S1_LOOKAT.clone();
      var target:Vector3D = CameraPos.MAIN_SCENE_LOOKAT;
      TweenLite.to(tempTarget, 1, {x:target.x, y:target.y, z:target.z, onUpdate:updateCamera});

      var camera:Camera3D = view.camera;
      TweenLite.to(camera, 1, {y:CameraPos.MAIN_SCENE.y, x:CameraPos.MAIN_SCENE.x, z:CameraPos.MAIN_SCENE.z});
    }

    private function updateCamera():void {
      var camera:Camera3D = view.camera;
      camera.lookAt(tempTarget);
    }

    private function sceneChangeHandler(event:SceneEvent):void
    {
      if (event.index < 3) {
        return;
      }
      enterframeGroup.push(effect4);
      moveCamera();
      effect4.show();
      closeFlag.hide();
      showBack();
    }

    private function backClickHandler(event:MouseEvent):void
    {

      effect4.hide();
      removeFromGroup(effect4);

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
