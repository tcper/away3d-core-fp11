package org.pigtracer.lab.managers
{
  import flash.display.DisplayObject;
  import com.greensock.TweenLite;
  import org.pigtracer.lab.data.SubtitleBitmaps;
  import org.pigtracer.lab.events.SceneEvent;
  import org.pigtracer.lab.events.CloseEvent;
  import flash.events.EventDispatcher;
  import flash.display.DisplayObjectContainer;
  /**
   * @author loki
   */
  public class SubtitleManager
  {
    /**
     * Construct a <code>SubtitleManager</code>.
     */
    public function SubtitleManager(container:DisplayObjectContainer, sceneDispatcher:EventDispatcher, closeDispatcher:EventDispatcher) {
      this.container = container;

      init();

      closeDispatcher.addEventListener(CloseEvent.CLOSE_SCENE, closeHandler);
      sceneDispatcher.addEventListener(SceneEvent.CHANGE_SCENE, sceneChangeHandler);
    }



    private var container:DisplayObjectContainer;
    private var data:SubtitleBitmaps;
    private var lastSub:DisplayObject;

    private function init():void
    {
      initSubtitles();
    }

    private function initSubtitles():void
    {
      data = new SubtitleBitmaps();
      showSubs(0);
    }

    private function showSubs(index:int):void {
      var sub:DisplayObject = data.SUB[index];
      if (sub == lastSub) {
        return;
      }

      if (lastSub) {
        TweenLite.to(lastSub, 0.5, {y:-50, alpha:0});
      }


      if (!container.contains(sub)) {
        sub.alpha = 0;
        sub.y = -50;
        container.addChild(sub);
      }
      TweenLite.to(sub, 0.5, {y:0, alpha:1});
      lastSub = sub;
    }

    private function sceneChangeHandler(event:SceneEvent):void
    {
      var index:int = event.index;
      if (index >= 3) {
        TweenLite.to(lastSub, 0.5, {alpha:0});
        return;
      }
      showSubs(index+1);
    }
    private function closeHandler(event:CloseEvent):void
    {
      showSubs(0);
    }

  }
}
