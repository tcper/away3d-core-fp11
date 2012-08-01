package org.pigtracer.lab
{
  import away3d.primitives.data.Segment;
  import away3d.paths.QuadraticPath;
  import away3d.core.base.data.Vertex;
  import org.pigtracer.lab.primitive.Path;
  import away3d.paths.CubicPath;
  import flash.events.Event;
  import com.bit101.components.PushButton;
  import com.bit101.utils.MinimalConfigurator;
  import com.bit101.components.Component;
  import flash.geom.Vector3D;
  import org.pigtracer.lab.primitive.Line;
  import away3d.primitives.WireframeTetrahedron;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class Test3 extends BaseScene
  {
    public function Test3()
    {
      super();

      initUI();
    }

    private var config:MinimalConfigurator;
    private var line:Line;

    private function initUI():void
    {
      Component.initStage(stage);

      var xml:XML = <comps>
                      <Label id="myLabel" x="10" y="10" text="waiting..."/>
                      <PushButton id="test1" x="10" y="40" label="click me" event="click:onClick"/>
                    </comps>;

      config = new MinimalConfigurator(this);
      config.parseXML(xml);
    }

    public function onClick(event:Event):void
    {
      var btn:PushButton = config.getCompById("foo") as PushButton;


      line.changeEnd();
    }

    override protected function initObjects():void
    {
      super.initObjects();

      var t:WireframeTetrahedron = new WireframeTetrahedron(20, 32);
      scene.addChild(t);

      line = new Line(new Vector3D(), new Vector3D(100, 100, 100));
      scene.addChild(line);

      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0,0,0),
                                                  new Vector3D(500, 0, 0),
                                                  new Vector3D(0, 500, 0)];

      var cubicPath:QuadraticPath = new QuadraticPath(list);



      var l1:Vector.<Vertex> = new Vector.<Vertex>();
      for (var i:int = 0; i < 100; i++) {
        var v:Vector3D = cubicPath.getPointOnCurve(i/100);
        l1.push(new Vertex(v.x, v.y, v.z));
      }
      var path:Path = new Path(l1);
      scene.addChild(path);
    }
  }
}
