package socialGrid.controllers {
  
  import flash.display.BitmapData;
  import flash.events.Event;
  import flash.geom.Matrix;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.ContentHelper;
  import socialGrid.views.ContentView;
  import socialGrid.views.layouts.BaseLayout;
  
  public class ContentDisplayController {
    
    public var currentContentViews:Array; // content views that are currently being displayed
    
    public function ContentDisplayController() {
      
      currentContentViews = new Array();
    }
    
    // START
    
    public function start():void {
      
      fillInitialContent();
    }
    
    
    // FILL INITIAL CONTENT
    
    protected function fillInitialContent():void {
      
      // capture loading view
      var initialBmd:BitmapData = new BitmapData(1280, 768, false, 0x00000000);
      initialBmd.draw(Locator.instance.ui.loadingView);
      
      // create initial content view
      var contentView:ContentView = ContentHelper.createNonContentView(initialBmd, '5x3', 1);
      contentView.gridX = 0;
      contentView.gridY = 0;
      
      initialBmd.dispose(); // clean up
      
      // hide loading view
      Locator.instance.ui.hideLoadingView();
      
      // display initial content views
      displayContentView(contentView, 0);
    }
    
    
    // WAITING CONTENT CHECKING
    
    protected function checkForOpeningForWaitingSpecialContentViews():void {
      
      // define all varialbes used for iteration
      
      var waitingContentView:ContentView; // the current waiting content view
      var contentView:ContentView; // any other content view
      
      var numOpenTilesNeeded:int; // number of titles belonging to the current waiting content view
      
      var gridX:int; // coordinates used for iteration through potential locations
      var gridY:int;
      var gridX2:int; // coordinates used for iteration through the tiles of a potential location
      var gridY2:int;
      
      // objects that contain the data for each location checked
      var locationSurveys:Array = new Array();
      var locationSurvey:Object;
      
      var timeUntilTileOpen:Number; // time until a particular tile will be available
      var timeUntilLocationAvailable:Number; // time until all tiles at a location will be available
      var locationTilesOpen:int; // number of tiles open at a particular location
      
      var definitiveLocationCount:int = 0; // count of locations that are certain
      
      var viewsToKeep:Array = new Array(); // displayed content views to keep from replacing
      
      // iterate through waiting content views
      for each (waitingContentView in Locator.instance.contentCycleController.waitingSpecialContentViews) {
        
        // calculate number of open tiles needed for the current waiting view
        numOpenTilesNeeded = waitingContentView.gridWidth * waitingContentView.gridHeight;
        
        // iterate through all possible grid locations for the incoming content
        for (gridY = 0; gridY < 3 + 1 - waitingContentView.gridHeight; gridY++) {
          for (gridX = 0; gridX < 5 + 1 - waitingContentView.gridWidth; gridX++) {
            
            // reset location vars
            locationTilesOpen = 0;
            timeUntilLocationAvailable = 0;
            
            // iterate through tiles at this particular grid location
            for (gridY2 = gridY; gridY2 < gridY + waitingContentView.gridHeight; gridY2++) {
              for (gridX2 = gridX; gridX2 < gridX + waitingContentView.gridWidth; gridX2++) {
                contentView = getContentViewAt(gridX2, gridY2);
                if (contentView) {
                  if (contentView.hasDisplayed) {
                    timeUntilTileOpen = 0;
                    locationTilesOpen++;
                  } else if (contentView.hasStarted) {
                    timeUntilTileOpen = contentView.displayTime - (new Date().time - contentView.timeStarted);
                  } else {
                    timeUntilTileOpen = Number.POSITIVE_INFINITY;
                  }
                } else {
                  timeUntilTileOpen = 0;
                  locationTilesOpen++;
                }
                timeUntilLocationAvailable = Math.max(timeUntilLocationAvailable, timeUntilTileOpen);
              }
            }
            
            // store location data for later logic
            locationSurveys.push({
              gridX: gridX,
              gridY: gridY,
              gridWidth: waitingContentView.gridWidth,
              gridHeight: waitingContentView.gridHeight,
              tilesOpen: locationTilesOpen,
              timeUntilAvailable: timeUntilLocationAvailable
            });
            locationSurveys.sortOn('timeUntilAvailable', Array.NUMERIC);
            
            // if match is found
            if (locationTilesOpen == numOpenTilesNeeded) {
              applyWaitingContentViewAt(waitingContentView, gridX, gridY);
              return; // only does one at a time
            }
          }
        }
        
        // store views to keep only if soonest avaliable location is definitive
        if (
          locationSurveys.length > 1 &&
          locationSurveys[0].timeUntilAvailable != Number.POSITIVE_INFINITY &&
          locationSurveys[0].timeUntilAvailable != locationSurveys[1].timeUntilAvailable
        ) {
          locationSurvey = locationSurveys[0];
          for (gridY = locationSurvey.gridY; gridY < locationSurvey.gridY + locationSurvey.gridHeight; gridY++) {
            for (gridX = locationSurvey.gridX; gridX < locationSurvey.gridX + locationSurvey.gridWidth; gridX++) {
              contentView = getContentViewAt(gridX, gridY);
              if (contentView && viewsToKeep.indexOf(contentView) == -1) {
                viewsToKeep.push(contentView);
              }
            }
          }
          definitiveLocationCount++;
        }
      } // end iterating through waiting content views
      
      // return if no views to keep were stored
      if (!viewsToKeep.length) {
        return;
      }
      
      // replace displayed content views if they were not kept
      
      // find views to replace
      var viewsToReplace:Array = new Array();
      if (definitiveLocationCount == Locator.instance.contentCycleController.waitingSpecialContentViews.length) {
        for each (contentView in currentContentViews) {
          if (contentView.hasDisplayed && viewsToKeep.indexOf(contentView) == -1) {
            viewsToReplace.push(contentView);
          }
        }
      }
      
      // make replacement views
      var replacementViews:Array = new Array();
      for each (contentView in viewsToReplace) {
        replacementViews = replacementViews.concat(replaceContentView(contentView));
      }
      
      // display replacement views
      this.displayContentViews(replacementViews);
    }
    
    protected function applyWaitingContentViewAt(waitingContentView:ContentView, gridX:int, gridY:int):void {
      
      // remove waiting view from waiting views array
      ArrayHelper.removeItemFromArray(waitingContentView, Locator.instance.contentCycleController.waitingSpecialContentViews);
      
      // must set these before finding overlapping content views
      waitingContentView.gridX = gridX;
      waitingContentView.gridY = gridY;
      
      // find overlapping content views
      var destroyReplaceTilesCoordinateObj:Object = findOverlappingViews(waitingContentView);
      
      // destroy overlapping content views
      var coordinateObj:Object;
      var contentView:ContentView;
      for each (coordinateObj in destroyReplaceTilesCoordinateObj.tilesToDestroy) {
        contentView = getContentViewAt(coordinateObj.x, coordinateObj.y);
        if (contentView) {
          destroyContentView(contentView);
        }
      }
      
      // make array for new views
      var newContentViews:Array = new Array();
      newContentViews.push(waitingContentView);
      
      // replace leftover tiles from overlapping views
      for each (coordinateObj in destroyReplaceTilesCoordinateObj.tilesToReplace) {
        newContentViews.push(Locator.instance.contentCycleController.createContentViewAt(coordinateObj.x, coordinateObj.y));
      }
      
      // replace all other content views that have already displayed
      for each (contentView in currentContentViews) {
        if (contentView.hasDisplayed) {
          newContentViews = newContentViews.concat(replaceContentView(contentView));
        }
      }
      
      // display the waiting view
      displayContentViews(newContentViews);
    }
    
    
    // DESTROY
    
    public function destroyContentView(contentView:ContentView):void {
      ArrayHelper.removeItemFromArray(contentView, currentContentViews);
      contentView.removeEventListener('content_view_displayed', contentViewDisplayedListener);
      
      // destroy it
      ContentHelper.destroyContentView(contentView);
    }
    
    
    // REPLACEMENT
    
    public function replaceFinishedContentViews(params:Object = null):void {
      
      // find views to replace
      var viewsToReplace:Array = new Array();
      var contentView:ContentView;
      for each (contentView in currentContentViews) {
        if (contentView.hasDisplayed) {
          viewsToReplace.push(contentView);
        }
      }
      
      // make replacement views
      var replacementViews:Array = new Array();
      for each (contentView in viewsToReplace) {
        replacementViews = replacementViews.concat(replaceContentView(contentView, params));
      }
      
      // display
      this.displayContentViews(replacementViews);
    }
    
    protected function replaceContentView(oldContentView:ContentView, withInterstitials:Boolean = false):Array {
      
      // make note of old content view properties
      var oldGridX:int = oldContentView.gridX;
      var oldGridY:int = oldContentView.gridY;
      var oldGridWidth:int = oldContentView.gridWidth;
      var oldGridHeight: int = oldContentView.gridHeight;
      
      // destroy old content view
      destroyContentView(oldContentView);
      
      // refill waiting content views each time a special view is replaced
      if (oldGridWidth > 1) {
        Locator.instance.contentCycleController.refillWaitingContentViews();
      }
      
      // make new content views
      var newContentViews:Array = new Array();
      var gridX:int;
      var gridY:int;
      for (gridY = oldGridY; gridY < oldGridY + oldGridHeight; gridY++) {
        for (gridX = oldGridX; gridX < oldGridX + oldGridWidth; gridX++) {
          newContentViews.push(Locator.instance.contentCycleController.createContentViewAt(gridX, gridY, withInterstitials));
        }
      }
      
      return newContentViews;
    }
    
    
    // DISPLAY
    
    protected function displayContentView(contentView:ContentView, timeFactor:Number = 1):void {
      displayContentViews([contentView], timeFactor);
    }
    
    protected function displayContentViews(contentViews:Array, timeFactor:Number = 1):void {
      var contentView:ContentView;
      for each (contentView in contentViews) {
        // add to current views array
        currentContentViews.push(contentView);
        // add displayed listener
        contentView.addEventListener('content_view_displayed', contentViewDisplayedListener);
      }
      // display
      Locator.instance.ui.gridView.displayContentViews(contentViews, timeFactor);
    }
    
    
    // ACTIONS

    public function doProgramAction():void {
      
      // get list of views that are done
      var displayedContentViews:Array = new Array();
      var contentView:ContentView;
      for each (contentView in currentContentViews) {
        if (contentView.hasDisplayed) {
          displayedContentViews.push(contentView);
        }
      }
      
      // array used if replacing views
      var replacementViews:Array;
      
      switch (Locator.instance.contentCycleController.currentProgram.programType) {
        case 'random':
          if (Locator.instance.contentCycleController.waitingSpecialContentViews.length) {
            // check availability for waiting content views
            checkForOpeningForWaitingSpecialContentViews();
          } else {
            // replace finished views randomly
            replacementViews = new Array();
            for each (contentView in displayedContentViews) {
              replacementViews = replacementViews.concat(replaceContentView(contentView));
            }
            displayContentViews(replacementViews); 
          }
          break;
        case 'interstitial':
          // replace all non-interstitial finished views with interstitials
          replacementViews = new Array();
          for each (contentView in displayedContentViews) {
          if (!contentView.isInterstitialPiece) {
            replacementViews = replacementViews.concat(replaceContentView(contentView, true));
          }
        }
          displayContentViews(replacementViews);
          break;
        case 'layout':
          // if layout program is active, the grid is open. once started, it will do this, then finish
          applyWaitingLayout();
          break;
      }
    }
    
    protected function applyWaitingLayout():void {
      
      var contentView:ContentView;
      
      // clear all current content views
      var viewsToDestroy:Array = new Array();
      for each (contentView in currentContentViews) {
        viewsToDestroy.push(contentView);
      }
      for each (contentView in viewsToDestroy) {
        destroyContentView(contentView);
      }
      
      // display all content views belonging to layout
      displayContentViews(Locator.instance.contentCycleController.waitingLayout.contentViews);
      
      // destroy waiting content view
      Locator.instance.contentCycleController.waitingLayout = null; // [(!)] memory?
    }
    
    
    // UTIL
    
    public function getNumTilesOpen():int {
      var numOpen:int = 0;
      var gridX:int;
      var gridY:int;
      var contentView:ContentView;
      for (gridY = 0; gridY < 3; gridY++) {
        for (gridX = 0; gridX < 5; gridX++) {
          contentView = getContentViewAt(gridX, gridY);
          if (!contentView || contentView.hasDisplayed) {
            numOpen++;
          }
        }
      }
      return numOpen;
    }
    
    public function getNumFinishedInterstitialTiles():int {
      var numFinishedInterstitial:int = 0;
      var contentView:ContentView;
      for each (contentView in currentContentViews) {
        if (contentView && contentView.isInterstitialPiece && contentView.hasDisplayed) {
          numFinishedInterstitial++;
        }
      }
      return numFinishedInterstitial;
    }
    
    public function getContentViewAt(gridX:int, gridY:int):ContentView {
      var contentView:ContentView;
      for each (contentView in currentContentViews) {
        if (contentViewCoordinateTest(contentView, gridX, gridY)) {
          return contentView;
        }
      }
      return null;
    }
    
    protected function contentViewCoordinateTest(contentView:ContentView, gridX:int, gridY:int):Boolean {
      return  contentView.gridX <= gridX &&
        contentView.gridX + contentView.gridWidth - 1 >= gridX &&
        contentView.gridY <= gridY &&
        contentView.gridY + contentView.gridHeight - 1 >= gridY;
    }
    
    protected function findOverlappingViews(incomingContentView:ContentView):Object {
      
      // find all overlapping content views
      var overlappingContentViews:Array = new Array();
      var gridX:int;
      var gridY:int;
      var overlappingContentView:ContentView;
      for (gridY = incomingContentView.gridY; gridY < incomingContentView.gridY + incomingContentView.gridHeight; gridY++) {
        for (gridX = incomingContentView.gridX; gridX < incomingContentView.gridX + incomingContentView.gridWidth; gridX++) {
          overlappingContentView = getContentViewAt(gridX, gridY);
          if (overlappingContentView && overlappingContentViews.indexOf(overlappingContentView) == -1) {
            overlappingContentViews.push(overlappingContentView);
          }
        }
      }
      
      var tilesToDestroy:Array = new Array();
      var tilesToReplace:Array = new Array();
      
      // iterate over overlapping content views
      for each (overlappingContentView in overlappingContentViews) {
        
        for (gridY = overlappingContentView.gridY; gridY < overlappingContentView.gridY + overlappingContentView.gridHeight; gridY++) {
          for (gridX = overlappingContentView.gridX; gridX < overlappingContentView.gridX + overlappingContentView.gridWidth; gridX++) {
            
            // if current coordinate also belongs to incoming content view
            if (contentViewCoordinateTest(incomingContentView, gridX, gridY)) {
              tilesToDestroy.push({x:gridX, y:gridY}); // find overlapping tiles (to be destroyed)
            } else {
              tilesToReplace.push({x:gridX, y:gridY}); // find tiles that do not overlap (to be replaced)
            }
          }
        }
      }
      
      return {tilesToDestroy:tilesToDestroy, tilesToReplace:tilesToReplace};
    }
    
    // EVENT LISTENERS
    
    protected function contentViewDisplayedListener(e:Event):void {
      var contentView:ContentView = e.currentTarget as ContentView;
      
      // check current program for being ready to start or finish
      Locator.instance.contentCycleController.onTilesOpen();
      
      if (!Locator.instance.contentCycleController.currentProgram) { return; }
      
      if (Locator.instance.contentCycleController.currentProgram.status == 'active') {
        doProgramAction();
      }
    }
  }
}