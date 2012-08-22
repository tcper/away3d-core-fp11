package org.pigtracer.lab.primitive {
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import org.pigtracer.lab.events.SceneEvent;
  import flash.events.EventDispatcher;
  import org.pigtracer.lab.interfaces.IEffect;
  import away3d.materials.ColorMaterial;
  import com.greensock.TweenLite;
  import org.pigtracer.lab.events.CloseEvent;
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

    public function MainCubeListener(meshList:Vector.<Mesh>,
                                     container:ObjectContainer3D,
                                     flagManager:FlagManager,
                                     closeFlag:CloseFlag,
                                     enterFrameGroup:Vector.<IUpdate>,
                                     effectList:Array) {
      if (!meshList) {
        return;
      }
      this.container = container;
      this.meshList = meshList;
      this.closeFlag = closeFlag;
      this.flagManager = flagManager;
      this.enterFrameGroup = enterFrameGroup;
      this.effectList = effectList;

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

      closeFlag.addEventListener(CloseEvent.CLOSE_SCENE, closeHandler);
      meshEnableTimer.addEventListener(TimerEvent.TIMER_COMPLETE, meshEnableHandler);
    }



    public function disableMesh():void {
      manipulateMesh(false);
    }

    public function enableMesh():void {
      manipulateMesh(true);
    }


    public var sceneDispatcher:EventDispatcher = new EventDispatcher();

    private var meshMap:Dictionary = new Dictionary();
    private var container:ObjectContainer3D;
    private var meshList:Vector.<Mesh>;
    private var closeFlag:CloseFlag;
    private var flagManager:FlagManager;
    private var enterFrameGroup:Vector.<IUpdate>;
    private var effectList:Array;

    private var effect1:Effect1;
    private var effect2:Effect2;
    private var effect3:Effect3;

    private var effectPointer:IEffect;
    private var currentIndex:int;

    private var meshEnableTimer:Timer = new Timer(3000, 1);

    private function manipulateMesh(value:Boolean):void {
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        mesh.mouseEnabled = value;
      }
    }

    private function hilight(index:int):void {
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        if (i != index) {
          var mesh:Mesh = meshList[i];
          var mat:ColorMaterial = mesh.material as ColorMaterial;
          TweenLite.to(mat, 0.5, {alpha: 0.5});
        }
      }
    }

    private function unlight():void {
      const N:int = meshList.length;
      for (var i:int = 0; i < N; i++) {
        var mesh:Mesh = meshList[i];
        var mat:ColorMaterial = mesh.material as ColorMaterial;
        TweenLite.to(mat, 0.5, {alpha: 1});
      }
    }

    private function closeHandler(event:CloseEvent):void
    {
      meshEnableTimer.reset();
      meshEnableTimer.start();
      if (effectPointer) {
        effectPointer.hide();
        if (currentIndex == 1 || currentIndex == 2) {
          removeFromGroup(effectPointer as IUpdate);
        }
      }
    }
    private function meshEnableHandler(event:TimerEvent):void
    {
      enableMesh();
      unlight();
      flagManager.unshow();
    }

    private function meshMouseOutHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
      flagManager.hide();
    }

    private function meshMouseOverHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
      flagManager.hi(index);
    }

    private function meshMouseDownHandler(event:MouseEvent3D):void {
      var mesh:Mesh = event.object as Mesh;
      var index:int = meshMap[mesh];
      currentIndex = index;

      sceneDispatcher.dispatchEvent(new SceneEvent(SceneEvent.CHANGE_SCENE, index));

      switch (index) {
        case 0:
          effect1.show();
          effectPointer = effect1;
          break;
        case 1:
          effect2.show();
          enterFrameGroup.push(effect2);
          effectPointer = effect2;
        break;
        case 2:
          effect3.show();
          enterFrameGroup.push(effect3);
          effectPointer = effect3;
        break;
      }

      closeFlag.show();
      flagManager.show(index);
      hilight(index);
      disableMesh();
    }

    private function initEffect():void {
      effect1 = effectList[0];
      effect2 = effectList[1];
      effect3 = effectList[2];
      effect3.listener = this;
      effect3.y = 200;
    }

    private function removeFromGroup(target:IUpdate):void {
      const N:int = enterFrameGroup.length;
      for (var i:int = 0; i < N; i++) {
        var compare:IUpdate = enterFrameGroup[i];
        if (compare == target) {
          enterFrameGroup.splice( i, 1 );
        }
      }
    }
  }
}
