package socialGrid.views.templates {
  
  import flash.display.Bitmap;
  import flash.display.BlendMode;
  import flash.display.Sprite;
  
  import socialGrid.assets.SocialGridAssets;
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.util.BitmapResizer;
  import socialGrid.util.Highlighter;
  import socialGrid.util.StyledTextField;
  
  
  public class Instagram2x2Template extends BaseGridTemplate {
    
    protected var bmp:Bitmap;
    protected var vignette:Bitmap;
    
    protected var metaTF:StyledTextField;
    protected var captionTF:StyledTextField;
    
    public function Instagram2x2Template() {
      
      bmp = new Bitmap();
      addChild(bmp);
      
      vignette = new SocialGridAssets.vignette512();
      addChild(vignette);
      vignette.blendMode = BlendMode.MULTIPLY;
      
      metaTF = new StyledTextField('instagram-meta');
      addChild(metaTF);
      metaTF.x = 54;
      metaTF.width = 420;
      
      captionTF = new StyledTextField('instagram-caption');
      addChild(captionTF);
      captionTF.x = 53;
      captionTF.width = 420;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var instagramContentVO:InstagramContentVO = contentVO as InstagramContentVO;
      
      bmp.bitmapData = BitmapResizer.resizeBitmapData(instagramContentVO.imageData, 512);
      
      if (instagramContentVO.caption) {
        
        captionTF.text = Highlighter.highlightSocial(instagramContentVO.caption).toUpperCase();
        captionTF.y = 512 - captionTF.leadingTextHeight - 53;
      }
      
      // [(!)] limit caption tf to 3 lines
      
      metaTF.text = instagramContentVO.authorHandle.toUpperCase() + '<highlight> / via Instagram</highlight>';;
      metaTF.y = captionTF.y - metaTF.leadingTextHeight;
      
    }
  }
}