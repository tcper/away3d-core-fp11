package org.pigtracer.lab.primitive {
  import away3d.containers.ObjectContainer3D;
  import flash.utils.Dictionary;
  import away3d.events.MouseEvent3D;
  import away3d.entities.Mesh;
  /**
   * @author loki
   */
  public class MainCubeListener {
    /**
     * Construct a <code>MainCubeListener</code>.
     */

    public function MainCubeListener(meshList:Vector.<Mesh>, container:ObjectContainer3D) {
      if (!meshList) {
        return;
      }
      this.container = container;
      this.meshList = meshList;
      initEffect();
      
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        mesh.mouseEnabled = true;
        meshMap[mesh] = i;
        mesh.addEventListener(MouseEvent3D.MOUSE_DOWN, meshMouseDownHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OVER, meshMouseOverHandler);
        mesh.addEventListener(MouseEvent3D.MOUSE_OUT, meshMouseOutHandler);
      }
    }

    public function disableMesh():void {
      manipulateMesh(false);
    }
    
    public function enableMesh():void {
      manipulateMesh(true);
    }
    
    

    
    private var meshMap:Dictionary = new Dictionary();
    private var container:ObjectContainer3D;
    private var meshList:Vector.<Mesh>;

    private var effect1:Effect1;
    private var effect2:Effect2;
    private var effect3:Effect3;
    
    private function manipulateMesh(value:Boolean):void {
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        mesh.mouseEnabled = value;
      }
    }

    private function meshMouseOutHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
    }

    private function meshMouseOverHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
      
    }

    private function meshMouseDownHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
      switch (index) {
        case 0:
          effect1.start();
          break;
        default:
          break;
      }
    }

    private function initEffect():void {
      effect1 = new Effect1();
      container.addChild(effect1);
      
      var temp:MainMessage = container as MainMessage;
      effect2 = new Effect2(temp);
    }
  }
}
