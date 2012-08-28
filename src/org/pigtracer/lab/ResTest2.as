package org.pigtracer.lab
{
  import org.pigtracer.lab.test_scene.ResTest2Scene;
  import away3d.entities.Mesh;
  import away3d.primitives.CubeGeometry;
  import away3d.materials.ColorMaterial;
  import away3d.debug.AwayStats;

  /**
   * @author loki
   */
  public class ResTest2 extends ResumeBase
  {
    public function ResTest2()
    {
      super();
      initDebug();
    }

    private function initDebug():void
    {
      addChild(new AwayStats());
    }

    override protected function initObjects():void
    {
      super.initObjects();
      var s1:ResTest2Scene = new  ResTest2Scene();
      scene.addChild(s1);
      enterFrameGroup.push(s1);
    }

  }
}
