package socialGrid.views.templates {
  
  import flash.display.BlendMode;
  import flash.display.Shape;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.util.GradientHelper;
  import socialGrid.util.Highlighter;
  import socialGrid.util.StyledTextField;
  
  public class Twitter1x1Template extends BaseGridTemplate {
    
    protected var textTF:StyledTextField;
    protected var authorHandleTF:StyledTextField;
    protected var metaTF:StyledTextField;
    
    public function Twitter1x1Template() {
      
      with (graphics) {
        beginFill(Locator.instance.appModel.config.twitterBackgroundColor, 1);
        drawRect(0, 0, 256, 256);
        endFill();
      }
      
      var fade:Shape = new Shape();
      addChild(fade);
      GradientHelper.drawCornerToCornerFade(fade.graphics, 0, 0, 256, 256);
      fade.alpha = 0.1;
      fade.blendMode = BlendMode.MULTIPLY;
      
      textTF = new StyledTextField('twitter-text');
      addChild(textTF);
      textTF.x = 15;
      textTF.y = 12;
      textTF.width = 224;
      
      authorHandleTF = new StyledTextField('twitter-author');
      addChild(authorHandleTF);
      authorHandleTF.x = 17;
      authorHandleTF.width = 236;
      
      metaTF = new StyledTextField('twitter-meta');
      addChild(metaTF);
      metaTF.x = 17;
      metaTF.width = 224;
    }
    
    override public function populate(contentVO:BaseContentVO):void {
      var twitterContentVO:TwitterContentVO = contentVO as TwitterContentVO;
      
      textTF.text = Highlighter.highlightSocial(twitterContentVO.tweetText).toUpperCase();
      
      metaTF.text = twitterContentVO.postDateTime.toUpperCase();
      metaTF.y = 256 - metaTF.leadingTextHeight - 22;
      
      authorHandleTF.text = twitterContentVO.authorHandle.toUpperCase();
      authorHandleTF.y = metaTF.y - authorHandleTF.leadingTextHeight;
    }
  }
}