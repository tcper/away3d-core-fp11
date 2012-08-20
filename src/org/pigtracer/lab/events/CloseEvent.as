package org.pigtracer.lab.events
{
  import flash.events.Event;

  /**
   * @author loki
   */
  public class CloseEvent extends Event
  {
    public static const CLOSE_SCENE:String = "closeScene";
    public function CloseEvent(type:String)
    {
      super(type, true);
    }

    override public function clone():Event
    {
      return new CloseEvent(type);
    }
  }
}
