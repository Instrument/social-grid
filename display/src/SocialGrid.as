package {
  
  import flash.display.Sprite;
  import flash.display.StageDisplayState;
  import flash.display.StageQuality;
  import flash.display.StageScaleMode;
  import flash.events.KeyboardEvent;
  import flash.events.Event;
  import flash.ui.Mouse;
  
  import socialGrid.assets.SocialGridAssets;
  import socialGrid.core.Locator;
  import socialGrid.views.UI;
  
  // swf settings
  [SWF(width = '1280', height = '768', backgroundColor = '#000000', frameRate = '60')]
  
  public class SocialGrid extends Sprite {
    
    protected var _mouseHidden:Boolean;
    
    public function SocialGrid() {
      
      // no stage scaling
      stage.scaleMode = StageScaleMode.NO_SCALE;
      
      // stage quality high
      stage.quality = StageQuality.HIGH;
      
      // initialize assets
      SocialGridAssets.init();
      
      // create ui
      Locator.instance.ui = new UI();
      addChild(Locator.instance.ui);
      
      // start it up!
      Locator.instance.dispatchEvent(new Event('init_app'));
      
      // key listener
      stage.addEventListener(KeyboardEvent.KEY_DOWN, coreKeyDownListener);
    }
    
    protected function coreKeyDownListener(e:KeyboardEvent):void {
      
      //trace(e.keyCode);
      
      var keyCode:uint;
      switch (e.keyCode) {
        case 77: // M
        case 70: // F
          keyCode = e.keyCode;
          break;
      }
      
      if (!keyCode) { return; }
      
      e.preventDefault();
      e.stopImmediatePropagation();
      
      switch (keyCode) {
        
        case 77: // M
          // toggle mouse visibility
          if (_mouseHidden) {
            Mouse.show();
            _mouseHidden = false;
          } else {
            Mouse.hide();
            _mouseHidden = true;
          }
          break;
        case 70: // F
          // toggle full screen
          if (stage.displayState == StageDisplayState.NORMAL) {
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
          } else {
            stage.displayState = StageDisplayState.NORMAL;
          }
          break;
      }
    }
  }
}