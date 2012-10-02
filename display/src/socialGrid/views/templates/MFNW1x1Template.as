package socialGrid.views.templates {
  
  import flash.display.Bitmap;
  import flash.display.Shape;
  import flash.filters.ColorMatrixFilter;
  
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.MFNWContentVO;
  import socialGrid.util.BitmapResizer;
  import socialGrid.util.MFNWContentColors;
  import socialGrid.util.StyledTextField;
  
  public class MFNW1x1Template extends BaseGridTemplate {
    
    protected var image:Bitmap;
    protected var overlay:Shape;
    
    protected var nameTF:StyledTextField;
    protected var metaTF:StyledTextField;
    
    public function MFNW1x1Template() {
      
      image = new Bitmap();
      addChild(image);
      
      var r:Number=0.212671;
      var g:Number=0.715160;
      var b:Number=0.072169;
      var matrix:Array = [
        r, g, b, 0, 0,
        r, g, b, 0, 0,
        r, g, b, 0, 0,
        0, 0, 0, 1, 0
      ];
      image.filters = [new ColorMatrixFilter(matrix)];
      
      overlay = new Shape();
      addChild(overlay);
      
      nameTF = new StyledTextField('mfnw-name');
      addChild(nameTF);
      nameTF.x = 15;
      nameTF.width = 224;
      
      metaTF = new StyledTextField('mfnw-meta');
      addChild(metaTF);
      metaTF.x = 16;
      metaTF.width = 224;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var mfnwContentVO:MFNWContentVO = contentVO as MFNWContentVO;
      
      var overlayColor:Object = MFNWContentColors.getNextColor();
      with (overlay.graphics) {
        beginFill(overlayColor.color, 1);
        drawRect(0, 0, 256, 256);
        endFill();
      }
      overlay.blendMode = overlayColor.blendMode;
      overlay.alpha = overlayColor.alpha;
      
      image.bitmapData = BitmapResizer.resizeBitmapData(mfnwContentVO.imageData, 256);
      
      metaTF.text = mfnwContentVO.showDateTime.toUpperCase() + '\n' + mfnwContentVO.showVenue.toUpperCase();
      metaTF.y = 256 - metaTF.leadingTextHeight - 20;
      
      nameTF.text = mfnwContentVO.artistName.toUpperCase();
      nameTF.y = metaTF.y - nameTF.leadingTextHeight - 8;
    }
  }
}