package socialGrid.models.posts
{
  import flash.display.BitmapData;
  
  import socialGrid.util.DateHelper;
  
  public class BasePostVO
  {
    public var postType:String;
    public var hashtags:Array;
    
    public var postId:String;
    public var postTimestamp:Number;
    public var postDateTime:String;
    
    public function BasePostVO() {
      
      hashtags = new Array();
    }
    
    public function normalizeData():void {
      
      // make all hashtags lowercase
      var i:int;
      for (i = 0; i < hashtags.length; i++) {
        hashtags[i] = hashtags[i].toLowerCase();
      }
      
      // create date time
      if (postTimestamp) {
        postDateTime = DateHelper.getStandardTimeFromTimestamp(postTimestamp);
      }
    }
    
    public function dispose():void {
      // override in subclass
    }
  }
}