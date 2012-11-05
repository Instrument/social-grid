package socialGrid.util {
  
  public class ContentQuery {
    
    // query params
    
    public var matchActiveContent:Boolean; // whether to match content that is being actively diplayed
    public var favorLeastDisplayedContent:Boolean; // whether to favor content that has been displayed least number of times
    
    public var size:String;
    public var contentType:String; // type of content to match
    public var notContentType:String; // type of content to avoid
    
    public var random:Boolean; // when returning just one match, whether to pick randomly
    public var index:int;
    
    // recursive secondary params
    
    public var secondaryParamQueue:Array; // sequential query options to try if initial query doesn't return any matches
    
    public function ContentQuery(params:Object = null) {
      
      secondaryParamQueue = new Array();
      
      // defaults
      matchActiveContent = false;
      favorLeastDisplayedContent = true;
      size = 'any';
      contentType = 'any';
      notContentType = 'none';
      random = true;
      index = -1;
      
      // apply params
      if (params) {
        parseParams(params);
      }
      
      // default to match active content as backup
      //secondaryParamQueue.push({matchActiveContent:true});
    }
    
    public function parseParams(params:Object):void {
      var paramName:String;
      for(paramName in params) {
        if (this.hasOwnProperty(paramName)) {
          this[paramName] = params[paramName];
        } else {
          trace('cannot interpret content query param ' + paramName);
        }
      }
    }
  }
}