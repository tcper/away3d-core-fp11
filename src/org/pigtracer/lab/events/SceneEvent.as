package org.pigtracer.lab.events
{
  import flash.events.Event;

  /**
   * @author loki
   */
  public class SceneEvent extends Event
  {
    public static const CHANGE_SCENE:String = "changeScene";
    public function SceneEvent(type:String, index:int)
    {
      super(type, true);
      _index = index;
    }
    //----------------------------------
    //  index
    //----------------------------------
    private var _index:int;
    public function get index():int {
      return _index;
    }

    override public function clone():Event
    {
      return new SceneEvent(type, _index);
    }

  }
}
