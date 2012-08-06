package org.pigtracer.lab.primitive
{
  import away3d.materials.MaterialBase;

  /**
   * @author loki
   */
  public class DotMaterial extends MaterialBase
  {
    private var _screenPass:DotPass;

    public function DotMaterial()
    {
      super();

      bothSides = true;
      addPass(_screenPass = new DotPass());
      _screenPass.material = this;
    }
  }
}
