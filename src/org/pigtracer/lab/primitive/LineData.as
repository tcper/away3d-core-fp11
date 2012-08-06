package org.pigtracer.lab.primitive {
  import flash.geom.Vector3D;
  /**
   * @author loki
   */
  public class LineData {
    public var start:Vector3D;
    public var end:Vector3D;

    public var color:uint;
    public var thickness:Number;
    /**
     * Construct a <code>LineData</code>.
     */
    public function LineData(v0:Vector3D, v1:Vector3D, color0:uint = 0x333333, thickness:Number = 1) {
      start = v0.clone();
      end = v1.clone();
      color = color0;
      this.thickness = thickness;
    }
  }
}
