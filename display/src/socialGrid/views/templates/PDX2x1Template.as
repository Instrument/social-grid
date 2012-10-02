package socialGrid.views.templates {
  
  import flash.display.Bitmap;
  import flash.display.Shape;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.PDXContentVO;
  import socialGrid.util.BitmapResizer;
  import socialGrid.util.StyledTextField;
  
  public class PDX2x1Template extends BaseGridTemplate {
    
    protected var image:Bitmap;
    protected var arrow:Shape;
    
    protected var nameTF:StyledTextField;
    protected var descriptionTF:StyledTextField;
    protected var dateTimeTF:StyledTextField;
    protected var venueTF:StyledTextField;
    
    public function PDX2x1Template() {
      
      with (graphics) {
        beginBitmapFill(Locator.instance.appModel.assetsModel.bluePanel1x1);
        drawRect(256, 0, 256, 256);
        endFill();
      }
      
      image = new Bitmap();
      addChild(image);
      
      arrow = new Shape();
      addChild(arrow);
      arrow.x = 240;
      arrow.y = 59;
      with (arrow.graphics) {
        beginFill(0x2f5d74, 1);
        moveTo(0, 16);
        lineTo(16, 0);
        lineTo(16, 32);
        lineTo(0, 16);
        endFill();
      }
      
      nameTF = new StyledTextField('pdx-name');
      addChild(nameTF);
      nameTF.x = 256 + 15;
      nameTF.y = 10;
      nameTF.width = 224;
      
      descriptionTF = new StyledTextField('pdx-description');
      addChild(descriptionTF);
      descriptionTF.x = 256 + 15
      descriptionTF.width = 224;
      
      dateTimeTF = new StyledTextField('pdx-date-time');
      addChild(dateTimeTF);
      dateTimeTF.x = 256 + 17;
      dateTimeTF.width = 224;
      
      venueTF = new StyledTextField('pdx-venue');
      addChild(venueTF);
      venueTF.x = 256 + 17;
      venueTF.width = 224;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var pdxContentVO:PDXContentVO = contentVO as PDXContentVO;
      
      image.bitmapData = BitmapResizer.resizeBitmapData(pdxContentVO.imageData, 256);
      
      nameTF.text = pdxContentVO.speakerName.toUpperCase();
      
      descriptionTF.text = pdxContentVO.speakerDescription.toUpperCase();
      descriptionTF.y = nameTF.y + nameTF.leadingTextHeight + 4;
      
      venueTF.text = pdxContentVO.speakerVenue.toUpperCase();
      venueTF.y = 256 - venueTF.leadingTextHeight - 20;
      
      dateTimeTF.text = pdxContentVO.speakerDateTime.toUpperCase();
      dateTimeTF.y = venueTF.y - dateTimeTF.leadingTextHeight - 1;
    }
  }
}