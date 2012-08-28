package org.pigtracer.lab {
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import com.bit101.components.PushButton;
  import com.greensock.TweenLite;
  import com.greensock.easing.Quint;
  import flash.events.Event;
  import flash.geom.Vector3D;
  import org.pigtracer.lab.primitive.Line;
  import org.pigtracer.lab.primitive.LineExtened;
  import org.pigtracer.lab.tests.BaseScene;

  /**
   * @author loki
   */
  public class AnimateLine extends BaseScene {
    public function AnimateLine() {
      super();

      initUI();
    }

    private function initUI():void
    {
      new PushButton(this, 0, 0, "animation", clickHandler);
    }

    private function clickHandler(event:Event):void
    {
      if (line.t > 0) {
        TweenLite.to(line, 1, {t:0, ease:Quint.easeIn});
      } else {
        TweenLite.to(line, 1, {t:1, ease:Quint.easeIn});
      }
    }
    private var line:LineExtened;

    override protected function initObjects():void {
      super.initObjects();
      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0,0,0),
                                                  new Vector3D(1000, 0, 0),
                                                  new Vector3D(0, 500, 0)];
      var cubicPath:QuadraticPath = new QuadraticPath(list);

      var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
      for (var i:int = 0; i < 100; i++) {
        var t1:Number = i/100;
        var segment:IPathSegment = cubicPath.segments[0];
        newList.push(segment.getPointOnSegment(t1));
      }

      line = new LineExtened(newList, 0, 0xFFFFFF, 0x00FF00, 10, 1);
      scene.addChild(line);
      TweenLite.to(line, 1, {t:1, ease:Quint.easeIn, onComplete:lineComplete});
    }

    private function lineComplete():void
    {
      TweenLite.to(line, 1, {t:0, ease:Quint.easeIn});
    }

  }
}
