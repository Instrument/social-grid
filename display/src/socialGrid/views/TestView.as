package socialGrid.views {
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.KeyboardEvent;
  import flash.events.MouseEvent;
  import flash.geom.Matrix;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  import socialGrid.util.ContentHelper;
  
  public class TestView extends Sprite {
    
    public function TestView() {
      
      if (stage) {
        init(null);
      } else {
        addEventListener(Event.ADDED_TO_STAGE, init);
      }
    }
    
    private function init(e:Event):void {
      
      makeTestViews();
      
      //addTestClicker();
      
      // frame listener
      //addEventListener(Event.ENTER_FRAME, frameListener);
      
      // key listener
      //stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownListener);
    }
    
    
    
    public function addTestClicker():void {
      var clicker:Sprite = new Sprite();
      addChild(clicker);
      with (clicker.graphics) {
        beginFill(0xff0000, 0);
        drawRect(0, 0, 1280, 768);
        endFill();
      }
      clicker.addEventListener(MouseEvent.CLICK, clickerClickListener);
    }
    
    public function clickerClickListener(e:MouseEvent):void {
      var gridX:int = Math.floor(mouseX / 256);
      var gridY:int = Math.floor(mouseY / 256);
    }
    
    public function makeTestViews():void {
      
      // make canvas
      
      var bmp:Bitmap = new Bitmap();
      addChild(bmp);
      bmp.bitmapData = new BitmapData(1280, 768, true, 0x00000000);
      
      // make fake data
      
      var twitterPostVO:TwitterPostVO = new TwitterPostVO();
      twitterPostVO.tweetText = 'PASSION PIT IS GOING TO BE A GREAT SHOW. CHECK OUT THEIR LATEST VIDEO: HTTP://T.CO/II7IMCHF';
      twitterPostVO.postTimestamp = new Date().time;
      twitterPostVO.authorHandle = '@PRISCILABACELAR';
      twitterPostVO.authorName = 'PRICILA R BACELAR';
      twitterPostVO.normalizeData();
      var twitterContentVO:TwitterContentVO = new TwitterContentVO(twitterPostVO);
      
      var instagramPostVO:InstagramPostVO = new InstagramPostVO();
      instagramPostVO.authorHandle = '@Swedeman';
      instagramPostVO.caption = 'WHAT A FESTIVAL, WILL DEFINITELY BE BACK #NEXTYEAR! IF MY MESSAGE GOES @MULTIPLE LINES THAT’S http://OK.com. THE MAX  NUMBER OF LINES IS 3 I THINK. BEYOND THAT WE will cut it short.';
      instagramPostVO.imageData = Locator.instance.appModel.assetsModel.testImage768;
      var instagramContentVO:InstagramContentVO = new InstagramContentVO(instagramPostVO);
      
      // draw stuff
      
      bmp.bitmapData.draw(twitterContentVO.renderedData('3x3'), new Matrix(1, 0, 0, 1, 0, 0));
      bmp.bitmapData.draw(instagramContentVO.renderedData('2x2'), new Matrix(1, 0, 0, 1, 768, 0));
      bmp.bitmapData.draw(twitterContentVO.renderedData('1x1'), new Matrix(1, 0, 0, 1, 768, 512));
      
    }
    
    protected function keyDownListener(e:KeyboardEvent):void {
      
      //trace(e.keyCode);
      
      var keyCode:uint;
      switch (e.keyCode) {
        case 32: // Space
          keyCode = e.keyCode;
          break;
      }
      
      if (!keyCode) { return; }
      
      e.preventDefault();
      e.stopImmediatePropagation();
      
      switch (keyCode) {
        
        case 32: // Space
          //Locator.instance.contentCycleController.makeWaitingContentView();
          break;
      }
    }
    
    protected function frameListener(e:Event):void {
      graphics.clear();
      var gridX:int;
      var gridY:int;
      var contentView:ContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          contentView = Locator.instance.contentDisplayController.getContentViewAt(gridX, gridY);
          if (!contentView) {
            with (graphics) {
              beginFill(0xff0000, 0.5);
              drawRect(256 * gridX, 256 * gridY, 256, 256);
              endFill();
            }
          } else {
            if (contentView.hasDisplayed) {
              with (graphics) {
                beginFill(0x00ff00, 0.5);
                drawRect(256 * gridX, 256 * gridY, 256, 256);
                endFill();
              }
            } else {
              with (graphics) {
                beginFill(0x0000ff, 0.5);
                drawRect(256 * gridX, 256 * gridY, 256, 256);
                endFill();
              }
            }
          }
        }
      }
    }
  }
}