package org.pigtracer.lab.primitive
{
  import away3d.materials.ColorMaterial;
  import away3d.entities.Mesh;
  import away3d.materials.TextureMaterial;
  import away3d.primitives.PlaneGeometry;
  import away3d.textures.BitmapTexture;

  import flash.display.BitmapData;
  import flash.display.Graphics;
  import flash.display.Shape;
  import flash.geom.Vector3D;
  /**
   * @author loki
   */
  public class DotManager
  {
    /**
     * Construct a <code>DotManager</code>.
     */
    public function DotManager(heightMap:BitmapData) {
      _heightMap = heightMap;

      material = new ColorMaterial(0xFFFFFF);//createMaterial();

      initRenderObject();
    }

    private var _heightMap:BitmapData;
    private var _maxElevation:uint = 255;
    private var _minElevation:uint = 0;

    private var _width:Number = 1000;
    private var _height:Number = 300;

    private var material :ColorMaterial;

    //----------------------------------
    //  dotList
    //----------------------------------
    private var _dotList:Vector.<Dot> = new Vector.<Dot>();
    public function get dotList():Vector.<Dot> {
      return _dotList;
    }

    //----------------------------------
    //  renderList
    //----------------------------------
    private var _renderList:Vector.<Mesh> = new Vector.<Mesh>();
    public function get renderList():Vector.<Mesh> {
      return _renderList;
    }

    public function update():void {
      const len:int = _dotList.length;
      for (var i:int = 0; i < len; i++) {
        var dot:Dot = _dotList[i];
        updateDot(dot);
        renderObject(dot);
      }
    }

    private function updateDot(dot:Dot):void
    {
      var col:uint = 0;
      /*for (var i:int = 0; i < _heightMap.height; i++) {
        for (var j:int = 0; j < _heightMap.width; j++) {
          col = _heightMap.getPixel(j, i) & 0xff;
          dot.pos.y = (col >_maxElevation)? (_maxElevation / 0xff) * _height : ((col <_minElevation)?(_minElevation / 0xff) * _height :  (col / 0xff) * _height);
        }
      }*/

      var dy:uint = dot.index/25;
      var dx:uint = dot.index%25;
      col = _heightMap.getPixel(dx, dy) & 0xff;
      dot.pos.y = (col >_maxElevation)? (_maxElevation / 0xff) * _height : ((col <_minElevation)?(_minElevation / 0xff) * _height :  (col / 0xff) * _height);
    }

    private function renderObject(dot:Dot):void
    {
      var renderObject:Mesh = _renderList[dot.index];
      renderObject.position = dot.pos;
    }

    private function initRenderObject():void {
      var col:uint = 0;
      var dot:Dot;

      var index:int = 0;
      for (var i:int = 0; i < _heightMap.height; i+=4) {
        for (var j:int = 0; j < _heightMap.width; j+=4) {
          dot = new Dot(new Vector3D());
          _dotList.push(dot);

          col = _heightMap.getPixel(j, i) & 0xff;
          dot.pos.x =100* j/4 - 100*25/2;
          dot.pos.z =100* i/4 - 100*25/2;

          dot.pos.y = col;//(col >_maxElevation)? (_maxElevation / 0xff) * _height : ((col <_minElevation)?(_minElevation / 0xff) * _height :  (col / 0xff) * _height);
          trace(dot.pos.y);
          //dot.pos.y *= dot.pos.y * 10;

          dot.index = index++;

          var mesh:Mesh = createMesh();
          _renderList.push(mesh);

          renderObject(dot);
        }
      }
    }

    private function createMesh():Mesh
    {
      var geom:PlaneGeometry = new PlaneGeometry(10, 10);
      var mesh:Mesh = new Mesh(geom, material);
      return mesh;
    }

    private function createMaterial():TextureMaterial
    {
      var bmd:BitmapData = new BitmapData(64, 64,false, 0x00000000);
      var shape:Shape = new Shape();
      var g:Graphics = shape.graphics;
      g.beginFill(0xFFFFFF);
      g.drawCircle(32, 32, 32);
      g.endFill();
      bmd.draw(shape);

      var texture:BitmapTexture = new BitmapTexture(bmd);

      return new TextureMaterial(texture);
    }
  }
}
