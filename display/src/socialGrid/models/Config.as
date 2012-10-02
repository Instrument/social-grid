package socialGrid.models {
  import socialGrid.assets.SocialGridAssets;
  
  public class Config {
    
    public var xml:XML;
    
    public var twitterTextColor:uint;
    public var twitterHighlightColor:uint;
    public var twitterBackgroundColor:uint;
    
    public var instagramTextColor:uint;
    public var instagramHighlightColor:uint;
    
    public var pullSocialDirectly:Boolean;
    
    public var twitterHashtags:Array;
    public var instagramHashtags:Array;
    
    public var backendRoot:String;
    
    public function Config() {}
    
    public function parseConfigXml(xml:XML):void {
      
      this.xml = xml;
      
      twitterTextColor = getXmlColor('twitterTextColor', 0xff0000);
      setStyleColor('.twitter-text', twitterTextColor);
      setStyleColor('.twitter-author', twitterTextColor);
      setStyleColor('.twitter-meta', twitterTextColor);
      setStyleColor('.twitter-3x3-text', twitterTextColor);
      setStyleColor('.twitter-3x3-author', twitterTextColor);
      setStyleColor('.twitter-3x3-meta', twitterTextColor);
      
      twitterHighlightColor = getXmlColor('twitterHighlightColor', 0xffffff);
      setStyleColor('.twitter-text-highlight', twitterHighlightColor);
      setStyleColor('.twitter-3x3-text-highlight', twitterHighlightColor);
      setStyleColor('.twitter-3x3-meta-highlight', twitterHighlightColor);
      
      twitterBackgroundColor = getXmlColor('twitterBackgroundColor', 0x000000);
      
      instagramTextColor = getXmlColor('instagramTextColor', 0xff0000);
      setStyleColor('.instagram-meta', instagramTextColor);
      setStyleColor('.instagram-caption', instagramTextColor);
      
      instagramHighlightColor = getXmlColor('instagramHighlightColor', 0xff0000);
      setStyleColor('.instagram-meta-highlight', instagramHighlightColor);
      setStyleColor('.instagram-caption-highlight', instagramHighlightColor);

      pullSocialDirectly = getXmlBoolean('pullSocialDirectly', true);
      
      twitterHashtags = getXmlArray('twitterHashtags', ['instrumentoutpost']);
      instagramHashtags = getXmlArray('instagramHashtags', ['instrumentoutpost']);
      
      backendRoot = getXmlString('backendRoot', 'http://ec2-50-112-66-228.us-west-2.compute.amazonaws.com:1337');
      
      //printConfig();
    }
    
    protected function printConfig():void {
      trace('twitterTextColor: ' + twitterTextColor);
      trace('twitterHighlightColor: ' + twitterHighlightColor);
      trace('twitterBackgroundColor: ' + twitterBackgroundColor);
      trace('instagramTextColor: ' + instagramTextColor);
      trace('instagramHighlightColor: ' + instagramHighlightColor);
      trace('pullSocialDirectly: ' + pullSocialDirectly);
      trace('twitterHashtags: ' + twitterHashtags);
      trace('instagramHashtags: ' + instagramHashtags);
      trace('backendRoot: ' + backendRoot);
    }
    
    protected function setStyleColor(styleName:String, color:uint):void {
      var styleObj:Object = SocialGridAssets.styleSheet.getStyle(styleName);
      styleObj.color = '#' + color.toString(16);
      SocialGridAssets.styleSheet.setStyle(styleName, styleObj);
    }
    
    protected function getXmlColor(paramName:String, defaultValue:uint):uint {
      var valueString:String = getXmlParam(paramName);
      if (valueString) {
        valueString = valueString.replace(/#/g, '0x');
        return(uint(valueString));
      } else {
        return defaultValue;
      }
    }
    
    protected function getXmlBoolean(paramName:String, defaultValue:Boolean):Boolean {
      var valueString:String = getXmlParam(paramName);
      if (valueString) {
        return(Boolean(valueString));
      } else {
        return defaultValue;
      }
    }
    
    protected function getXmlArray(paramName:String, defaultValue:Array):Array {
      var valueString:String = getXmlParam(paramName);
      if (valueString) {
        valueString = valueString.replace(/ /g, ''); // remove spaces
        return(valueString.split(','));
      } else {
        return defaultValue;
      }
    }
    
    protected function getXmlString(paramName:String, defaultValue:String):String {
      var valueString:String = getXmlParam(paramName);
      if (valueString) {
        return(valueString);
      } else {
        return defaultValue;
      }
    }
    
    protected function getXmlParam(paramName:String):String {
      if (xml.hasOwnProperty(paramName)) {
        return xml[paramName];
      }
      return null;
    }
  }
}