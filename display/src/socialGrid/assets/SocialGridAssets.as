package socialGrid.assets {
  
  import flash.text.Font;
  import flash.text.StyleSheet;
  
  public class SocialGridAssets {
    
    // fonts
    
    [Embed(
			source="../../embed/fonts/lorimer/LorimerNo2CondensedMedium.otf",
			fontName="LorimerNo2CondensedMedium",
			fontStyle="normal",
			fontWeight = "normal",
			embedAsCFF = "false",
			mimeType="application/x-font-truetype"
		)]
    public static var LorimerNo2CondensedMedium:Class;
    
    // css
    
    [Embed(source="../../embed/css/styles.css", mimeType="application/octet-stream")]
    public static var stylesCSS:Class;
    
    // images
    
    [Embed (source="../../embed/images/vignette512.png" )]
    public static var vignette512:Class;
    
    // pixel bender
    
    [Embed(source = '../../embed/pb/Tint.pbj', mimeType = 'application/octet-stream')]
    public static var TintShader:Class;
    
    // class properties
    
    protected static var initialized:Boolean;
    
    public static var styleSheet:StyleSheet;
    
    // INIT
    
    public static function init():void {
      
      if (!initialized) {
        Font.registerFont(LorimerNo2CondensedMedium);
        
        styleSheet = new StyleSheet();
        styleSheet.parseCSS(new stylesCSS().toString());
        
        initialized = true;
      }
    }
  }
}