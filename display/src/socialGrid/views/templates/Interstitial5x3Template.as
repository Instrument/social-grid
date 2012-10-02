package socialGrid.views.templates {
  
  import flash.display.Bitmap;
  import flash.display.BlendMode;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InterstitialContentVO;
  import socialGrid.util.BitmapResizer;
  import socialGrid.util.StyledTextField;
  
  public class Interstitial5x3Template extends BaseGridTemplate {
    
    protected var image:Bitmap;
    protected var vignette:Bitmap;
    
    protected var titleTF:StyledTextField;
    
    public function Interstitial5x3Template() {
      
      image = new Bitmap();
      addChild(image);
      
      vignette = new Bitmap();
      addChild(vignette);
      vignette.bitmapData = Locator.instance.appModel.assetsModel.vignette1280x768;
      vignette.blendMode = BlendMode.MULTIPLY;
      vignette.alpha = 0.54;
      
      titleTF = new StyledTextField('interstitial-title');
      addChild(titleTF);
      titleTF.x = 75;
      titleTF.y = 475 - 19;
      titleTF.width = 768;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var interstitialContentVO:InterstitialContentVO = contentVO as InterstitialContentVO;
      
      image.bitmapData = BitmapResizer.resizeBitmapData(interstitialContentVO.imageData, 1280, 768);
      
      titleTF.text = interstitialContentVO.title.toUpperCase();
    }
  }
}