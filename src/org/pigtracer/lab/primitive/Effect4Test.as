package org.pigtracer.lab.primitive
{
  import flash.events.Event;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class Effect4Test extends BaseScene
  {
    public function Effect4Test()
    {
      super();
    }
    private var effect:Effect4;
    override protected function initObjects():void
    {
      super.initObjects();
      view.backgroundColor = 0xFFFFFF;
      effect = new Effect4(scene);
      scene.addChild(effect);
    }

    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);
      const rateX:Number = (mouseX-stage.stageWidth/2)*0.05;//+45/2;
      const rateY:Number = (mouseY-stage.stageHeight/2)*0.05;//+45/2;
      //effect.update(rateX, rateY);
    }

  }
}
