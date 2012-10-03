package socialGrid.util {
  
  import flash.display.BitmapData;
  import flash.utils.Dictionary;
  
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserContentVO;
  import socialGrid.views.templates.BaseGridTemplate;
  import socialGrid.views.templates.Instagram1x1Template;
  import socialGrid.views.templates.Instagram2x2Template;
  import socialGrid.views.templates.Twitter1x1Template;
  import socialGrid.views.templates.Twitter3x3Template;
  
  public class ContentRenderer {
    
    protected static var templateDictionary:Dictionary;
    
    public function ContentRenderer() {}
    
    public static function renderTemplate(size:String, contentVO:BaseContentVO):BitmapData {
      
      if (!templateDictionary) {
        templateDictionary = new Dictionary();
        
        createTemplate('twitter', '1x1', Twitter1x1Template);
        createTemplate('twitter', '3x3', Twitter3x3Template);
        
        createTemplate('instagram', '1x1', Instagram1x1Template);
        createTemplate('instagram', '2x2', Instagram2x2Template);
      }
      
      var template:BaseGridTemplate;
      var bmd:BitmapData;
      
      // for user content
      var sizeSplit:Array;
      var userContentVO:UserContentVO;
      
      switch (contentVO.contentType) {
        case 'twitter':
        case 'instagram':
          template = templateDictionary[contentVO.contentType + size];
          template.populate(contentVO);
          bmd = new BitmapData(template.gridWidth * 256, template.gridHeight * 256, true, 0x00000000);
          bmd.draw(template);
          break;
        case 'user':
          userContentVO = contentVO as UserContentVO;
          sizeSplit = size.split('x');
          bmd = new BitmapData(sizeSplit[0] * 256, sizeSplit[1] * 256, true, 0x00000000);
          bmd.draw(BitmapResizer.resizeBitmapData(userContentVO.imageData, sizeSplit[0] * 256, sizeSplit[1] * 256));
          break;
      }
      
      return bmd;
    }
    
    protected static function createTemplate(contentType:String, size:String, templateClass:Class):void {
      var template:BaseGridTemplate = new templateClass();
      
      // set dimensions
      var sizeSplit:Array = size.split('x');
      template.gridWidth = int(sizeSplit[0]);
      template.gridHeight = int(sizeSplit[1]);
      
      templateDictionary[contentType + size] = template;
    }
  }
}