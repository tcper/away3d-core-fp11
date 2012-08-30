package org.pigtracer.lab {
  import away3d.bounds.AxisAlignedBoundingBox;
  import away3d.bounds.BoundingSphere;
  import away3d.bounds.BoundingVolumeBase;
  import away3d.bounds.NullBounds;
  import away3d.cameras.Camera3D;
  import away3d.containers.ObjectContainer3D;
  import away3d.containers.Scene3D;
  import away3d.containers.View3D;
  import away3d.controllers.ControllerBase;
  import away3d.controllers.FirstPersonController;
  import away3d.controllers.FollowController;
  import away3d.controllers.HoverController;
  import away3d.controllers.LookAtController;
  import away3d.controllers.SpringController;
  import away3d.core.base.Geometry;
  import away3d.core.base.IMaterialOwner;
  import away3d.core.base.IRenderable;
  import away3d.core.base.Object3D;
  import away3d.core.base.SkinnedSubGeometry;
  import away3d.core.base.SubGeometry;
  import away3d.core.base.SubMesh;
  import away3d.core.pick.AS3PickingCollider;
  import away3d.core.pick.AutoPickingCollider;
  import away3d.core.pick.IPicker;
  import away3d.core.pick.IPickingCollider;
  import away3d.core.pick.PBPickingCollider;
  import away3d.core.pick.PickingColliderBase;
  import away3d.core.pick.PickingColliderType;
  import away3d.core.pick.PickingCollisionVO;
  import away3d.core.pick.PickingType;
  import away3d.core.pick.RaycastPicker;
  import away3d.core.pick.ShaderPicker;
  import away3d.debug.AwayStats;
  import away3d.debug.Debug;
  import away3d.debug.Trident;
  import away3d.debug.WireframeAxesGrid;
  import away3d.entities.Entity;
  import away3d.entities.Mesh;
  import away3d.entities.SegmentSet;
  import away3d.entities.Sprite3D;
  import away3d.entities.TextureProjector;
  import away3d.events.AnimationStateEvent;
  import away3d.events.AnimatorEvent;
  import away3d.events.AssetEvent;
  import away3d.events.GeometryEvent;
  import away3d.events.LensEvent;
  import away3d.events.LoaderEvent;
  import away3d.events.MouseEvent3D;
  import away3d.events.Object3DEvent;
  import away3d.events.ParserEvent;
  import away3d.events.PathEvent;
  import away3d.events.Scene3DEvent;
  import away3d.events.ShadingMethodEvent;
  import away3d.events.Stage3DEvent;

  import away3d.library.assets.AssetType;
  import away3d.library.assets.BitmapDataAsset;
  import away3d.library.assets.IAsset;
  import away3d.library.assets.NamedAssetBase;
  import away3d.lights.DirectionalLight;
  import away3d.lights.LightBase;
  import away3d.lights.LightProbe;
  import away3d.lights.PointLight;
  import away3d.loaders.parsers.AC3DParser;
  import away3d.loaders.parsers.AWD1Parser;
  import away3d.loaders.parsers.AWD2Parser;
  import away3d.loaders.parsers.AWDParser;
  import away3d.loaders.parsers.DAEParser;
  import away3d.loaders.parsers.ImageParser;
  import away3d.loaders.parsers.MD2Parser;
  import away3d.loaders.parsers.MD5AnimParser;
  import away3d.loaders.parsers.MD5MeshParser;
  import away3d.loaders.parsers.Max3DSParser;
  import away3d.loaders.parsers.OBJParser;
  import away3d.loaders.parsers.ParserBase;
  import away3d.loaders.parsers.ParserDataFormat;
  import away3d.loaders.parsers.Parsers;
  import away3d.materials.ColorMaterial;
  import away3d.materials.DefaultMaterialBase;
  import away3d.materials.LightSources;
  import away3d.materials.MaterialBase;
  import away3d.materials.SegmentMaterial;
  import away3d.materials.SkyBoxMaterial;
  import away3d.materials.TextureMaterial;
  import away3d.materials.lightpickers.LightPickerBase;
  import away3d.materials.lightpickers.StaticLightPicker;
  import away3d.primitives.CapsuleGeometry;
  import away3d.primitives.ConeGeometry;
  import away3d.primitives.CubeGeometry;
  import away3d.primitives.CylinderGeometry;
  import away3d.primitives.LineSegment;
  import away3d.primitives.PlaneGeometry;
  import away3d.primitives.PrimitiveBase;
  import away3d.primitives.RegularPolygonGeometry;
  import away3d.primitives.SkyBox;
  import away3d.primitives.SphereGeometry;
  import away3d.primitives.TorusGeometry;
  import away3d.primitives.WireframeCube;
  import away3d.primitives.WireframeCylinder;
  import away3d.primitives.WireframePlane;
  import away3d.primitives.WireframePrimitiveBase;
  import away3d.primitives.WireframeSphere;
  import away3d.textures.BitmapCubeTexture;
  import away3d.textures.BitmapTexture;
  import away3d.textures.BitmapTextureCache;
  import away3d.textures.CubeTextureBase;
  import away3d.textures.RenderCubeTexture;
  import away3d.textures.RenderTexture;
  import away3d.textures.SpecularBitmapTexture;
  import away3d.textures.SplatBlendBitmapTexture;
  import away3d.textures.Texture2DBase;
  import away3d.textures.TextureProxyBase;
  import away3d.textures.VideoTexture;
  import away3d.textures.WebcamTexture;
  import flash.display.AVM1Movie;
  import flash.display.ActionScriptVersion;
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.BitmapDataChannel;
  import flash.display.BlendMode;
  import flash.display.CapsStyle;
  import flash.display.ColorCorrection;
  import flash.display.ColorCorrectionSupport;
  import flash.display.DisplayObject;
  import flash.display.DisplayObjectContainer;
  import flash.display.FocusDirection;
  import flash.display.FrameLabel;
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.display.GraphicsBitmapFill;
  import flash.display.GraphicsEndFill;
  import flash.display.GraphicsGradientFill;
  import flash.display.GraphicsPath;
  import flash.display.GraphicsPathCommand;
  import flash.display.GraphicsPathWinding;
  import flash.display.GraphicsShaderFill;
  import flash.display.GraphicsSolidFill;
  import flash.display.GraphicsStroke;
  import flash.display.GraphicsTrianglePath;
  import flash.display.IBitmapDrawable;
  import flash.display.IDrawCommand;
  import flash.display.IGraphicsData;
  import flash.display.IGraphicsFill;
  import flash.display.IGraphicsPath;
  import flash.display.IGraphicsStroke;
  import flash.display.InteractiveObject;
  import flash.display.InterpolationMethod;
  import flash.display.JointStyle;
  import flash.display.LineScaleMode;
  import flash.display.Loader;
  import flash.display.LoaderInfo;
  import flash.display.MorphShape;
  import flash.display.MovieClip;
  import flash.display.NativeMenu;
  import flash.display.NativeMenuItem;
  import flash.display.NativeWindow;
  import flash.display.NativeWindowDisplayState;
  import flash.display.NativeWindowInitOptions;
  import flash.display.NativeWindowRenderMode;
  import flash.display.NativeWindowResize;
  import flash.display.NativeWindowSystemChrome;
  import flash.display.NativeWindowType;
  import flash.display.PixelSnapping;
  import flash.display.SWFVersion;
  import flash.display.Scene;
  import flash.display.Screen;
  import flash.display.Shader;
  import flash.display.ShaderData;
  import flash.display.ShaderInput;
  import flash.display.ShaderJob;
  import flash.display.ShaderParameter;
  import flash.display.ShaderParameterType;
  import flash.display.ShaderPrecision;
  import flash.display.Shape;
  import flash.display.SimpleButton;
  import flash.display.SpreadMethod;
  import flash.display.Sprite;
  import flash.display.Stage;
  import flash.display.Stage3D;
  import flash.display.StageAlign;
  import flash.display.StageAspectRatio;
  import flash.display.StageDisplayState;
  import flash.display.StageOrientation;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.display.TriangleCulling;
  import flash.events.AccelerometerEvent;
  import flash.events.ActivityEvent;
  import flash.events.AsyncErrorEvent;
  import flash.events.BrowserInvokeEvent;
  import flash.events.ContextMenuEvent;
  import flash.events.DNSResolverEvent;
  import flash.events.DRMAuthenticateEvent;
  import flash.events.DRMAuthenticationCompleteEvent;
  import flash.events.DRMAuthenticationErrorEvent;
  import flash.events.DRMCustomProperties;
  import flash.events.DRMDeviceGroupErrorEvent;
  import flash.events.DRMDeviceGroupEvent;
  import flash.events.DRMErrorEvent;
  import flash.events.DRMStatusEvent;
  import flash.events.DataEvent;
  import flash.events.DatagramSocketDataEvent;
  import flash.events.ErrorEvent;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.EventPhase;
  import flash.events.FileListEvent;
  import flash.events.FocusEvent;
  import flash.events.FullScreenEvent;
  import flash.events.GameInputEvent;
  import flash.events.GeolocationEvent;
  import flash.events.GestureEvent;
  import flash.events.GesturePhase;
  import flash.events.HTMLUncaughtScriptExceptionEvent;
  import flash.events.HTTPStatusEvent;
  import flash.events.IEventDispatcher;
  import flash.events.IMEEvent;
  import flash.events.IOErrorEvent;
  import flash.events.InvokeEvent;
  import flash.events.KeyboardEvent;
  import flash.events.LocationChangeEvent;
  import flash.events.MediaEvent;
  import flash.events.MouseEvent;
  import flash.events.NativeDragEvent;
  import flash.events.NativeProcessExitEvent;
  import flash.events.NativeWindowBoundsEvent;
  import flash.events.NativeWindowDisplayStateEvent;
  import flash.events.NetDataEvent;
  import flash.events.NetFilterEvent;
  import flash.events.NetMonitorEvent;
  import flash.events.NetStatusEvent;
  import flash.events.OutputProgressEvent;
  import flash.events.PressAndTapGestureEvent;
  import flash.events.ProgressEvent;
  import flash.events.SQLErrorEvent;
  import flash.events.SQLEvent;
  import flash.events.SQLUpdateEvent;
  import flash.events.SampleDataEvent;
  import flash.events.ScreenMouseEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.ServerSocketConnectEvent;
  import flash.events.ShaderEvent;
  import flash.events.SoftKeyboardEvent;
  import flash.events.SoftKeyboardTrigger;
  import flash.events.StageOrientationEvent;
  import flash.events.StageVideoAvailabilityEvent;
  import flash.events.StageVideoEvent;
  import flash.events.StatusEvent;
  import flash.events.StorageVolumeChangeEvent;
  import flash.events.SyncEvent;
  import flash.events.TextEvent;
  import flash.events.TimerEvent;
  import flash.events.TouchEvent;
  import flash.events.TouchEventIntent;
  import flash.events.TransformGestureEvent;
  import flash.events.UncaughtErrorEvent;
  import flash.events.UncaughtErrorEvents;
  import flash.events.VideoEvent;
  import flash.filters.BevelFilter;
  import flash.filters.BitmapFilter;
  import flash.filters.BitmapFilterQuality;
  import flash.filters.BitmapFilterType;
  import flash.filters.BlurFilter;
  import flash.filters.ColorMatrixFilter;
  import flash.filters.ConvolutionFilter;
  import flash.filters.DisplacementMapFilter;
  import flash.filters.DisplacementMapFilterMode;
  import flash.filters.DropShadowFilter;
  import flash.filters.GlowFilter;
  import flash.filters.GradientBevelFilter;
  import flash.filters.GradientGlowFilter;
  import flash.filters.ShaderFilter;
  import flash.geom.ColorTransform;
  import flash.geom.Matrix;
  import flash.geom.Matrix3D;
  import flash.geom.Orientation3D;
  import flash.geom.PerspectiveProjection;
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.geom.Transform;
  import flash.geom.Utils3D;
  import flash.geom.Vector3D;
  import flash.text.AntiAliasType;
  import flash.text.AutoCapitalize;
  import flash.text.CSMSettings;
  import flash.text.Font;
  import flash.text.FontStyle;
  import flash.text.FontType;
  import flash.text.GridFitType;
  import flash.text.ReturnKeyLabel;
  import flash.text.SoftKeyboardType;
  import flash.text.StageText;
  import flash.text.StageTextImpl;
  import flash.text.StageTextInitOptions;
  import flash.text.StaticText;
  import flash.text.StyleSheet;
  import flash.text.TextColorType;
  import flash.text.TextDisplayMode;
  import flash.text.TextExtent;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  import flash.text.TextFieldType;
  import flash.text.TextFormat;
  import flash.text.TextFormatAlign;
  import flash.text.TextFormatDisplay;
  import flash.text.TextInteractionMode;
  import flash.text.TextLineMetrics;
  import flash.text.TextRenderer;
  import flash.text.TextRun;
  import flash.text.TextSnapshot;
  import flash.ui.ContextMenu;
  import flash.ui.ContextMenuBuiltInItems;
  import flash.ui.ContextMenuClipboardItems;
  import flash.ui.ContextMenuItem;
  import flash.ui.GameInput;
  import flash.ui.GameInputControl;
  import flash.ui.GameInputControlType;
  import flash.ui.GameInputDevice;
  import flash.ui.GameInputFinger;
  import flash.ui.GameInputHand;
  import flash.ui.KeyLocation;
  import flash.ui.Keyboard;
  import flash.ui.KeyboardType;
  import flash.ui.Mouse;
  import flash.ui.MouseCursor;
  import flash.ui.MouseCursorData;
  import flash.ui.Multitouch;
  import flash.ui.MultitouchInputMode;


  [SWF(backgroundColor="#000000", frameRate="60")]
  public class Away3dgold extends Sprite
  {


    //engine variables
    private var scene:Scene3D;
    private var camera:Camera3D;
    private var view:View3D;
    private var awayStats:AwayStats;
    private var cameraController:HoverController;



    //light objects
    private var pointLight:PointLight;
    private var lightPicker:StaticLightPicker;

    //material objects
    private var painter:Sprite;
    private var blackMaterial:ColorMaterial;
    private var whiteMaterial:ColorMaterial;
    private var grayMaterial:ColorMaterial;
    private var blueMaterial:ColorMaterial;
    private var redMaterial:ColorMaterial;

    //scene objects
    private var text:TextField;
    private var pickingPositionTracer:Mesh;
    private var pickingNormalTracer:SegmentSet;
    private var head:Mesh;
    private var cubeGeometry:CubeGeometry;
    private var sphereGeometry:SphereGeometry;
    private var cylinderGeometry:CylinderGeometry;
    private var torusGeometry:TorusGeometry;

    //navigation variables
    private var move:Boolean = false;
    private var lastPanAngle:Number;
    private var lastTiltAngle:Number;
    private var lastMouseX:Number;
    private var lastMouseY:Number;
    private var tiltSpeed:Number = 4;
    private var panSpeed:Number = 4;
    private var distanceSpeed:Number = 4;
    private var tiltIncrement:Number = 0;
    private var panIncrement:Number = 0;
    private var distanceIncrement:Number = 0;

    // Assets.
    [Embed(source="tests/head.obj", mimeType="application/octet-stream")]
    private var HeadAsset:Class;

    private const PAINT_TEXTURE_SIZE:uint = 1024;

    /**
     * Constructor
     */
    public function Away3dgold()
    {
      init();
    }

    /**
     * Global initialise function
     */
    private function init():void
    {
      initEngine();
      initText();
      initLights();
      initMaterials();
      initObjects();
      initListeners();
    }

    /**
     * Initialise the engine
     */
    private function initEngine():void
    {
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;

      view = new View3D();
      view.forceMouseMove = true;
      scene = view.scene;
      camera = view.camera;

      // Chose global picking method ( chose one ).
//      view.mousePicker = PickingType.SHADER; // Uses the GPU, considers gpu animations, and suffers from Stage3D's drawToBitmapData()'s bottleneck.
//      view.mousePicker = PickingType.RAYCAST_FIRST_ENCOUNTERED; // Uses the CPU, fast, but might be inaccurate with intersecting objects.
      view.mousePicker = PickingType.RAYCAST_BEST_HIT; // Uses the CPU, guarantees accuracy with a little performance cost.

      //setup controller to be used on the camera
      cameraController = new HoverController(camera, null, 180, 20, 320, 5);

      view.addSourceURL("srcview/index.html");
      addChild(view);

      //add signature


      awayStats = new AwayStats(view);
      addChild(awayStats);
    }

    /**
     * Create an instructions overlay
     */
    private function initText():void
    {
      text = new TextField();
      text.defaultTextFormat = new TextFormat("Verdana", 11, 0xFFFFFF);
      text.width = 1000;
      text.height = 200;
      text.x = 25;
      text.y = 50;
      text.selectable = false;
      text.mouseEnabled = false;
      text.text = "Camera controls -----\n";
      text.text = "  Click and drag on the stage to rotate camera.\n";
      text.appendText("  Keyboard arrows and WASD also rotate camera and Z and X zoom camera.\n");
      text.appendText("Picking ----- \n");
      text.appendText("  Click on the head model to draw on its texture. \n");
      text.appendText("  Red objects have triangle picking precision. \n" );
      text.appendText("  Blue objects have bounds picking precision. \n" );
      text.appendText("  Gray objects are disabled for picking but occlude picking on other objects. \n" );
      text.appendText("  Black objects are completely ignored for picking. \n" );
      text.filters = [new DropShadowFilter(1, 45, 0x0, 1, 0, 0)];
      addChild(text);
    }

    /**
     * Initialise the lights
     */
    private function initLights():void
    {
      //create a light for the camera
      pointLight = new PointLight();
      scene.addChild(pointLight);
      lightPicker = new StaticLightPicker([pointLight]);
    }

    /**
     * Initialise the material
     */
    private function initMaterials():void
    {
      // uv painter
      painter = new Sprite();
      painter.graphics.beginFill( 0xFF0000 );
      painter.graphics.drawCircle( 0, 0, 10 );
      painter.graphics.endFill();

      // locator materials
      whiteMaterial = new ColorMaterial( 0xFFFFFF );
      whiteMaterial.lightPicker = lightPicker;
      blackMaterial = new ColorMaterial( 0x333333 );
      blackMaterial.lightPicker = lightPicker;
      grayMaterial = new ColorMaterial( 0xCCCCCC );
      grayMaterial.lightPicker = lightPicker;
      blueMaterial = new ColorMaterial( 0x0000FF );
      blueMaterial.lightPicker = lightPicker;
      redMaterial = new ColorMaterial( 0xFF0000 );
      redMaterial.lightPicker = lightPicker;
    }

    /**
     * Initialise the scene objects
     */
    private function initObjects():void
    {
      // To trace mouse hit position.
      pickingPositionTracer = new Mesh( new SphereGeometry( 2 ), new ColorMaterial( 0x00FF00, 0.5 ) );
      pickingPositionTracer.visible = false;
      pickingPositionTracer.mouseEnabled = false;
      scene.addChild(pickingPositionTracer);

      // To trace picking normals.
      pickingNormalTracer = new SegmentSet();
      pickingNormalTracer.mouseEnabled = pickingNormalTracer.mouseChildren = false;
      var lineSegment:LineSegment = new LineSegment( new Vector3D(), new Vector3D(), 0xFFFFFF, 0xFFFFFF, 3 );
      pickingNormalTracer.addSegment( lineSegment );
      pickingNormalTracer.visible = false;
      view.scene.addChild( pickingNormalTracer );

      // Load a head model that we will be able to paint on on mouse down.
      var parser:OBJParser = new OBJParser( 25 );
      parser.addEventListener( AssetEvent.ASSET_COMPLETE, onAssetComplete );
      parser.parseAsync( new HeadAsset() );

      // Produce a bunch of objects to be around the scene.
      createABunchOfObjects();
    }

    private function onAssetComplete( event:AssetEvent ):void {
      if( event.asset.assetType == AssetType.MESH ) {
        initializeHeadModel( event.asset as Mesh );
      }
    }

    private function initializeHeadModel( model:Mesh ):void {

      head = model;

      // Apply a bitmap material that can be painted on.
      var bmd:BitmapData = new BitmapData( PAINT_TEXTURE_SIZE, PAINT_TEXTURE_SIZE, false, 0xFF0000 );
      bmd.perlinNoise( 50, 50, 8, 1, false, true, 7, true );
      var bitmapTexture:BitmapTexture = new BitmapTexture( bmd );
      var textureMaterial:TextureMaterial = new TextureMaterial( bitmapTexture );
      textureMaterial.lightPicker = lightPicker;
      model.material = textureMaterial;

      // Set up a ray picking collider.
      // The head model has quite a lot of triangles, so its best to use pixel bender for ray picking calculations.
      // NOTE: Pixel bender will not produce faster results on devices with only one cpu core, and will not work on iOS.
      model.pickingCollider = PickingColliderType.PB_BEST_HIT;
//      model.pickingCollider = PickingColliderType.PB_FIRST_ENCOUNTERED; // is faster, but causes weirdness around the eyes

      // Apply mouse interactivity.
      model.mouseEnabled = model.mouseChildren = model.shaderPickingDetails = true;
      enableMeshMouseListeners( model );

      view.scene.addChild( model );
    }

    private function createABunchOfObjects():void {

      cubeGeometry = new CubeGeometry( 25, 25, 25 );
      sphereGeometry = new SphereGeometry( 12 );
      cylinderGeometry = new CylinderGeometry( 12, 12, 25 );
      torusGeometry = new TorusGeometry( 12, 12 );

      for( var i:uint; i < 40; i++ ) {

        // Create object.
        var object:Mesh = createSimpleObject();

        // Random orientation.
        object.rotationX = 360 * Math.random();
        object.rotationY = 360 * Math.random();
        object.rotationZ = 360 * Math.random();

        // Random position.
        var r:Number = 200 + 100 * Math.random();
        var azimuth:Number = 2 * Math.PI * Math.random();
        var elevation:Number = 0.25 * Math.PI * Math.random();
        object.x = r * Math.cos(elevation) * Math.sin(azimuth);
        object.y = r * Math.sin(elevation);
        object.z = r * Math.cos(elevation) * Math.cos(azimuth);
      }
    }

    private function createSimpleObject():Mesh {

      var geometry:Geometry;
      var bounds:BoundingVolumeBase;

      // Chose a random geometry.
      var randGeometry:Number = Math.random();
      if( randGeometry > 0.75 ) {
        geometry = cubeGeometry;
      }
      else if( randGeometry > 0.5 ) {
        geometry = sphereGeometry;
        bounds = new BoundingSphere(); // better on spherical meshes with bound picking colliders
      }
      else if( randGeometry > 0.25 ) {
        geometry = cylinderGeometry;

      }
      else {
        geometry = torusGeometry;
      }

      var mesh:Mesh = new Mesh(geometry);

      if (bounds)
        mesh.bounds = bounds;

      // For shader based picking.
      mesh.shaderPickingDetails = true;

      // Randomly decide if the mesh has a triangle collider.
      var usesTriangleCollider:Boolean = Math.random() > 0.5;
      if( usesTriangleCollider ) {
        // AS3 triangle pickers for meshes with low poly counts are faster than pixel bender ones.
//        mesh.pickingCollider = PickingColliderType.BOUNDS_ONLY; // this is the default value for all meshes
        mesh.pickingCollider = PickingColliderType.AS3_FIRST_ENCOUNTERED;
//        mesh.pickingCollider = PickingColliderType.AS3_BEST_HIT; // slower and more accurate, best for meshes with folds
//        mesh.pickingCollider = PickingColliderType.AUTO_FIRST_ENCOUNTERED; // automatically decides when to use pixel bender or actionscript
      }

      // Enable mouse interactivity?
      var isMouseEnabled:Boolean = Math.random() > 0.25;
      mesh.mouseEnabled = mesh.mouseChildren = isMouseEnabled;

      // Enable mouse listeners?
      var listensToMouseEvents:Boolean = Math.random() > 0.25;
      if( isMouseEnabled && listensToMouseEvents ) {
        enableMeshMouseListeners( mesh );
      }

      // Apply material according to the random setup of the object.
      choseMeshMaterial( mesh );

      // Add to scene and store.
      view.scene.addChild( mesh );

      return mesh;
    }

    private function choseMeshMaterial( mesh:Mesh ):void {
      if( !mesh.mouseEnabled ) {
        mesh.material = blackMaterial;
      }
      else {
        if( !mesh.hasEventListener( MouseEvent3D.MOUSE_MOVE ) ) {
          mesh.material = grayMaterial;
        }
        else {
          if( mesh.pickingCollider != PickingColliderType.BOUNDS_ONLY ) {
            mesh.material = redMaterial;
          }
          else {
            mesh.material = blueMaterial;
          }
        }
      }
    }

    /**
     * Initialise the listeners
     */
    private function initListeners():void
    {
      addEventListener(Event.ENTER_FRAME, onEnterFrame);
      view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
      view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
      stage.addEventListener(Event.RESIZE, onResize);
      stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
      stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
      onResize();
    }
    private function onResize(event:Event = null):void
    {
      view.width = stage.stageWidth;
      view.height = stage.stageHeight;
    }

    /**
     * Navigation and render loop
     */
    private function onEnterFrame(event:Event):void
    {
      // Update camera.
      if (move) {
        cameraController.panAngle = 0.3*(stage.mouseX - lastMouseX) + lastPanAngle;
        cameraController.tiltAngle = 0.3*(stage.mouseY - lastMouseY) + lastTiltAngle;
      }
      cameraController.panAngle += panIncrement;
      cameraController.tiltAngle += tiltIncrement;
      cameraController.distance += distanceIncrement;

      // Move light with camera.
      pointLight.position = camera.position;

      // Render 3D.
      view.render();
    }

    /**
     * Key down listener for camera control
     */
    private function onKeyDown(event:KeyboardEvent):void
    {
      switch (event.keyCode) {
        case Keyboard.UP:
        case Keyboard.W:
          tiltIncrement = tiltSpeed;
          break;
        case Keyboard.DOWN:
        case Keyboard.S:
          tiltIncrement = -tiltSpeed;
          break;
        case Keyboard.LEFT:
        case Keyboard.A:
          panIncrement = panSpeed;
          break;
        case Keyboard.RIGHT:
        case Keyboard.D:
          panIncrement = -panSpeed;
          break;
        case Keyboard.Z:
          distanceIncrement = distanceSpeed;
          break;
        case Keyboard.X:
          distanceIncrement = -distanceSpeed;
          break;
      }
    }

    /**
     * Key up listener for camera control
     */
    private function onKeyUp(event:KeyboardEvent):void
    {
      switch (event.keyCode) {
        case Keyboard.UP:
        case Keyboard.W:
        case Keyboard.DOWN:
        case Keyboard.S:
          tiltIncrement = 0;
          break;
        case Keyboard.LEFT:
        case Keyboard.A:
        case Keyboard.RIGHT:
        case Keyboard.D:
          panIncrement = 0;
          break;
        case Keyboard.Z:
        case Keyboard.X:
          distanceIncrement = 0;
          break;
      }
    }

    /**
     * Mouse stage leave listener for navigation
     */
    private function onStageMouseLeave(event:Event):void
    {
      move = false;
      stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }


    /**
     * Mouse up listener for navigation
     */
    private function onMouseUp(event:MouseEvent):void
    {
      move = false;
      stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    /**
     * Mouse down listener for navigation
     */
    private function onMouseDown(event:MouseEvent):void
    {
      move = true;
      lastPanAngle = cameraController.panAngle;
      lastTiltAngle = cameraController.tiltAngle;
      lastMouseX = stage.mouseX;
      lastMouseY = stage.mouseY;
      stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
    }

    // ---------------------------------------------------------------------
    // 3D mouse event handlers.
    // ---------------------------------------------------------------------

    protected function enableMeshMouseListeners( mesh:Mesh ):void {
      mesh.addEventListener( MouseEvent3D.MOUSE_OVER, onMeshMouseOver );
      mesh.addEventListener( MouseEvent3D.MOUSE_OUT, onMeshMouseOut );
      mesh.addEventListener( MouseEvent3D.MOUSE_MOVE, onMeshMouseMove );
      mesh.addEventListener( MouseEvent3D.MOUSE_DOWN, onMeshMouseDown );
    }

    /**
     * mesh listener for mouse down interaction
     */
    private function onMeshMouseDown( event:MouseEvent3D ):void {
      var mesh:Mesh = event.object as Mesh;
      // Paint on the head's material.
      if( mesh == head ) {
        var uv:Point = event.uv;
        var textureMaterial:TextureMaterial = Mesh( event.object ).material as TextureMaterial;
        var bmd:BitmapData = BitmapTexture( textureMaterial.texture ).bitmapData;
        var x:uint = uint( PAINT_TEXTURE_SIZE * uv.x );
        var y:uint = uint( PAINT_TEXTURE_SIZE * uv.y );
        var matrix:Matrix = new Matrix();
        matrix.translate( x, y );
        bmd.draw( painter, matrix );
        BitmapTexture( textureMaterial.texture ).invalidateContent();
      }
    }

    /**
     * mesh listener for mouse over interaction
     */
    private function onMeshMouseOver(event:MouseEvent3D):void
    {
      var mesh:Mesh = event.object as Mesh;
      mesh.showBounds = true;
      if( mesh != head ) mesh.material = whiteMaterial;
      pickingPositionTracer.visible = pickingNormalTracer.visible = true;
      onMeshMouseMove(event);
    }

    /**
     * mesh listener for mouse out interaction
     */
    private function  onMeshMouseOut(event:MouseEvent3D):void
    {
      var mesh:Mesh = event.object as Mesh;
      mesh.showBounds = false;
      if( mesh != head ) choseMeshMaterial( mesh );
      pickingPositionTracer.visible = pickingNormalTracer.visible = false;
      pickingPositionTracer.position = new Vector3D();
    }

    /**
     * mesh listener for mouse move interaction
     */
    private function  onMeshMouseMove(event:MouseEvent3D):void
    {
      // Show tracers.
      pickingPositionTracer.visible = pickingNormalTracer.visible = true;

      // Update position tracer.
      pickingPositionTracer.position = event.scenePosition;

      // Update normal tracer.
      pickingNormalTracer.position = pickingPositionTracer.position;
      var normal:Vector3D = event.sceneNormal.clone();
      normal.scaleBy( 25 );
      var lineSegment:LineSegment = pickingNormalTracer.getSegment( 0 ) as LineSegment;
      lineSegment.end = normal.clone();
    }
  }
}
