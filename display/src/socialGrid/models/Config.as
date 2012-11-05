package socialGrid.models {
  import socialGrid.assets.SocialGridAssets;
  
  public class Config {
    
    public var xml:XML;
    
    // properties
    
    public var loadingBackgroundColor:uint;
    public var loadingCircleColor:uint;
    public var loadingIconColor:uint;
    public var loadingTextColor:uint;
    
    public var twitterTextColor:uint;
    public var twitterHighlightColor:uint;
    public var twitterBackgroundColor:uint;
    
    public var largeTwitterTextColor:uint;
    public var largeTwitterHighlightColor:uint;
    public var largeTwitterBackgroundColor:uint;
    
    public var instagramTextColor:uint;
    public var instagramHighlightColor:uint;
    
    public var pullSocialDirectly:Boolean;
    
    public var twitterHashtags:Array;
    public var instagramHashtags:Array;
    
    public var backendRoot:String;
    
    public var photoboothFolderPath:String;
    
    public function Config() {}
    
    public function parseConfigXml(xml:XML):void {
      
      this.xml = xml;
      
      loadingBackgroundColor = getXmlColor('loadingBackgroundColor', 0xefefef);
      loadingCircleColor = getXmlColor('loadingCircleColor', 0x3bb3c5);
      loadingIconColor = getXmlColor('loadingIconColor', 0x0a201d);
      loadingTextColor = getXmlColor('loadingTextColor', 0x080808);
      setStyleColor('.app-loading-text', loadingTextColor);
      
      // twitter
      
      twitterTextColor = getXmlColor('twitterTextColor', 0x7c7c7c);
      setStyleColor('.twitter-text', twitterTextColor);
      setStyleColor('.twitter-author', twitterTextColor);
      setStyleColor('.twitter-meta', twitterTextColor);
      
      twitterHighlightColor = getXmlColor('twitterHighlightColor', 0x1babbe);
      setStyleColor('.twitter-text-highlight', twitterHighlightColor);
      
      twitterBackgroundColor = getXmlColor('twitterBackgroundColor', 0xf2f2f2);
      
      // large twitter
      
      largeTwitterTextColor = getXmlColor('largeTwitterTextColor', 0x7c7c7c);
      setStyleColor('.twitter-3x3-text', largeTwitterTextColor);
      setStyleColor('.twitter-3x3-author', largeTwitterTextColor);
      setStyleColor('.twitter-3x3-meta', largeTwitterTextColor);
      
      largeTwitterHighlightColor = getXmlColor('largeTwitterHighlightColor', 0x1babbe);
      setStyleColor('.twitter-3x3-text-highlight', largeTwitterHighlightColor);
      setStyleColor('.twitter-3x3-meta-highlight', largeTwitterHighlightColor);
      
      largeTwitterBackgroundColor = getXmlColor('largeTwitterBackgroundColor', 0xf2f2f2);
      
      // instagram
      
      instagramTextColor = getXmlColor('instagramTextColor', 0xf2f2f2);
      setStyleColor('.instagram-meta', instagramTextColor);
      setStyleColor('.instagram-caption', instagramTextColor);
      
      instagramHighlightColor = getXmlColor('instagramHighlightColor', 0x1babbe);
      setStyleColor('.instagram-meta-highlight', instagramHighlightColor);
      setStyleColor('.instagram-caption-highlight', instagramHighlightColor);

      pullSocialDirectly = getXmlBoolean('pullSocialDirectly', true);
      
      twitterHashtags = getXmlArray('twitterHashtags', []);
      instagramHashtags = getXmlArray('instagramHashtags', []);
      
      backendRoot = getXmlString('backendRoot', 'http://ec2-50-112-66-228.us-west-2.compute.amazonaws.com:1337');
      
      photoboothFolderPath = getXmlString('photoboothFolderPath', 'resources/photobooth');
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
        return(valueString == 'true');
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