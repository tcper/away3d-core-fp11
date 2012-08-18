package org.pigtracer.lab.utils
{
  import flash.events.TimerEvent;
  import flash.utils.Timer;
  import flash.geom.Vector3D;
  import away3d.cameras.Camera3D;
  /**
   * @author loki
   */
  public class CameraUtil
  {
    private var _target:Camera3D;
    private var _track:Vector.<Vector3D>;
    private var _current:uint;
    private var timer:Timer;

    public static function cameraTrack(target:Camera3D, track:Vector.<Vector3D>):CameraUtil {
      if (!track || !target) {
        return null;
      }

      if (track.length <= 0) {
        return null;
      }


      return new CameraUtil(target, track);
    }

    /**
     * Construct a <code>CameraUtil</code>.
     */
    public function CameraUtil(target:Camera3D, track:Vector.<Vector3D>) {
      _target = target;
      _track = track;
      _current = 0;

      timer = new Timer(100);
      timer.addEventListener(TimerEvent.TIMER, timerHandler);
      timer.start();
    }

    private function timerHandler(event:TimerEvent):void
    {
      if (_current + 1 >= _track.length) {
        timer.stop();
        timer.removeEventListener(TimerEvent.TIMER, timerHandler);
        timer = null;
        return;
      }
      update();
    }

    private function update():void
    {
      var next:Vector3D = _track[_current+1];
      var nextnext:Vector3D;
      if (_current + 2 >= _track.length) {
        nextnext = _track[0];
      } else {
        nextnext = _track[_current + 2];
      }
      _target.position = next;
      _target.lookAt(new Vector3D());

      _current++;
    }
  }
}
