package org.pigtracer.lab.data
{
  import flash.display.DisplayObject;
  /**
   * @author loki
   */
  public class SubtitleBitmaps
  {
    [Embed(source="../bitmaps/s1.png")]
    private var labelClass1 : Class;

    [Embed(source="../bitmaps/s2.png")]
    private var labelClass2 : Class;

    [Embed(source="../bitmaps/s3.png")]
    private var labelClass3 : Class;

    [Embed(source="../bitmaps/s4.png")]
    private var labelClass4 : Class;

    /**
     * Construct a <code>SubtitleBitmaps</code>.
     */

   public const SUB:Array = [];

    public function SubtitleBitmaps() {
      for (var i:int = 1; i <= 4; i++) {
        var className:String = "labelClass" + String(i);
        var clazz:Class = this[className] as Class;
        var content:DisplayObject = new clazz();
        SUB.push(content);
      }
    }
  }
}
