package org.pigtracer.lab.primitive
{
  import flash.geom.Vector3D;
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
    private var curve:CurveWithImage;


    override protected function initController():void
    {
      super.initController();
    }
    override protected function initObjects():void
    {
      super.initObjects();
      //view.backgroundColor = 0xFFFFFF;
      /*effect = new Effect4(view, this);
      scene.addChild(effect);
      camera.lookAt(new Vector3D());*/

      curve = new CurveWithImage(view, this);
      scene.addChild(curve);
    }

    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);
      curve.update();
      return;
      const rateX:Number = (mouseX-stage.stageWidth/2)*0.05;//+45/2;
      const rateY:Number = (mouseY-stage.stageHeight/2)*0.05;//+45/2;
      //effect.update(rateX, rateY);
      view.render();
    }

  }
}
