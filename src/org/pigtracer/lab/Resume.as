package org.pigtracer.lab
{
  import away3d.entities.Entity;
  import org.pigtracer.lab.primitive.Effect3;
  import org.pigtracer.lab.primitive.Effect2;
  import org.pigtracer.lab.primitive.Effect1;
  import away3d.containers.ObjectContainer3D;

  import org.pigtracer.lab.primitive.CameraPos;
  import org.pigtracer.lab.primitive.CloseFlag;
  import org.pigtracer.lab.primitive.MainCubeListener;
  import org.pigtracer.lab.primitive.MainMessage;
  import org.pigtracer.lab.primitive.FlagManager;

  /**
   * @author loki
   */
  [SWF(backgroundColor="#FFFFFF", frameRate="120", width="1600", height="1024")]
  public class Resume extends ResumeBase {
    public function Resume() {
      super();
    }



    override protected function initObjects():void {
      super.initObjects();
      //TweenPlugin.activate([MotionBlurPlugin]);


      var m:MainMessage = new MainMessage();
      scene.addChild(m);
      m.init();

      camera.position = CameraPos.MAIN_SCENE;
      camera.lookAt(CameraPos.MAIN_SCENE_LOOKAT);
      enterFrameGroup.push(m);

      var flags:FlagManager = new FlagManager(this, view, m.meshList);
      enterFrameGroup.push(flags);

      var effectContainer:ObjectContainer3D = new ObjectContainer3D();
      scene.addChild(effectContainer);


      var closeFlag:CloseFlag = new CloseFlag();
      closeFlag.x = stage.stageWidth - 200;
      closeFlag.y = -100;
      addChild(closeFlag);

      var effectList:Array = [new Effect1(), new Effect2(m, this, view), new Effect3(view)];
      const N:int = effectList.length;
      for (var i:int = 0; i < N; i++) {
        var effect:ObjectContainer3D = effectList[i];
        m.addChild(effect);
      }

      var listener:MainCubeListener = new MainCubeListener(m.meshList, m, flags, closeFlag, enterFrameGroup, effectList);

    }
  }
}
