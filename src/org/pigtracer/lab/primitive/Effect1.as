package org.pigtracer.lab.primitive {
  import org.pigtracer.lab.interfaces.IEffect;
  import com.greensock.TweenLite;
  import away3d.paths.IPath;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import flash.geom.Vector3D;
  import away3d.containers.ObjectContainer3D;

  /**
   * @author loki
   */
  public class Effect1 extends ObjectContainer3D implements IUpdate, IEffect{
    public function Effect1() {
      super();
      init();
    }

    private var lineList:Array = [];
    private var tweenList:Array = [];

    public function show():void {
      const N:int = lineList.length;
      for (var i:int = 0; i < N; i++) {
        var line:LineExtened = lineList[i];
        var tweenLite:TweenLite = tweenList[i];
        if (!tweenLite) {
          tweenList.push(TweenLite.to(line, 0.5, {t:1, delay:i/10}));
        } else {
          tweenLite.play();
        }
      }
    }

    public function hide():void {
      const N:int = lineList.length;
      if (N <= 0) {
        return;
      }

      for (var i:int = 0; i < N; i++) {
        var line:LineExtened = lineList[i];
        tweenList.push(TweenLite.to(line, 0.5, {t:0, delay:i/10}));
      }
    }


    private function init():void {
      for (var i:int = 0; i < 20; i++) {
        var path:IPath = generateQuadCurve();

        var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
        for (var j:int = 0; j < 100; j++) {
          var t1:Number = j / 100;
          var segment:IPathSegment = path.segments[0];
          newList.push(segment.getPointOnSegment(t1));
        }

        var color:uint = getColor();

        var line:LineExtened = new LineExtened(newList, 0, color, color, 5, 5);

        lineList.push(line);
        addChild(line);
      }
    }

    private function getColor():uint {
      var judge:Number = Math.random();
      if (judge < 0.3) {
        return ColorConst.MAIN_PART_A;
      } else if (judge > 0.3 && judge < 0.6) {
        return ColorConst.MAIN_PART_B;
      } else {
        return ColorConst.MAIN_PART_C;
      }
    }
    private function generateQuadCurve():QuadraticPath {
      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(genRan(50, 0),genRan(50, 0),genRan(50, 0)),
                                                  new Vector3D(genRan(200, 0),genRan(200,0),genRan(200, 0)),
                                                  //new Vector3D(genRan(1000, 0),genRan(1000, 800, 2000),genRan(300, 0))];
                                                  new Vector3D(genRan(500, 0),genRan(500, 0),genRan(500, 0))];
      var path:QuadraticPath = new QuadraticPath(list);
      return path;
    }

    private function genRan(scale:int, base:int, max:int = int.MAX_VALUE):Number {
      var temp:Number;
      if (base == 0) {
        temp = 2*scale*Math.random() - scale;
        return Math.min(max, temp);
      } else {
        temp = max - base;
        return max - Math.random()*temp;
      }
    }

    public function update(rateX:Number, rateY:Number):void {
      this.rotationX += 10;
    }
  }
}
