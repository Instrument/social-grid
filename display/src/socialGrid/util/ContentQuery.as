package socialGrid.util {
  import socialGrid.models.content.BaseContentVO;
  
  public class ContentQuery {
    
    // QUERY PARAMS
    
    public var matchActiveContent:Boolean; // whether to match content that is being actively diplayed
    public var matchDisplayedContent:Boolean; // whether to match content that has already been displayed
    
    public var size:String;
    public var contentType:String;
    public var notContentType:String;
    
    public var random:Boolean; // when returning just one match, whether to pick randomly
    public var index:int;
    
    // RECURSIVE SECONDARY PARAMS
    
    public var secondaryParamQueue:Array;
    
    public function ContentQuery(params:Object = null) {
      // defaults
      matchActiveContent = false;
      matchDisplayedContent = false;
      
      size = 'any';
      contentType = 'any';
      notContentType = 'none';
      
      random = true;
      index = -1;
      
      secondaryParamQueue = new Array();
      
      // params
      if (params) {
        parseParams(params);
      }
    }
    
    public function parseParams(params:Object):void {
      if (params.hasOwnProperty('matchActiveContent')) {
        matchActiveContent = params.matchActiveContent;
      }
      if (params.hasOwnProperty('matchDisplayedContent')) {
        matchDisplayedContent = params.matchDisplayedContent;
      }
      if (params.hasOwnProperty('size')) {
        size = params.size;
      }
      if (params.hasOwnProperty('contentType')) {
        contentType = params.contentType;
      }
      if (params.hasOwnProperty('notContentType')) {
        notContentType = params.notContentType;
      }
      if (params.hasOwnProperty('random')) {
        random = params.random;
      }
      if (params.hasOwnProperty('index')) {
        index = params.index;
      }
    }
  }
}