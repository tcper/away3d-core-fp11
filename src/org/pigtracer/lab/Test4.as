package org.pigtracer.lab
{
  import away3d.materials.SegmentMaterial;
  import away3d.materials.TextureMaterial;
  import away3d.textures.BitmapTexture;
  import flash.display.BitmapData;
  import away3d.core.pick.PickingColliderType;
  import away3d.library.assets.AssetType;
  import away3d.events.AssetEvent;
  import away3d.loaders.parsers.OBJParser;
  import away3d.loaders.parsers.Parsers;
  import away3d.filters.BloomFilter3D;
  import away3d.primitives.PlaneGeometry;
  import away3d.materials.ColorMaterial;
  import away3d.entities.Mesh;
  import away3d.primitives.CubeGeometry;
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import flash.events.Event;
  import com.bit101.utils.MinimalConfigurator;
  import com.bit101.components.Component;
  import flash.geom.Vector3D;
  import org.pigtracer.lab.primitive.Line;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class Test4 extends BaseScene
  {
    public function Test4()
    {
      super();

      initUI();
    }

    private var config:MinimalConfigurator;
    private var zValue:int;

    [Embed(source="head.obj", mimeType="application/octet-stream")]
    private var headClass : Class;

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

    public function onClick(event:Event):void {
      createLines(zValue += 50);
    }

    private function initLines():void {
      var t:Timer = new Timer(100, 10);
      t.addEventListener(TimerEvent.TIMER, function (event:TimerEvent):void {
        createLines(zValue += 10);
      });
      t.start();
    }

    private function initSurface():void {
      var plane:PlaneGeometry = new PlaneGeometry(5000, 5000, 1, 1, true, true);
      var material:ColorMaterial = new ColorMaterial(0x666666);
      material.lightPicker = lightPicker;
      var mesh:Mesh = new Mesh(plane, material);
      mesh.y = -200;
      scene.addChild(mesh);
    }

    override protected function initObjects():void
    {
      super.initObjects();

      initSurface();

      var cube:CubeGeometry = new CubeGeometry();
      var material:ColorMaterial = new ColorMaterial(0xFFFFFF);
      material.lightPicker = lightPicker;

      var mesh:Mesh = new Mesh(cube,material);
      //scene.addChild(mesh);

      initLines();

      //view.filters3d = [new BloomFilter3D(50, 50, 20)];
      return;

      var objParser:OBJParser = new OBJParser();
      objParser.addEventListener(AssetEvent.ASSET_COMPLETE, assetCompleteHandler);
      objParser.parseAsync(new headClass());
    }

    private function assetCompleteHandler(event:AssetEvent):void
    {
      if (event.asset.assetType == AssetType.MESH) {
        initializeHeadModel(event.asset as Mesh);
      }
    }
    const PAINT_TEXTURE_SIZE:int = 1024;
    private function initializeHeadModel( model:Mesh ):void {

      // head = model;

      // Apply a bitmap material that can be painted on.
      var bmd:BitmapData = new BitmapData(PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000);
      bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);
      var bitmapTexture:BitmapTexture = new BitmapTexture(bmd);
      var textureMaterial:TextureMaterial = new TextureMaterial(bitmapTexture);
      textureMaterial.lightPicker = lightPicker;

      var sm:SegmentMaterial = new SegmentMaterial();

      model.material = sm;

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
    }

    private function createCubes():void
    {
      for (var i:int = 0; i < 10; i++) {
        createCube();
      }
    }


    private function createCube():void {
      var cube:CubeGeometry = new CubeGeometry();
      var material:ColorMaterial = new ColorMaterial(0xFFFFFF*Math.random());
      material.lightPicker = lightPicker;

      var mesh:Mesh = new Mesh(cube,material);
      mesh.x = Math.random()*1000 - 500;
      mesh.z = Math.random()*1000 - 500;
      mesh.y = Math.random()*500;
      scene.addChild(mesh);
    }

    private function createLines(zValue:Number):void {
      var start:Vector3D = new Vector3D();
      var end:Vector3D = new Vector3D();

      for (var i:int = 0; i < 5; i++) {
        start.x = 50*Math.random() - 25;
        start.y = 50*Math.random() - 25;
        start.z = zValue + 20*Math.random() - 10;

        end.x = 50*Math.random() - 25;
        end.y = 50*Math.random() - 25;
        end.z = zValue + 20*Math.random() - 10;

        var line:Line = new Line(start, end);
        scene.addChild(line);
      }
    }
  }
}
