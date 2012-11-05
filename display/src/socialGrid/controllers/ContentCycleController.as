package socialGrid.controllers {
  
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  import flash.utils.Dictionary;
  
  import socialGrid.core.Locator;
  import socialGrid.models.programs.BaseProgram;
  import socialGrid.models.programs.InterstitialProgram;
  import socialGrid.models.programs.LayoutProgram;
  import socialGrid.models.programs.RandomProgram;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.util.RandomHelper;
  import socialGrid.views.contentViews.BaseContentView;
  import socialGrid.views.layouts.BaseLayout;
  import socialGrid.views.layouts._3x3_2x2_1x1s_Layout;
  import socialGrid.views.layouts._5x3_ImageLayout;
  import socialGrid.views.layouts._5x3_VideoLayout;
  
  public class ContentCycleController {
    
    public var waitingOnDisplayForNextProgram:Boolean;
    
    protected var programs:Dictionary;
    public var currentProgram:BaseProgram; // program that is currently waiting or active
    
    protected var nextLayoutType:String;
    
    public var waitingSpecialContentViews:Array; // special sized content views awaiting display during random
    public var waitingLayout:BaseLayout; // layout view awaiting display
    
    
    public var currentTransitionDirection:String;
    
    public var currentContentViewForInterstitial:BaseContentView;
    protected var currentInterstitialBmd:BitmapData;
    
    protected var calendarIndex:int;
    
    public function ContentCycleController() {
      
      programs = new Dictionary();
      programs['random'] = new RandomProgram();
      programs['interstitial'] = new InterstitialProgram();
      programs['layout'] = new LayoutProgram();
      
      waitingSpecialContentViews = new Array();
    }
    
    public function start():void {
      var program:BaseProgram = programs['layout'];
      makeWaitingLayout();
      program.init();
      startProgram(program);
    }
    
    
    // PROGRAM CYCLE
    
    protected function startProgram(program:BaseProgram):void {
      currentProgram = program;
      checkCurrentProgram();
    }
    
    public function onTilesOpen():void { // called by content display controller
      checkCurrentProgram();
    }
    
    protected function checkCurrentProgram():void {
      if (!currentProgram) { return; }
      
      //trace('checking current program : ' + currentProgram.programType + ' is ' + currentProgram.status);
      
      switch (currentProgram.status) {
        case 'waiting':
          // check to see if it can start
          currentProgram.checkReadyToStart();
          break;
        case 'active':
          // check to see if it can finish
          currentProgram.checkReadyToFinish();
          break;
      }
    }
    
    public function onCurrentProgramFinished():void {
      startNextProgram();
    }
    
    protected function startNextProgram():void {
      
      var oldProgram:BaseProgram = currentProgram;
      currentProgram = null;
      
      var nextProgram:BaseProgram;
      
      switch (oldProgram.programType) {
        case 'random': // goes to interstitial or continues random
          var num5x3:int = Locator.instance.appModel.contentModel.getNumContentVOs(new ContentQuery({size:'5x3'}));
          if (num5x3) {
            nextProgram = programs['interstitial'];
            nextProgram.init();
          } else {
            nextProgram = programs['random'];
            nextProgram.init();
          }
          break;
        case 'interstitial': // always goes to layout
          nextProgram = programs['layout'];
          makeWaitingLayout();
          nextProgram.init();
          break;
        case 'layout': // always goes to random
          nextProgram = programs['random'];
          nextProgram.init();
          break;
      }
      
      startProgram(nextProgram);
    }
    
    // called when layout program starts and interstitial program ends
    public function chooseTransitionDirection():void {
      var transitionDirections:Array = ['right', 'down', 'left', 'up'];
      var oldTransitionDirection:String = currentTransitionDirection;
      do {
        currentTransitionDirection = transitionDirections[Math.floor(Math.random() * 4)];
      } while (currentTransitionDirection == oldTransitionDirection);
      Locator.instance.ui.gridView.setTransitionDirection(currentTransitionDirection);
    }
    
    // called when interstitial program starts
    public function chooseInterstitial():void {
      var contentQuery:ContentQuery = new ContentQuery({size:'5x3'});
      currentContentViewForInterstitial = ContentHelper.createContentViewFromQuery(contentQuery, '5x3');
      if (currentContentViewForInterstitial) {
        currentInterstitialBmd = currentContentViewForInterstitial.bitmapData;
      } else {
        trace('no interstitial content available');
        currentInterstitialBmd = new BitmapData(1280, 768, true, 0xff000000);
      }
    }
    
    
    // CREATION AND DESTRUCTION
    
    public function makeWaitingLayout():void {
      if (waitingLayout) { return; }
      
      switch (RandomHelper.getWeightedIndex([3, 1])) {
        case 0:
          waitingLayout = new _3x3_2x2_1x1s_Layout();
          break;
        case 1:
          waitingLayout = new _5x3_ImageLayout();
          break;
      }
      
      // backup
      var contentView:BaseContentView;
      if (!waitingLayout || !waitingLayout.hasContent) {
        if (waitingLayout) {
          // destroy the content views belonging to it
          for each (contentView in waitingLayout.contentViews) {
            ContentHelper.destroyContentView(contentView);
          }
        }
        waitingLayout = new _5x3_VideoLayout();
      }
    }
    
    public function refillWaitingContentViews():void {
      var numAttempts:int = 0;
      while (numAttempts < 1 && waitingSpecialContentViews.length < 1) {
        makeWaitingContentView();
        numAttempts++;
      }
    }
    
    protected function makeWaitingContentView():void {
      var contentQuery:ContentQuery = new ContentQuery({size:'2x2'});
      var contentView:BaseContentView = ContentHelper.createContentViewFromQuery(contentQuery, '2x2');
      if (contentView) {
        waitingSpecialContentViews.push(contentView);
      } else {
        trace('cannot make waiting content view');
      }
    }
    
    public function createContentViewAt(gridX:int, gridY:int, withInterstitial:Boolean = false):BaseContentView {
      
      var contentQuery:ContentQuery;
      var contentView:BaseContentView;
      
      if (withInterstitial) {
        var bmd:BitmapData = new BitmapData(256, 256, true, 0xffffffff);
        bmd.draw(currentInterstitialBmd, new Matrix(1, 0, 0, 1, -256 * gridX, -256 * gridY));
        contentView = ContentHelper.createInterstitialContentView(bmd, '1x1');
        bmd.dispose();
      } else {
        switch (RandomHelper.getWeightedIndex([1, 4, 1, 2])) {
          case 0:
            // prefer twitter
            contentQuery = new ContentQuery({contentType:'twitter', size:'1x1'});
            break;
          case 1:
            // prefer instagram
            contentQuery = new ContentQuery({contentType:'instagram', size:'1x1'});
            break;
          case 2:
            // prefer video
            contentQuery = new ContentQuery({contentType:'user_video', size:'1x1'});
            break;
          case 3:
            // no preference
            contentQuery = new ContentQuery({size:'1x1'});
            break;
        }
        contentView = ContentHelper.createContentViewFromQuery(contentQuery, '1x1');
        
        // backup
        if (!contentView) {
          contentQuery = new ContentQuery({size:'1x1'});
          contentView = ContentHelper.createContentViewFromQuery(contentQuery, '1x1');
        }
      }
      
      // set coordinates
      contentView.gridX = gridX;
      contentView.gridY = gridY;
      
      return contentView;
    }
  }
}