package org.pigtracer.lab.tests {
  import away3d.materials.methods.HardShadowMapMethod;
  import com.bit101.components.PushButton;
  import flash.events.Event;
  import org.pigtracer.lab.MessageScene;

  /**
   * @author loki
   */
  public class TestScene1 extends BaseScene {
    public function TestScene1() {
      super();
      
      initUI();
    }

    private function initUI() : void {
      var btn:PushButton = new PushButton(this, 0, 0, "push", handler);
      var btn2:PushButton = new PushButton(this, 0, 20, "push2", handler2);
    }
    private function handler2(event:Event):void {
      m.start2();
    }

    private function handler(event:Event) : void {
      m.start();
    }
    private var m:MessageScene;
    override protected function initObjects() : void {
      super.initObjects();
      pointLight.z = 300;
      pointLight.y = 300;
      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      //pointLight.y = 100;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 1000;
      pointLight.fallOff = 1000;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;
      
      m = new MessageScene();
      m.bgMaterial.lightPicker = lightPicker;
      m.bgMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      m.bgMaterial.specular = .25;
      m.bgMaterial.gloss = 20;
      m.colorMaterial.lightPicker = lightPicker;
      scene.addChild(m);
      
      m.rotationX = 90;
    }

  }
}
