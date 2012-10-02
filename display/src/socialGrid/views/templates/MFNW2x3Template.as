package socialGrid.views.templates {
  import flash.display.Bitmap;
  import flash.display.BlendMode;
  import flash.display.Shape;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.MFNWContentVO;
  import socialGrid.util.BitmapResizer;
  import socialGrid.util.MFNWContentColors;
  import socialGrid.util.StyledTextField;
  
  public class MFNW2x3Template extends BaseGridTemplate {
    
    protected var image:Bitmap;
    protected var vignette:Bitmap;
    protected var overlay:Shape;
    protected var arrow:Shape;
    
    protected var nameTF:StyledTextField;
    protected var metaTF:StyledTextField;
    
    public function MFNW2x3Template() {
      
      with (graphics) {
        beginBitmapFill(Locator.instance.appModel.assetsModel.bluePanel2x1);
        drawRect(0, 512, 512, 256);
        endFill();
      }
      
      image = new Bitmap();
      addChild(image);
      
      vignette = new Bitmap();
      addChild(vignette);
      vignette.bitmapData = Locator.instance.appModel.assetsModel.vignette512;
      vignette.blendMode = BlendMode.MULTIPLY;
      vignette.alpha = 0.75;
      
      overlay = new Shape();
      addChild(overlay);
      
      arrow = new Shape();
      addChild(arrow);
      arrow.x = 44;
      arrow.y = 512;
      with (arrow.graphics) {
        beginFill(0x276076, 1);
        moveTo(0, 0);
        lineTo(24, -24);
        lineTo(48, 0);
        lineTo(0, 0);
        endFill();
      }
      
      nameTF = new StyledTextField('mfnw-2x3-name');
      addChild(nameTF);
      nameTF.x = 46;
      nameTF.width = 400;
      
      metaTF = new StyledTextField('mfnw-2x3-meta');
      addChild(metaTF);
      metaTF.x = 48;
      metaTF.width = 440;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var mfnwContentVO:MFNWContentVO = contentVO as MFNWContentVO;
      
      /*
      var overlayColor:Object = MFNWContentColors.getNextColor();
      with (overlay.graphics) {
      beginFill(overlayColor.color, 1);
      drawRect(0, 0, 512, 512);
      endFill();
      }
      overlay.blendMode = overlayColor.blendMode;
      overlay.alpha = overlayColor.alpha;
      */
      
      image.bitmapData = BitmapResizer.resizeBitmapData(mfnwContentVO.imageData, 512);
      
      nameTF.text = mfnwContentVO.artistName.toUpperCase();
      nameTF.y = 512 + 24;
      
      metaTF.text = mfnwContentVO.showDateTime.toUpperCase() + ', ' + mfnwContentVO.showVenue.toUpperCase();
      metaTF.y = nameTF.y + nameTF.leadingTextHeight + 17 - 5;
    }
  }
}