package org.pigtracer.lab.primitive
{
  import com.greensock.plugins.ShortRotationPlugin;
  import com.greensock.plugins.TransformAroundCenterPlugin;
  import com.greensock.plugins.TransformAroundPointPlugin;
  import com.greensock.plugins.TweenPlugin;
  import com.greensock.TweenMax;
  import com.greensock.easing.Quint;
  import flash.display.Bitmap;
  import org.pigtracer.lab.events.CloseEvent;
  import com.greensock.TweenLite;
  import flash.events.MouseEvent;
  import flash.display.Sprite;

  /**
   * @author loki
   */
  public class CloseFlag extends Sprite
  {
    [Embed(source="../embeds/close.png")]
    private var embeddedClass : Class;
    public function CloseFlag()
    {
      TweenPlugin.activate([TransformAroundPointPlugin, TransformAroundCenterPlugin, ShortRotationPlugin]);

      content = new embeddedClass();
      addChild(content);

      var clickArea:Sprite = new Sprite();
      clickArea.graphics.beginFill(0x0, 0);
      clickArea.graphics.drawRect(0, 0, content.width, content.height);
      clickArea.graphics.endFill();
      clickArea.useHandCursor = true;
      clickArea.buttonMode = true;
      addChild(clickArea);

      clickArea.addEventListener(MouseEvent.MOUSE_OVER, onOver);
      clickArea.addEventListener(MouseEvent.MOUSE_OUT, onOut);
      clickArea.addEventListener(MouseEvent.CLICK, onClick);
    }

    private var content:Bitmap;

    public function show():void {
      TweenMax.to(this, 0.5, {y:20, transformAroundCenter:{scaleX:1, scaleY:1}, alpha:1});
    }
    public function hide():void {
      TweenLite.to(this, 0.5, {transformAroundCenter:{scaleX:1, scaleY:1}, y:-100});
    }

    private function onClick(event:MouseEvent):void
    {
      dispatchEvent(new CloseEvent(CloseEvent.CLOSE_SCENE));
      TweenLite.to(content, 0.5, {transformAroundCenter:{scaleX:1, scaleY:1}, alpha:1, onComplete:closeCompleteHandler});
    }

    private function closeCompleteHandler():void {
      hide();
    }

    private function onOut(event:MouseEvent):void
    {
      TweenLite.to(content, 0.5, {transformAroundCenter:{scaleX:1, scaleY:1}, ease:Quint.easeOut});
    }

    private function onOver(event:MouseEvent):void
    {
      TweenLite.to(content, 0.5, {transformAroundCenter:{scaleX:1.1, scaleY:1.1}, ease:Quint.easeOut});
    }
  }
}
