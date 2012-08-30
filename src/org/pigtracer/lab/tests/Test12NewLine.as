package org.pigtracer.lab.tests
{
  import org.pigtracer.lab.experiment.LIneExperiment;
  import org.pigtracer.lab.experiment.LineMeta;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import flash.geom.Vector3D;
  import org.pigtracer.lab.tests.BaseScene;

  /**
   * @author loki
   */
  public class Test12NewLine extends BaseScene
  {
    public function Test12NewLine()
    {
      super();
      initUI();
    }

    private function initUI():void
    {
    }

    override protected function initObjects():void
    {
      view.backgroundColor = 0xFFFFFF;
      super.initObjects();

      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0,0,0),
                                                  new Vector3D(1000, 0, 0),
                                                  new Vector3D(0, 500, 0)];
      var cubicPath:QuadraticPath = new QuadraticPath(list);

      var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
      for (var i:int = 0; i < 500; i++) {
        var t1:Number = i/500;
        var segment:IPathSegment = cubicPath.segments[0];
        newList.push(segment.getPointOnSegment(t1));
      }

      var data:LineMeta = new LineMeta(newList);
      var lineExp:LIneExperiment = new LIneExperiment(data);
      scene.addChild(lineExp);
    }

  }
}
