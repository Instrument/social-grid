package socialGrid.util {
  
  public class ContentColors {
    
    public static function getColorByType(contentType:String):uint {
      switch (contentType) {
        case 'twitter':
          return 0x2dcfff;
          break;
        case 'instagram': 
          return 0xff632d;
          break;
        case 'user_image':
          return 0x822dff;
          break;
        case 'user_video':
          return 0xff0000;
          break;
        case 'photobooth_image':
          return 0xff00ff;
          break;
        default:
          return 0x000000;
      }
    }
  }
}