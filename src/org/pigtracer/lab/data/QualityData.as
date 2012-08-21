package org.pigtracer.lab.data
{
  import flash.display.Sprite;
  import flash.display.DisplayObject;
  /**
   * @author loki
   */
  public class QualityData
  {
    [Embed(source="../bitmaps/l1.png")]
    private var labelClass1 : Class;

    [Embed(source="../bitmaps/l2.png")]
    private var labelClass2 : Class;

    [Embed(source="../bitmaps/l3.png")]
    private var labelClass3 : Class;

    [Embed(source="../bitmaps/l4.png")]
    private var labelClass4 : Class;

    [Embed(source="../bitmaps/l5.png")]
    private var labelClass5 : Class;

    [Embed(source="../bitmaps/l6.png")]
    private var labelClass6 : Class;

    [Embed(source="../bitmaps/l7.png")]
    private var labelClass7 : Class;

    [Embed(source="../bitmaps/l8.png")]
    private var labelClass8 : Class;

    [Embed(source="../bitmaps/l9.png")]
    private var labelClass9 : Class;


    public const CN:Array = [];

    /**
     * Construct a <code>QualityData</code>.
     */
    public function QualityData() {
      for (var i:int = 1; i <= 9; i++) {
        var className:String = "labelClass" + String(i);
        var clazz:Class = this[className] as Class;
        var content:DisplayObject = new clazz();
        var container:Sprite = new Sprite();
        container.mouseChildren = false;
        container.mouseEnabled = false;

        content.x = -content.width/2;
        content.y = -100;
        container.addChild(content);

        CN.push(container);
      }
    }

    public function getDataByType(type:int):Array {
      var clone:Array = CN.concat();
      switch (type) {
        case 0:
          return clone.slice(0, 3);
          break;
        case 1:
          return clone.slice(3, 6);
          break;
        case 2:
          return clone.slice(6, 9);
          break;
      }
      return null;
    }
  }
}
