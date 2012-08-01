package org.pigtracer.lab {
  import away3d.animators.PathAnimator;
  import away3d.controllers.SpringController;
  import away3d.debug.Trident;
  import away3d.debug.WireframeAxesGrid;
  import away3d.entities.Mesh;
  import away3d.materials.ColorMaterial;
  import away3d.materials.TextureMaterial;
  import away3d.materials.utils.WireframeMapGenerator;
  import away3d.paths.CubicPath;
  import away3d.primitives.CubeGeometry;
  import away3d.primitives.SkyBox;
  import away3d.primitives.WireframeCylinder;
  import away3d.primitives.WireframeSphere;
  import away3d.textures.BitmapCubeTexture;
  import away3d.textures.BitmapTexture;
  import com.greensock.TweenLite;
  import com.greensock.motionPaths.LinePath2D;
  import com.greensock.motionPaths.PathFollower;
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.events.MouseEvent;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.geom.Vector3D;
  import mx.core.BitmapAsset;

  /**
   * @author loki
   */
  public class Test1 extends BaseScene {
    public function Test1() {
      super();
    }
    [Embed(source="20127611554625.jpg")]
    private var embeddedClass : Class;
    //==========================================================================
    //  Variables
    //==========================================================================
    protected var whiteMaterial:ColorMaterial;
    protected var cubeGeometry:CubeGeometry;
    protected var springController:SpringController;
    protected var sphere:WireframeSphere = new WireframeSphere();
    protected var animator:PathAnimator;
    protected var t:Number = 0;
    //==========================================================================
    //  Overridden methods
    //==========================================================================
    override protected function initMaterials():void {
      whiteMaterial = new ColorMaterial(0xFFFFFF);
      whiteMaterial.lightPicker = lightPicker;
    }

    override protected function initController():void {
      springController = new SpringController(camera, sphere, 2, 10);
      springController.autoUpdate = true;
    }

    override protected function initObjects():void {
      cubeGeometry = new CubeGeometry(25, 25, 25, 10, 10, 10);


      /*var obj:Mesh = new Mesh(cubeGeometry, whiteMaterial);
      var bitmap:BitmapData = new BitmapData(512, 512, false, 0xFF0000);
      bitmap = WireframeMapGenerator.generateTexturedMap(obj, bitmap);

      var texture:BitmapTexture = new BitmapTexture(bitmap);
      var m:TextureMaterial = new TextureMaterial(texture);
      m.lightPicker = lightPicker;
      obj.material = m;

      scene.addChild(obj);*/

      var trident:Trident = new Trident();
      scene.addChild(trident);

      /*var wire:WireframeCylinder = new WireframeCylinder(10, 10);
      scene.addChild(wire);

      wire.lookAt(new Vector3D(100, 100, 100));


      scene.addChild(sphere);

      sphere.position = new Vector3D(100, 100, 100);

      var flip:BitmapData = BitmapAsset(new embeddedClass()).bitmapData;
      var flip1:BitmapData = new BitmapData(512, 512);
      flip1.copyPixels(flip, new Rectangle(0, 0, 512, 512), new Point(0, 0));


      var skyMaterial:BitmapCubeTexture = new BitmapCubeTexture(flip1, flip1, flip1, flip1, flip1, flip1);
      var sky:SkyBox = new SkyBox(skyMaterial);
      scene.addChild(sky);



      stage.addEventListener(MouseEvent.CLICK, clickHandler);

      scene.addChild(new WireframeAxesGrid());*/

      scene.addChild(sphere);

      var list:Vector.<Vector3D> = new Vector.<Vector3D>();

      for (var i:int = 0; i < 1000; i+=1) {
        var point:Vector3D = createPoint(i);
        list.push(point);
      }

      var path:CubicPath = new CubicPath(list);
      animator = new PathAnimator(path, sphere);

    }

    private function createPoint(i:int):Vector3D
    {
      const R:int = 500;
      var v:Vector3D = new Vector3D();
      v.x = Math.sin(i/50) * R;
      v.y = Math.cos(i/50) * R;
      v.z = Math.sin(i/25) * R;
      return v;
    }

    private function clickHandler(event:MouseEvent):void {
      TweenLite.to(sphere, 2,{x:sphere.x + 500, y:200});

    }


    override protected function enterFrameHandler(event:Event):void {
      super.enterFrameHandler(event);
      //springController.update();
      animator.updateProgress(t += 0.002);
    }

  }
}
