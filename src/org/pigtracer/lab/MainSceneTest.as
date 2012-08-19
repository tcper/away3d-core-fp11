package org.pigtracer.lab {
  import com.greensock.TweenLite;
  import away3d.animators.PathAnimator;
  import flash.geom.Vector3D;
  import away3d.paths.QuadraticPath;
  import away3d.primitives.WireframeSphere;
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.lights.PointLight;
  import flash.display.Graphics;
  import flash.display.Sprite;
  import away3d.entities.Mesh;
  import away3d.textures.BitmapTexture;
  import flash.display.GradientType;
  import flash.geom.Matrix;
  import flash.display.GraphicsGradientFill;
  import flash.display.Shape;
  import flash.display.BitmapData;
  import flash.events.Event;
  import com.bit101.components.PushButton;
  import away3d.materials.methods.HardShadowMapMethod;
  import org.pigtracer.lab.BaseScene;

  /**
   * @author loki
   */
  public class MainSceneTest extends BaseScene {
    public function MainSceneTest() {
      super();
      initUI();  
    }
    
    private var follower:Sprite;
    
    private var isLook:int = 0;
    private var ani:PathAnimator;
    
    private function initUI() : void {
      var btn:PushButton = new PushButton(this, 0, 0, "push", handler);
      var btn2:PushButton = new PushButton(this, 0, 20, "push2", handler2);
      var btn3:PushButton = new PushButton(this, 0, 40, "push3", handler3);
      var btn4:PushButton = new PushButton(this, 0, 60, "animate camera", handler4);
      var btn5:PushButton = new PushButton(this, 0, 80, "animate camera back", handler5);
      
      var matrix:Matrix = new Matrix();
      var coverGradient:Shape = new Shape();
      
      matrix.createGradientBox(1024, 1024, Math.PI / 2, 1024 / 2, 1024 / 2);

      coverGradient.graphics.beginGradientFill(GradientType.LINEAR, [0xffffff, 0x0], [1, 0], [0, 230], matrix);

      coverGradient.graphics.drawRect(0, 0, 1024, 1024);

      coverGradient.graphics.endFill();

      var bd:BitmapData = new BitmapData(1024, 1024);
      bd.draw(coverGradient);
      var texture:BitmapTexture = new BitmapTexture(bd);
      view.background = texture;

      var list:Vector.<Vector3D> = new <Vector3D>[new Vector3D(0, 0, 0),
                                                  new Vector3D(0, 500, 2000),
                                                  new Vector3D(0, 1000, 1000)];
      var path:QuadraticPath = new QuadraticPath(list);
      ani = new PathAnimator(path, camera);
    }

  
    private var m2:MessageScene;
    private var pointLight2:PointLight;
    private var lightPicker2:StaticLightPicker;


    private function handler4(event:Event):void {
      
      TweenLite.to(ani, 1, {t:1});
      
      isLook = 1;
    }
    private function handler5(event:Event):void {
      
      TweenLite.to(ani, 1, {t:0});
      
      isLook = 2;
    }
    private function handler3(event:Event):void {
      m2.start();
    }
    
    private function handler2(event:Event):void {
      m.start2();
    }

    private function handler(event:Event) : void {
      m.start();
    }
    
    
    private var m:MessageScene;
    override protected function initObjects() : void {
      super.initObjects();
      //pointLight.z = 300;
      pointLight.y = 300;
      pointLight.castsShadows = true;
      // maximum, small scene
      pointLight.shadowMapper.depthMapSize = 1024;
      //pointLight.y = 100;
      pointLight.color = 0xffffff;
      pointLight.diffuse = 1;
      pointLight.specular = 1;
      pointLight.radius = 1000;
      pointLight.fallOff = 1000;
      pointLight.ambient = 0xa0a0c0;
      pointLight.ambient = .3;
      
      m = new MessageScene();
      m.bgMaterial.lightPicker = lightPicker;
      m.bgMaterial.shadowMethod = new HardShadowMapMethod(pointLight);
      m.bgMaterial.specular = .25;
      m.bgMaterial.gloss = 20;
      m.colorMaterial.lightPicker = lightPicker;
      scene.addChild(m);
      
      m2 = new MessageScene();
      m2.bgMaterial.lightPicker = lightPicker2;
      m2.bgMaterial.shadowMethod = new HardShadowMapMethod(pointLight2);
      m2.bgMaterial.specular = .25;
      m2.bgMaterial.gloss = 20;
      m2.colorMaterial.lightPicker = lightPicker2;
      
      m2.y = 1000;
      m2.rotationX = 90;
      scene.addChild(m2);
      
//      follower = new Sprite();
//      var g:Graphics = follower.graphics;
//      g.beginFill(0x0);
//      g.drawRect(0, 0, 200, 200);
//      g.endFill();
//      addChild(follower);
    }
    
    
    override protected function initLights():void {
      super.initLights();
      
      
      pointLight2 = new PointLight();
      scene.addChild(pointLight2);
      lightPicker2 = new StaticLightPicker([pointLight2]);
      
      pointLight2.y = 1200;
      pointLight2.z = 300;
      
      var sphere:WireframeSphere = new WireframeSphere(10,16, 12, 0xFF0000);
      sphere.position = pointLight2.position;
      scene.addChild(sphere);
      
      pointLight2.castsShadows = true;
      // maximum, small scene
      pointLight2.shadowMapper.depthMapSize = 1024;
      //pointLight.y = 100;
      pointLight2.color = 0xffffff;
      pointLight2.diffuse = 1;
      pointLight2.specular = 1;
      pointLight2.radius = 1000;
      pointLight2.fallOff = 1000;
      pointLight2.ambient = 0xa0a0c0;
      pointLight2.ambient = .3;
    }

    override protected function enterFrameHandler(event:Event):void {
      switch (isLook) {
        case 0:
          super.enterFrameHandler(event);
          break;
        
        case 1:
          camera.lookAt(new Vector3D(0, 1000, 0));
          view.render();
          break;
        
        case 2:
          camera.lookAt(new Vector3D(0, 0, 0));
          view.render();
          break;
        
      }
//      var meshList:Vector.<Mesh> = m.meshList;
//      var mesh:Mesh = meshList[0];
//      follower.x =stage.stageWidth/2-mesh.scenePosition.x;
//      follower.y =stage.stageHeight/2-mesh.scenePosition.y;
    }

  }
}
