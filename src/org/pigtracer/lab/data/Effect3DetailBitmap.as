package org.pigtracer.lab.data
{
  import flash.display.Sprite;
  import flash.display.Bitmap;
  /**
   * @author loki
   */
  public class Effect3DetailBitmap{

    [Embed(source="../bitmaps/detail.png")]
    private var detailClass : Class;


    public var detailButton:Sprite;


    /**
     * Construct a <code>Effect3DetailBitmap</code>.
     */
    public function Effect3DetailBitmap() {
      detailButton = new Sprite();
      detailButton.buttonMode = true;
      detailButton.addChild(new detailClass());

    }
  }
}
