package org.pigtracer.lab.primitive {
  import flash.geom.Vector3D;
  /**
   * @author loki
   */
  public class CameraPos {
    public static const MAIN_SCENE:Vector3D = new Vector3D(0, 300, 600);
    public static const MAIN_SCENE_LOOKAT:Vector3D = new Vector3D(0, 0, 0);

    public static const S1:Vector3D = new Vector3D(0, 2000, 600);
    public static const S1_LOOKAT:Vector3D = new Vector3D(0, 2000, 0);

    public static const S4:Vector3D = new Vector3D(0, 2000, 0);
    public static const S4_LOOKAT_0:Vector3D = new Vector3D(0, 2000, 0);
    public static const S4_LOOKAT_1:Vector3D = new Vector3D(0, 2000, -1000);
    public static const S4_LOOKAT_2:Vector3D = new Vector3D(0, 2000, -2000);

    public static const S4_0:Vector3D = new Vector3D(0, 2000, 600);
    public static const S4_1:Vector3D = new Vector3D(0, 2000, 1600);
    public static const S4_2:Vector3D = new Vector3D(0, 2000, 2600);
    public static const S4_POS:Vector.<Vector3D> = new <Vector3D>[S4_0,S4_1,S4_2];
    public static const S4_LOOKAT_POS:Vector.<Vector3D> = new <Vector3D>[S4_LOOKAT_0,S4_LOOKAT_1,S4_LOOKAT_2];
  }
}
