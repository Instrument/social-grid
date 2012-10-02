package socialGrid.controllers {
  
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.geom.Matrix;
  import flash.utils.Dictionary;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserContentVO;
  import socialGrid.models.programs.BaseProgram;
  import socialGrid.models.programs.InterstitialProgram;
  import socialGrid.models.programs.LayoutProgram;
  import socialGrid.models.programs.RandomProgram;
  import socialGrid.util.ContentHelper;
  import socialGrid.util.ContentQuery;
  import socialGrid.views.ContentView;
  import socialGrid.views.layouts.BaseLayout;
  import socialGrid.views.layouts.CalendarLayout;
  import socialGrid.views.layouts.TweetsLayout;
  import socialGrid.views.layouts._3x3_2x2_1x1s_Layout;
  import socialGrid.views.layouts._3x3_2x3_Layout;
  import socialGrid.views.layouts._5x3_Layout;
  
  public class ContentCycleController {
    
    public var waitingOnDisplayForNextProgram:Boolean;
    
    protected var programs:Dictionary;
    public var currentProgram:BaseProgram; // program that is currently waiting or active
    
    protected var nextLayoutType:String;
    
    public var waitingSpecialContentViews:Array; // special sized content views awaiting display during random
    public var waitingLayout:BaseLayout; // layout view awaiting display
    
    
    public var currentTransitionDirection:String;
    
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
      var program:BaseProgram = programs['random'];
      //makeWaitingLayout();
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
        case 'interstitial': // goes to either layout or random
          if (1) {
            nextProgram = programs['layout'];
            makeWaitingLayout();
            nextProgram.init();
          } else {
            nextProgram = programs['random'];
            nextProgram.init();
          }
          break;
        case 'layout': // goes to either layout or random
          if (0) {
            nextProgram = programs['layout'];
            makeWaitingLayout();
            nextProgram.init();
          } else {
            nextProgram = programs['random'];
            nextProgram.init();
          }
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
      
      var userContentVO:UserContentVO = Locator.instance.appModel.contentModel.getContentVO(new ContentQuery({size:'5x3'})) as UserContentVO;
      if (userContentVO) {
        currentInterstitialBmd = userContentVO.imageData;
      } else {
        currentInterstitialBmd = new BitmapData(1280, 768, true, 0xff000000);
      }
    }
    
    
    // CREATION AND DESTRUCTION
    
    public function makeWaitingLayout():void {
      if (waitingLayout) { return; }
      
      waitingLayout = new _5x3_Layout();
      return;
      
      /*
      switch (Math.floor(Math.random() * 7)) {
        case 0:
        case 1:
        case 2:
          waitingLayout = new _3x3_2x3_Layout();
          break;
        case 3:
        case 4:
        case 5:
          waitingLayout = new _3x3_2x2_1x1s_Layout();
          break;
        case 6:
          waitingLayout = null; // makes a calendar layout
          break;
      }
      
      var numMFNWContent:int = Locator.instance.appModel.contentModel.getNumContentVOs(
        new ContentQuery({contentType: 'mfnw', matchActiveContent: true, matchDisplayedContent: true})
      );
        
      var contentView:ContentView;
      if (!waitingLayout || !waitingLayout.hasContent) {
        if (waitingLayout) {
          // destroy the content views belonging to it
          for each (contentView in waitingLayout.contentViews) {
            ContentHelper.destroyContentView(contentView);
          }
        }
        
        waitingLayout = new CalendarLayout(calendarIndex);
        calendarIndex += 15;
        if (calendarIndex > numMFNWContent - 1) {
          calendarIndex = 0;
        }
      }
      */
    }
    
    public function refillWaitingContentViews():void {
      while (waitingSpecialContentViews.length < 1) {
        makeWaitingContentView();
      }
    }
    
    protected function makeWaitingContentView():void {
      
      var contentQuery:ContentQuery;
      var contentView:ContentView;
      
      while (!contentView) {
        switch (Math.floor(Math.random() * 2)) {
          case 0:
            // make it a 2x1
            contentView = ContentHelper.createContentView(
              new ContentQuery({size:'2x1'}),
              '2x1',
              ContentHelper.getDisplayTimeBySize('2x1')
            );
            break;
          case 1:
            // make it a 2x2 with preferred instagram
            contentQuery = new ContentQuery({contentType:'instagram', size:'2x2'});
            contentQuery.secondaryParamQueue.push({matchDisplayedContent:true});
            contentQuery.secondaryParamQueue.push({contentType:'mfnw'});
            contentQuery.secondaryParamQueue.push({contentType:'any'});
            contentView = ContentHelper.createContentView(
              contentQuery,
              '2x2',
              ContentHelper.getDisplayTimeBySize('2x2')
            );
            break;
        }
      }
      
      waitingSpecialContentViews.push(contentView);
    }
    
    public function createContentViewAt(gridX:int, gridY:int, withInterstitial:Boolean = false):ContentView {
      
      var contentQuery:ContentQuery;
      var contentView:ContentView;
      
      if (withInterstitial) {
        var bmd:BitmapData = new BitmapData(256, 256, true, 0xffffffff);
        bmd.draw(currentInterstitialBmd, new Matrix(1, 0, 0, 1, -256 * gridX, -256 * gridY));
        contentView = ContentHelper.createNonContentView(bmd, '1x1', 500);
        contentView.isInterstitialPiece = true;
        bmd.dispose();
      } else {
        switch (Math.floor(Math.random() * 7)) {
          case 0:
            // prefer twitter
            contentQuery = new ContentQuery({contentType:'twitter', size:'1x1'});
            contentQuery.secondaryParamQueue.push({matchDisplayedContent:true});
            contentQuery.secondaryParamQueue.push({contentType:'instagram'});
            contentQuery.secondaryParamQueue.push({contentType:'any'});
            contentView = ContentHelper.createContentView(
              contentQuery,
              '1x1',
              ContentHelper.getDisplayTimeBySize('1x1')
            );
            break;
          case 1:
          case 2:
          case 3:
          case 4:
          case 5:
          case 6:
            // prefer instagram or mfnw
            contentQuery = new ContentQuery({contentType:'instagram', size:'1x1'});
            contentQuery.secondaryParamQueue.push({matchDisplayedContent:true});
            contentQuery.secondaryParamQueue.push({contentType:'mfnw'});
            contentQuery.secondaryParamQueue.push({contentType:'any'});
            contentView = ContentHelper.createContentView(
              contentQuery,
              '1x1',
              ContentHelper.getDisplayTimeBySize('1x1')
            );
            break;
        }
      }
      
      contentView.gridX = gridX;
      contentView.gridY = gridY;
      
      return contentView;
    }
  }
}