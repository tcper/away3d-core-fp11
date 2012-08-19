package org.pigtracer.lab {
  import away3d.containers.ObjectContainer3D;
  import org.pigtracer.lab.primitive.MainCubeListener;
  import org.pigtracer.lab.primitive.MainSceneFlags;
  import org.pigtracer.lab.primitive.CameraPos;
  import org.pigtracer.lab.primitive.MainMessage;

  /**
   * @author loki
   */
  public class Resume extends ResumeBase {
    public function Resume() {
      super();
    }
    
    

    override protected function initObjects():void {
      super.initObjects();
      
      var m:MainMessage = new MainMessage();
      scene.addChild(m);
      m.init();
      
      camera.position = CameraPos.MAIN_SCENE;
      camera.lookAt(CameraPos.MAIN_SCENE_LOOKAT);
      enterFrameGroup.push(m);
      
      var flags:MainSceneFlags = new MainSceneFlags(this, view, m.meshList);
      enterFrameGroup.push(flags);
      
      var effectContainer:ObjectContainer3D = new ObjectContainer3D();
      scene.addChild(effectContainer);
      var listener:MainCubeListener = new MainCubeListener(m.meshList, m);
      
    }
  }
}
