package org.pigtracer.lab {
  import flash.events.Event;
  import com.bit101.utils.MinimalConfigurator;
  import com.bit101.components.Component;
  import away3d.materials.utils.WireframeMapGenerator;
  import away3d.loaders.parsers.Parsers;
  import flash.net.URLRequest;
  import away3d.loaders.Loader3D;
  import away3d.core.pick.PickingColliderType;
  import away3d.library.assets.AssetType;
  import away3d.materials.TextureMaterial;
  import away3d.textures.BitmapTexture;
  import flash.display.BitmapData;
  import away3d.events.AssetEvent;
  import away3d.loaders.parsers.OBJParser;
  import org.pigtracer.lab.primitive.WireframeMesh;
  import org.pigtracer.lab.utils.SegmentMapGenerator;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.primitives.CubeGeometry;

  /**
   * @author loki
   */
  public class Test5SegmentGenerator extends BaseScene
  {
    [Embed(source="head.obj", mimeType="application/octet-stream")]
    private var headClass:Class;
    private var config:MinimalConfigurator;
    private var wm:WireframeMesh;

    public function Test5SegmentGenerator()
    {
      super();

      initUI();
    }

    private function initUI():void
    {
      Component.initStage(stage);

      var xml:XML = <comps>
                      <Label id="myLabel" x="10" y="10" text="waiting..."/>
                      <PushButton id="go" x="10" y="40" label="go" event="click:onClickGo"/>
                      <PushButton id="back" x="10" y="60" label="back" event="click:onClickBack"/>
                    </comps>;

      config = new MinimalConfigurator(this);
      config.parseXML(xml);
    }

    public function onClickGo(event:Event):void {
      wm.go();
    }

    public function onClickBack(event:Event):void {
      wm.back();
    }

    override protected function initObjects():void
    {
      //drawCube();
      drawAsset();
    }

    private function drawAsset():void {
//      var objParser:OBJParser = new OBJParser();
//      objParser.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);
//      objParser.parseAsync(new headClass());

      Parsers.enableAllBundled();

      var loader:Loader3D = new Loader3D();
      loader.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);
      loader.load(new URLRequest("monkey.obj"));
    }

    private function assetCompleteHandler(event:AssetEvent):void
    {
      if (event.asset.assetType == AssetType.MESH) {
//        initializeHeadModel(event.asset as Mesh);
        initializeWireframe(event.asset as Mesh);
      }
    }

    private function initializeWireframe(model:Mesh):void {
      wm = SegmentMapGenerator.generateWireframe(model);
      wm.scale(100);

      scene.addChild(wm);
    }

    private const PAINT_TEXTURE_SIZE:int = 1024;

    private function initializeHeadModel( model:Mesh ):void {

      // head = model;

      // Apply a bitmap material that can be painted on.
      var bmd:BitmapData = new BitmapData(PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000);
      bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);
      var bitmapTexture:BitmapTexture = new BitmapTexture(bmd);
      var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTexture);
      textureMaterial.lightPicker = lightPicker;


      model.material = textureMaterial;

      // Set up a ray picking collider.
      // The head model has quite a lot of triangles, so its best to use pixel bender for ray picking calculations.
      // NOTE: Pixel bender will not produce faster results on devices with only one cpu core, and will not work on iOS.
      model.pickingCollider = PickingColliderType.PB_BEST_HIT;
      // model.pickingCollider = PickingColliderType.PB_FIRST_ENCOUNTERED; // is faster, but causes weirdness around the eyes

      // Apply mouse interactivity.
      model.mouseEnabled = model.mouseChildren = model.shaderPickingDetails = true;

      // enableMeshMouseListeners( model );
      model.scale(100);
      view.scene.addChild(model);


      trace(model.subMeshes[0].vertexData.length);

//      var wm:WireframeMesh = SegmentMapGenerator.generateWireframe(model);
//      wm.scale(100);
//      scene.addChild(wm);
    }

    private function drawCube():void {
      var geom:CubeGeometry = new CubeGeometry();
      var material:ColorMaterial = new ColorMaterial();
      material.lightPicker = lightPicker;
      var cube:Mesh = new Mesh(geom, material);

      //scene.addChild(cube);

      var wm:WireframeMesh = SegmentMapGenerator.generateWireframe(cube);
      scene.addChild(wm);
    }

  }
}
