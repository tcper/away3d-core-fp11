package org.pigtracer.lab.data
{
  import flash.display.DisplayObject;
  import flash.display.Sprite;
  /**
   * @author loki
   */
  public class Effect4Bitmap
  {
    [Embed(source="../bitmaps/nq_en.png")]
    private var nq_enClass : Class;

    [Embed(source="../bitmaps/na_en.png")]
    private var na_enClass : Class;

    [Embed(source="../bitmaps/gq_en.png")]
    private var gq_enClass : Class;

    [Embed(source="../bitmaps/ga_en.png")]
    private var ga_enClass : Class;

    [Embed(source="../bitmaps/cq_en.png")]
    private var cq_enClass : Class;

    [Embed(source="../bitmaps/ca_en.png")]
    private var ca_enClass : Class;

    [Embed(source="../bitmaps/nq_cn.png")]
    private var nq_cnClass : Class;

    [Embed(source="../bitmaps/na_cn.png")]
    private var na_cnClass : Class;

    [Embed(source="../bitmaps/gq_cn.png")]
    private var gq_cnClass : Class;

    [Embed(source="../bitmaps/ga_cn.png")]
    private var ga_cnClass : Class;

    [Embed(source="../bitmaps/cq_cn.png")]
    private var cq_cnClass : Class;

    [Embed(source="../bitmaps/ca_cn.png")]
    private var ca_cnClass : Class;

    [Embed(source="../bitmaps/go.png")]
    private var goClass : Class;

    /**
     * Construct a <code>Effect4Bitmap</code>.
     */
    public function Effect4Bitmap() {
      var nameList:Array = ["n", "g", "c"];
      var qaList:Array = ["q", "a"];
      var langList:Array = ["en", "cn"];
      const LN:int = langList.length;
      const TN:int = nameList.length;
      const QN:int = qaList.length;


      for (var i:int = 0; i < TN; i++) {
        var sceneLabels:Array = [];
        for (var j:int = 0; j < LN; j++) {
          for (var k:int = 0; k < QN; k++) {
            var className:String = nameList[i] + qaList[k] + "_" + langList[j] + "Class";
            var clazz:Class = this[className] as Class;
            var content:DisplayObject = new clazz();

            var container:Sprite = new Sprite();
            container.mouseChildren = false;
            container.mouseEnabled = false;

            /*content.x = 20;
            if (k%2 == 0) {
              content.y = content.width / 2;
            } else {
              content.y = 20;
            }*/
            container.addChild(content);

            sceneLabels.push(container);
          }
        }
        allData.push(sceneLabels);
      }

      goButton = new Sprite();
      goButton.buttonMode = true;
      goButton.addChild(new goClass());
    }

    public var allData:Array = [];
    public var goButton:Sprite;

    public function getLabelsByScene(index:int):Array {
      if (index < 0 || index >= allData.length) {
        return null;
      }
      return allData[index];
    }
  }
}
