package org.pigtracer.lab.data
{
  /**
   * @author loki
   */
  public class Effect2Pos
  {
    public var source:Array = [[ -284 , -178 ],
                              [ -24 , 243 ],
                              [ 258 , -160 ],
                              [ 63 , -129 ],
                              [ 111 , 85 ],
                              [ -145 , 0 ],
                              [ -248 , 274 ],
                              [ 0 , 0 ],
                              [ 258 , 274 ]];

    public function getPos(index:int):Array {
      return source[index];
    }
  }
}
