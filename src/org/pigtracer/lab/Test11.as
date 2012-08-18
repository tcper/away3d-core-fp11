package org.pigtracer.lab
{
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.lights.PointLight;
  import org.pigtracer.lab.primitive.Line;
  import away3d.paths.IPathSegment;
  import away3d.animators.PathAnimator;
  import away3d.containers.ObjectContainer3D;
  import away3d.entities.Mesh;
  import away3d.materials.TextureMaterial;
  import away3d.materials.methods.HardShadowMapMethod;
  import away3d.paths.QuadraticPath;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;

  import com.greensock.TweenLite;

  import org.pigtracer.lab.primitive.CubeUnion;
  import org.pigtracer.lab.primitive.LineParser;
  import org.pigtracer.lab.utils.CameraUtil;

  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.geom.Vector3D;

  /**
   * @author loki
   */
  public class Test11 extends BaseScene
  {
    private var container:ObjectContainer3D;
    private var pathAnimator:PathAnimator;

    private var planePath:QuadraticPath;
    private var planePathAnimator:PathAnimator;

    private var lookatPoint:Vector3D = new Vector3D();

    [Embed(source="curve.obj", mimeType="application/octet-stream")]
    private var embeddedClass : Class;
    
    private var p1:PointLight;

    public function Test11()
    {
      super();
      view.backgroundColor = 0xffffff;
    }

    override protected function initMaterials():void
    {
      super.initMaterials();

      pointLight.y = 300;
      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      // pointLight.y = 100;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      //pointLight.radius = 400;
      pointLight.fallOff = 500;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;
      
      p1 = new PointLight();
      p1.y = 300;
      
      p1.fallOff = 400;
      p1.color = 0xffffff;
      scene.addChild(p1);
      
      lightPicker.lights = [p1];
      
    }

    override protected function initObjects():void
    {
      container = new ObjectContainer3D();
      scene.addChild(container);

      var union:CubeUnion = new CubeUnion();
      union.material.lightPicker = lightPicker;
      union.y = 100;
      container.addChild(union);

      var planeGeom:PlaneGeometry = new PlaneGeometry(10000, 10000, 8, 8, true, true);
      var bitmap:BitmapData = new BitmapData(16, 16, false, 0x00FF00);
      var bitmapTexure:BitmapTexture = new BitmapTexture(bitmap);
      var bitmapMaterial:TextureMaterial = new TextureMaterial(bitmapTexure);

      bitmapMaterial.lightPicker = lightPicker;

      bitmapMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bitmapMaterial.specular = .25;
      bitmapMaterial.gloss = 20;
      bitmapMaterial.bothSides = true;

      var planeMesh:Mesh = new Mesh(planeGeom, bitmapMaterial);
      //planeMesh.rotationX = 90;
      container.addChild(planeMesh);

      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0,0,0),
                                                  new Vector3D(500, 0, 0),
                                                  new Vector3D(0, 0, 1000)];

      var cubicPath:QuadraticPath = new QuadraticPath(list);

      var newList:Vector.<Vector3D> = new Vector.<Vector3D>();
      for (var i:int = 0; i < 100; i++) {
        var t1:Number = i/100;
        var segment:IPathSegment = cubicPath.segments[0];
        newList.push(segment.getPointOnSegment(t1));

        if (i > 0) {
          var line:Line = new Line(newList[i-1], newList[i]);
          container.addChild(line);
        }
      }


      pathAnimator = new PathAnimator(cubicPath, camera);

      //TweenLite.to(pathAnimator, 2, {t:1, onComplete:camComplete});
      //TweenLite.to(pathAnimator, 1, {t:1, onComplete:comp1});



      addPlanes();

      planePath = new QuadraticPath(new <Vector3D>[new Vector3D(0, 0, 1000),
                                                   new Vector3D(),
                                                   new Vector3D(4000, 0, 0)
                                                    ]);

      planePathAnimator = new PathAnimator(planePath, camera);
    }
    private function comp1():void {
      lookatPoint = new Vector3D(5000, 0, 0);
      TweenLite.to(planePathAnimator, 1, {t:1});
    }

    private function addPlanes():void {
      var planeGeom:PlaneGeometry = new PlaneGeometry(10000, 10000, 8, 8, true, true);
      var bitmap:BitmapData = new BitmapData(16, 16, false, 0x0000ff);
      var bitmapTexure:BitmapTexture = new BitmapTexture(bitmap);
      var bitmapMaterial:TextureMaterial = new TextureMaterial(bitmapTexure);

      bitmapMaterial.lightPicker = lightPicker;

      bitmapMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      bitmapMaterial.specular = .25;
      bitmapMaterial.gloss = 20;
      bitmapMaterial.bothSides = true;

      var planeMesh:Mesh = new Mesh(planeGeom, bitmapMaterial);
      planeMesh.x = 5000;
      //planeMesh.z = 5000;
      planeMesh.rotationZ = 90;

//      planeMesh.
      scene.addChild(planeMesh);
    }

    private function camComplete():void {
      var parse:LineParser = new LineParser();
      var list:Vector.<Vector3D> = parse.parseGetData(new embeddedClass());
      CameraUtil.cameraTrack(camera, list);
    }

    override protected function enterFrameHandler(event:Event):void
    {
      super.enterFrameHandler(event);
      return;
      // var xoffset:Number = mouseX - stage.stageWidth/2;
      // var yoffset:Number = mouseY - stage.stageHeight/2;
      var rateX:Number = (mouseX - stage.stageWidth / 2) * 0.05 + (45/2);
      // +45/2;
      var rateY:Number = (mouseY - stage.stageHeight / 2) * 0.05 ;
      // +45/2;

      container.rotationY += (rateX - container.rotationY) * 0.1;
      container.rotationX += (-rateY - container.rotationX) * 0.1;

      // follower.x =stage.stageWidth/2-sphere.scenePosition.x;
      // follower.y =stage.stageHeight/2-sphere.scenePosition.y;

      camera.lookAt(lookatPoint);


      view.render();
    }
  }
}
