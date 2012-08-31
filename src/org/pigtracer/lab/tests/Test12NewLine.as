package org.pigtracer.lab.tests
{
  import com.bit101.components.HRangeSlider;
  import com.bit101.components.HUISlider;
  import flash.events.Event;
  import com.bit101.utils.MinimalConfigurator;
  import com.bit101.components.Component;
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
    private var config:MinimalConfigurator;
    private var lineExp:LIneExperiment;

    private function initUI():void
    {
      Component.initStage(stage);

      /*var xml:XML = <comps>
                      <HUISlider id="slider" event="change:onChange" />
                    </comps>;

      config = new MinimalConfigurator(this);
      config.parseXML(xml);*/

      new HRangeSlider(this, 0, 0, onChange);
    }

    public function onChange(event:Event):void {
      var comp:HRangeSlider = event.target as HRangeSlider;
      var low:Number = comp.lowValue/100;
      var high:Number = comp.highValue/100;
      changeLine(low, high);
    }

    private function changeLine(low:Number, high:Number):void{
      lineExp.startT = low;
      lineExp.endT = high;
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
      lineExp = new LIneExperiment(data);
      scene.addChild(lineExp);
    }

  }
}
