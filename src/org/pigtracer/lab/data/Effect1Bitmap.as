package org.pigtracer.lab.data
{
  import flash.display.Bitmap;
  import flash.display.Sprite;
  /**
   * @author loki
   */
  public class Effect1Bitmap
  {
    [Embed(source="../bitmaps/imagination.png")]
    private var embeddedClass : Class;

    public function getImage():Sprite {
      var s:Sprite = new Sprite();
      s.mouseChildren = false;
      s.mouseEnabled = false;

      var content:Bitmap = new embeddedClass();
      content.x = -content.width/2;
      content.y = -content.height/2;
      s.addChild(content);

      return s;
    }

    public function getBitmap():Bitmap {
      return new embeddedClass();
    }
  }
}
