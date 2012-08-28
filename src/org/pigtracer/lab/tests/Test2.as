package org.pigtracer.lab.tests
{
  import away3d.animators.PathAnimator;
  import away3d.core.base.Geometry;
  import away3d.entities.Mesh;
  import away3d.events.AssetEvent;
  import away3d.library.assets.AssetType;
  import away3d.loaders.AssetLoader;
  import away3d.loaders.parsers.Parsers;
  import away3d.materials.ColorMaterial;
  import away3d.paths.CubicPath;
  import away3d.paths.CubicPathSegment;
  import away3d.paths.IPathSegment;
  import away3d.paths.QuadraticPath;
  import away3d.primitives.LineSegment;
  import away3d.primitives.WireframeSphere;
  import away3d.primitives.data.Segment;
  import flash.events.Event;
  import flash.geom.Vector3D;
  import flash.net.URLRequest;
  import org.pigtracer.lab.primitive.Line;
  import org.pigtracer.lab.primitive.LineParser;
  import org.pigtracer.lab.primitive.Path;

  /**
   * @author loki
   */
  public class Test2 extends BaseScene
  {
    public function Test2()
    {
      Parsers.enableAllBundled();
      super();
    }

    [Embed(source="line.obj", mimeType="application/octet-stream")]
    private var embeddedClass : Class;

    private var pathAnimator:PathAnimator;
    private var t:Number = 0;
    protected var whiteMaterial:ColorMaterial;

    override protected function initMaterials():void {
      whiteMaterial = new ColorMaterial(0xFFFFFF);
      whiteMaterial.lightPicker = lightPicker;
    }

    override protected function initObjects():void
    {
//      var loader:AssetLoader = new AssetLoader();
//      loader.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);
//      loader.loadData(new embeddedClass(), "line");

      var lineParser:LineParser = new LineParser();
      var p:Path = lineParser.parse(new embeddedClass());
      p.scale(100);
      scene.addChild(p);

      //var line:Line = new Line(new Vector3D(), new Vector3D(100, 100, 100));
      //scene.addChild(line);

//      var list:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(0,0,0),
//                                                      new Vector3D(500, 0, 0),
//                                                      new Vector3D(0, 500, 0),
//                                                      new Vector3D(500, 500, 0)]);
      var list:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(0,0,0),
                                                      new Vector3D(500, 0, 0),
                                                      new Vector3D(0, 500, 0)]);


      var sphere:WireframeSphere = new WireframeSphere();
      scene.addChild(sphere);

      //var path:CubicPath = new CubicPath(list);
      var path:QuadraticPath = new QuadraticPath(list);
      path.smoothPath();

      var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
      for (var i:int = 0; i < 100; i++) {
        var t1:Number = i/100;
        var segment:IPathSegment = path.segments[0];
        newList.push(segment.getPointOnSegment(t1));

        if (i > 0) {
          var line:Line = new Line(newList[i-1], newList[i]);
          scene.addChild(line);
        }
      }

      var cline1:Line = new Line(list[0], list[1]);
      var cline2:Line = new Line(list[1], list[2]);
      scene.addChild(cline1);
      scene.addChild(cline2);



      pathAnimator = new PathAnimator(path, sphere);


      //trace(path.segments[0].getPointOnSegment(0.5));
    }

    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);
      //pathAnimator.updateProgress(t += 0.01);
    }

    private function assetCompleteHandler(event:AssetEvent):void
    {
      if (event.asset.assetType == AssetType.MESH) {
        var mesh:Mesh = event.asset as Mesh;
        mesh.material = whiteMaterial;
        mesh.scale(100);
        scene.addChild(mesh);
      }
    }

  }
}
