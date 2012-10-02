package socialGrid.util {
  
  import flash.text.AntiAliasType;
  import flash.text.TextField;
  import flash.text.TextFieldAutoSize;
  
  import socialGrid.assets.SocialGridAssets;
  
  public class StyledTextField extends TextField {
    
    public var styleName:String;
    
    public function StyledTextField(styleName:String) {
      
      this.styleName = styleName;
      styleSheet = SocialGridAssets.styleSheet;
      
      embedFonts = true;
      antiAliasType = AntiAliasType.ADVANCED;
      
      autoSize = TextFieldAutoSize.LEFT;
      wordWrap = true;
    }
    
    override public function set text(value:String):void {
      
      if (!value) { return; }
      
      value = value.replace(/<highlight>/gi, '<span class="' + styleName + '-highlight">');
      value = value.replace(/<\/highlight>/gi, '</span>');
      
      htmlText = '<span class="' + styleName + '">' + value + '</span>';
    }
    
    public function get leadingTextHeight():Number {
      var styleObj:Object = styleSheet.getStyle('.' + styleName);
      if (
        numLines < 2 ||
        !styleObj.hasOwnProperty('leading')
      ) { return super.textHeight; }
      
      var leading:Number = Number(styleObj.leading.replace(/[pxt]/g, ''));
      return super.textHeight + leading;
    }
  }
}