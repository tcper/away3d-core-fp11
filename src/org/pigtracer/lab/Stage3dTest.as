package org.pigtracer.lab
{
  import flash.geom.Point;
  import flash.geom.Rectangle;
  import flash.display.BitmapData;
  import com.adobe.utils.PerspectiveMatrix3D;
  import flash.display3D.textures.Texture;
  import flash.display.Sprite;
  import com.adobe.utils.AGALMiniAssembler;

  import flash.display.Bitmap;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display3D.Context3D;
  import flash.display3D.Context3DProgramType;
  import flash.display3D.Context3DTextureFormat;
  import flash.display3D.Context3DVertexBufferFormat;
  import flash.display3D.IndexBuffer3D;
  import flash.display3D.Program3D;
  import flash.display3D.VertexBuffer3D;
  import flash.events.Event;
  import flash.geom.Matrix3D;
  import flash.geom.Vector3D;
  import flash.utils.getTimer;
  public class Stage3dTest extends Sprite
  {
    [Embed( source = "a.png" )]
    protected const TextureBitmap:Class;
    protected var context3D:Context3D;
    protected var vertexbuffer:VertexBuffer3D;
    protected var indexBuffer:IndexBuffer3D;
    protected var program:Program3D;
    protected var texture:Texture;
    protected var projectionTransform:PerspectiveMatrix3D;

    public function Stage3dTest()
    {
      stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, initMolehill);
      stage.stage3Ds[0].requestContext3D();
      stage.scaleMode = StageScaleMode.NO_SCALE;
      stage.align = StageAlign.TOP_LEFT;
      addEventListener(Event.ENTER_FRAME, onRender);
    }

    protected function initMolehill(e:Event):void
    {
      context3D = stage.stage3Ds[0].context3D;
      context3D.configureBackBuffer(800, 600, 1, true);

      var vertices:Vector.<Number> = Vector.<Number>([-0.3, -0.3, 0, 0, 0, // x, y, z, u, v
      -0.3, 0.3, 0, 0, 1, 0.3, 0.3, 0, 1, 1, 0.3, -0.3, 0, 1, 0]);

      // 4 vertices, of 5 Numbers each
      vertexbuffer = context3D.createVertexBuffer(4, 5);
      // offset 0, 4 vertices
      vertexbuffer.uploadFromVector(vertices, 0, 4);

      // total of 6 indices. 2 triangles by 3 vertices each
      indexBuffer = context3D.createIndexBuffer(6);

      // offset 0, count 6
      indexBuffer.uploadFromVector(Vector.<uint>([0, 1, 2, 2, 3, 0]), 0, 6);

      const SIZE:int = 256;
      var bs:BitmapData = new BitmapData(SIZE, SIZE);
      var bm:Bitmap = new TextureBitmap();
      bs.copyPixels(bm.bitmapData, new Rectangle(0, 0, SIZE, SIZE), new Point());

      var bitmap:Bitmap = new Bitmap(bs);
      texture = context3D.createTexture(bitmap.bitmapData.width, bitmap.bitmapData.height, Context3DTextureFormat.BGRA, false);
      texture.uploadFromBitmapData(bitmap.bitmapData);

      var vertexShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
      vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,
                                                                  "m44 op, va0, vc0\n" + // pos to clipspace
                                                                  "mov v0, va1"// copy uv
                                                                  );
      var fragmentShaderAssembler:AGALMiniAssembler = new AGALMiniAssembler();
      fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,
                                                                    "tex ft1, v0, fs0 <2d,linear,nomip>\n" +
                                                                    "mov oc, ft1");

      program = context3D.createProgram();
      program.upload(vertexShaderAssembler.agalcode, fragmentShaderAssembler.agalcode);

      projectionTransform = new PerspectiveMatrix3D();
      var aspect:Number = 4 / 3;
      var zNear:Number = 0.1;
      var zFar:Number = 1000;
      var fov:Number = 45 * Math.PI / 180;
      projectionTransform.perspectiveFieldOfViewLH(fov, aspect, zNear, zFar);
    }

    protected function onRender(e:Event):void
    {
      if ( !context3D )
        return;

      context3D.clear(1, 1, 1, 1);

      // vertex position to attribute register 0
      context3D.setVertexBufferAt(0, vertexbuffer, 0, Context3DVertexBufferFormat.FLOAT_3);
      // uv coordinates to attribute register 1
      context3D.setVertexBufferAt(1, vertexbuffer, 3, Context3DVertexBufferFormat.FLOAT_2);
      // assign texture to texture sampler 0
      context3D.setTextureAt(0, texture);
      // assign shader program
      context3D.setProgram(program);

      var m:Matrix3D = new Matrix3D();
      m.appendRotation(getTimer() / 30, Vector3D.Y_AXIS);
      m.appendRotation(getTimer() / 10, Vector3D.X_AXIS);
      m.appendTranslation(0, 0, 2);
      m.append(projectionTransform);

      context3D.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, m, true);

      context3D.drawTriangles(indexBuffer);

      context3D.present();
    }
  }
}