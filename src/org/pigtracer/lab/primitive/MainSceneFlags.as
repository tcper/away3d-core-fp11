package org.pigtracer.lab.primitive {
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  import flash.geom.Vector3D;
  import away3d.containers.View3D;
  import flash.display.Graphics;
  import flash.display.Shape;
  import away3d.entities.Mesh;
  import flash.display.DisplayObjectContainer;
  import org.pigtracer.lab.primitive.IUpdate;

  /**
   * @author loki
   */
  public class MainSceneFlags implements IUpdate {
    
    /**
     * Construct a <code>MainSceneFlags</code>.
     */
    [Embed(source="../embeds/pa.png")]
    private var paClass : Class;
    [Embed(source="../embeds/pb.png")]
    private var pbClass : Class;
    [Embed(source="../embeds/pc.png")]
    private var pcClass : Class;
     
    public function MainSceneFlags(container:DisplayObjectContainer, view:View3D, meshList:Vector.<Mesh>) {
      this.container = container;
      this.meshList = meshList;
      this.view = view;
      N = meshList.length;
      init();
    }
    
    private var flagList:Vector.<Sprite> = new Vector.<Sprite>();
    private var view:View3D;
    private var N:int;

    private function init():void {
      var contentList:Array = [new paClass(), new pbClass(), new pcClass()];
      var posList:Array = [{x:-50, y:-250}, {x:0, y:-200}, {x:0, y:-200}];
      for (var i:int = 0; i < N; i++) {
        var flag:Sprite = new Sprite();
        var content:DisplayObject = contentList[i];
        var pos:Object = posList[i];
        content.x = pos.x;
        content.y = pos.y;
        flag.addChild(content);
        
        
        container.addChild(flag);
        flagList.push(flag);
      }
    }
    
    private var container:DisplayObjectContainer;
    private var meshList:Vector.<Mesh>;
    
    public function update(rateX:Number, rateY:Number):void {
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        var flag:Sprite = flagList[i];
        
        var v:Vector3D = view.project(mesh.scenePosition);
        flag.x = v.x;
        flag.y = v.y;
      }
    }
  }
}
