package org.pigtracer.lab.data
{
  import flash.display.Sprite;
  /**
   * @author loki
   */
  public class Scene3Bitmap
  {
    [Embed(source="../bitmaps/back.png")]
    private var backClass : Class;

    public var backButton:Sprite;

    /**
     * Construct a <code>Scene3Bitmap</code>.
     */
    public function Scene3Bitmap() {
      backButton = new Sprite();
      backButton.buttonMode = true;
      backButton.addChild(new backClass());
    }
  }
}
