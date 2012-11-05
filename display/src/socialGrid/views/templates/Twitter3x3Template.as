package socialGrid.views.templates {
  
  import flash.display.BlendMode;
  import flash.display.Shape;
  
  import socialGrid.assets.SocialGridAssets;
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.util.GradientHelper;
  import socialGrid.util.Highlighter;
  import socialGrid.util.StyledTextField;
  
  public class Twitter3x3Template extends BaseGridTemplate {
    
    protected var textTF:StyledTextField;
    protected var authorHandleTF:StyledTextField;
    protected var metaTF:StyledTextField;
    
    public function Twitter3x3Template() {
      
      with (graphics) {
        beginFill(Locator.instance.appModel.config.largeTwitterBackgroundColor, 1);
        drawRect(0, 0, 786, 768);
        endFill();
      }
      
      var fade:Shape = new Shape();
      addChild(fade);
      //GradientHelper.drawCornerToCornerFade(fade.graphics, 0, 0, 786, 768);
      with (fade.graphics) {
        beginBitmapFill(new SocialGridAssets.shade768().bitmapData);
        drawRect(0, 0, 768, 768);
        endFill();
      }
      fade.blendMode = BlendMode.MULTIPLY;
      fade.alpha = 0.1;
      
      textTF = new StyledTextField('twitter-3x3-text');
      addChild(textTF);
      textTF.x = 37;
      textTF.width = 676;
      
      authorHandleTF = new StyledTextField('twitter-3x3-author');
      addChild(authorHandleTF);
      authorHandleTF.x = 40;
      authorHandleTF.width = 676;
      
      metaTF = new StyledTextField('twitter-3x3-meta');
      addChild(metaTF);
      metaTF.x = 40;
      metaTF.width = 676;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var twitterContentVO:TwitterContentVO = contentVO as TwitterContentVO;
      
      textTF.text = Highlighter.highlightSocial(twitterContentVO.tweetText).toUpperCase();
      textTF.y = 160;
      
      authorHandleTF.text = twitterContentVO.authorHandle.toUpperCase();
      authorHandleTF.y = textTF.y + textTF.leadingTextHeight + 34;
      
      metaTF.text = twitterContentVO.postDateTime.toUpperCase() + '<highlight> / via Twitter</highlight>';
      metaTF.y = authorHandleTF.y + authorHandleTF.leadingTextHeight;
      
      // [(!)] needs logic to keep from overflowing!
    }
  }
}