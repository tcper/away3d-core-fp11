package org.pigtracer.lab
{
  import flash.display.BitmapData;

  import com.adobe.images.PNGEncoder;

  import flash.events.Event;
  import flash.display.Loader;
  import flash.utils.ByteArray;
  import flash.filesystem.FileStream;
  import flash.filesystem.FileMode;
  import flash.filesystem.File;
  import flash.display.Sprite;

  /**
   * @author loki
   */
  public class Test6 extends Sprite
  {
    public function Test6()
    {
      var file:File = File.documentsDirectory.resolvePath("./aa");
      var fs:FileStream = new FileStream();
      var bmd:BitmapData = new BitmapData(100, 100);
      bmd.perlinNoise(50, 50, 8, 1, false, true, 7, true);

      var imageBytes:ByteArray = PNGEncoder.encode(bmd);
      var data:ByteArray = new ByteArray();
      data.writeByte(4);
      data.writeUnsignedInt(imageBytes.length);
      data.writeBytes(imageBytes);
      try
      {
         fs.open(file, FileMode.WRITE);
         fs.writeBytes(data);

        fs.open(file, FileMode.READ);
        if (fs.bytesAvailable > 0)
        {
          var type:uint = fs.readByte();
          var len:uint = fs.readUnsignedInt();
          trace(type, len);
          trace("fs.position", fs.position);

          var image:ByteArray = new ByteArray();
          fs.readBytes(image, 0, len);
          image.position = 0;
          trace("image.bytesAvailable",image.bytesAvailable);

          var loader:Loader = new Loader();
          loader.contentLoaderInfo.addEventListener(Event.COMPLETE, load_completeHandler);
          loader.loadBytes(image);

        }
        fs.close();

      }
      catch (e:Error)
      {
      }
    }

    private function load_completeHandler(event:Event):void
    {
      trace("[Test6/load_completeHandler]");
      addChild(event.target.loader);
    }
  }
}
