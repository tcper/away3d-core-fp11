package org.pigtracer.lab.primitive
{
  import away3d.containers.ObjectContainer3D;
  import away3d.containers.View3D;

  import org.pigtracer.lab.data.Effect1Bitmap;

  import flash.display.DisplayObjectContainer;
  import flash.display.Sprite;
  import flash.geom.Vector3D;

  /**
   * @author loki
   */
  public class CurveWithImage extends ObjectContainer3D
  {
    [Embed(source="../line.obj", mimeType="application/octet-stream")]
    private var embeddedClass : Class;


    public function CurveWithImage(view:View3D, container:DisplayObjectContainer)
    {
      this.container = container;
      this.view = view;
      super();
      init();
    }

    private var container:DisplayObjectContainer;
    private var resourceFactory:Effect1Bitmap;
    private var view:View3D;
    private var line:LineExtened;
    private var content:Sprite;

    private function init():void
    {
      initCurves();
      initPlane();
    }

    private function initPlane():void
    {
      resourceFactory = new Effect1Bitmap();
      content = resourceFactory.getImage();
      container.addChild(content);
    }

    private function initCurves():void
    {
      var lineParser:LineParser = new LineParser();
      var lineList:Vector.<Vector3D> = lineParser.parseGetData(new embeddedClass());
      var head:Vector3D = lineList[0].clone();
      lineList.push(head);
      line = new LineExtened(lineList, 1, 0x1B3187, 0xE54200, 5, 5);
      //line.scale(100);
      addChild(line);
    }

    public function update():void {
      var pos:Vector3D = view.project(line.scenePosition);
      content.x = pos.x;
      content.y = pos.y;
    }
  }
}
