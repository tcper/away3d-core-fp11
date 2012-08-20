package org.pigtracer.lab.managers
{
  /**
   * @author loki
   */
  public class LightsManager
  {
    private static var instance:LightsManager;

    /**
     * Construct a <code>LightsManager</code>.
     */
    public function LightsManager(value:aaa) {
    }

    public var mainMessageLights:SceneLights = new SceneLights();

    public static function getInstance():LightsManager {
      if (!instance) {
        instance = new LightsManager(new aaa());
      }
      return instance;
    }
  }
}
class aaa{}