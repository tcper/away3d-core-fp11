package org.pigtracer.lab {
  import com.greensock.easing.Quint;
  import com.greensock.TweenLite;
  import org.pigtracer.lab.primitive.LineExtened;
  import org.pigtracer.lab.primitive.Line;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import flash.geom.Vector3D;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class AnimateLine extends BaseScene {
    public function AnimateLine() {
      super();
    }

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
      
      var line:LineExtened = new LineExtened(newList, 0, 0xFFFFFF, 0x00FF00, 10, 1);
      scene.addChild(line);
      TweenLite.to(line, 1, {t:1,ease:Quint.easeIn});
    }

  }
}
