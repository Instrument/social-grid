package socialGrid.views.contentViews {
  
  import flash.display.BitmapData;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  
  public class InterstitialContentView extends BaseContentView {
    
    public function InterstitialContentView(bitmapData:BitmapData) {
      
      super(null, bitmapData, true);
      
      contentViewType = 'interstitial';
    }
    
    override public function getTimeUntilFinished():Number {
      return new Date().time - timeStarted;
    }
    
    override protected function startDisplay():void {
      //super.startDisplay();
      onDisplayComplete(); // these ones simply end as soon as they begin
    }
  }
}