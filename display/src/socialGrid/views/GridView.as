package socialGrid.views {
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Matrix;
  import flash.geom.Rectangle;
  
  public class GridView extends Sprite {
    
    protected var bmp:Bitmap; // bitmap which content is drawn to
    
    protected var transitionViews:Array;
    
    protected var pendingTransitionViews:Array;
    
    protected var transitionDirection:String;
    
    public function GridView() {
      
      transitionViews = new Array();
      
      pendingTransitionViews = new Array();
      
      // create first one
      createTransitionViewAt(2, 1);
      
      // layout others in outward pattern to ensure correct display order:
      // 4 3 2 3 4
      // 3 2 1 2 3
      // 4 3 2 3 4
      var gridX:int;
      var gridY:int;
      var nextBatchCoordinates:Array;
      var nextBatchObj:Object;
      while (transitionViews.length < 15) {
        nextBatchCoordinates = new Array();
        
        // iterate over grid
        for (gridY = 0; gridY < 3; gridY++) {
          for (gridX = 0; gridX < 5; gridX++) {
            // if not one there already
            if (!getTransitionViewAt(gridX, gridY)) {
              // if one exists to right, left, up or down, add one
              if (
                getTransitionViewAt(gridX - 1, gridY) ||
                getTransitionViewAt(gridX + 1, gridY) ||
                getTransitionViewAt(gridX, gridY - 1) ||
                getTransitionViewAt(gridX, gridY + 1)
              ) {
                nextBatchCoordinates.push({x:gridX, y:gridY});
              }
            }
          }
        }
        
        // create the batch 
        for each (nextBatchObj in nextBatchCoordinates) {
          createTransitionViewAt(nextBatchObj.x, nextBatchObj.y);
        }
      }
      setTransitionDirection('right'); // default
      
      // create canvas
      bmp = new Bitmap();
      addChild(bmp);
      bmp.bitmapData = new BitmapData(1280, 768, true, 0x00000000);
    }
    
    protected function createTransitionViewAt(gridX:int, gridY:int):void {
      var transitionView:TransitionView = new TransitionView();
      transitionViews.push(transitionView);
      addChildAt(transitionView, 0); // adds from bottom of display
      transitionView.x = gridX * 256;
      transitionView.y = gridY * 256;
      transitionView.gridX = gridX;
      transitionView.gridY = gridY;
      transitionView.addEventListener('transition_view_complete', transitionViewCompleteListener);
    }
    
    protected function getTransitionViewAt(gridX:int, gridY:int):TransitionView {
      var transitionView:TransitionView;
      for each (transitionView in transitionViews) {
        if (transitionView.gridX == gridX && transitionView.gridY == gridY) {
          return transitionView;
        }
      }
      return null;
    }
    
    public function setTransitionDirection(value:String):void {
      transitionDirection = value;
      var transitionView:TransitionView;
      for each (transitionView in transitionViews) {
        transitionView.setTransitionDirection(transitionDirection);
      }
    }
    
    public function displayContentViews(contentViews:Array, timeFactor:Number= 1):void {
      
      // prepare
      var contentView:ContentView;
      for each (contentView in contentViews) {
        prepareTransitionViewsForContentView(contentView);
      }
      
      // transition
      cascadePendingTransitionViews(timeFactor);
    }
    
    public function displayContentView(contentView:ContentView, timeFactor:Number = 1):void {
      
      // prepare
      prepareTransitionViewsForContentView(contentView);
      
      // transition
      cascadePendingTransitionViews(timeFactor);
    }
    
    protected function prepareTransitionViewsForContentView(contentView:ContentView):void {
      // find transition views needed for the transition
      var relevantTransitionViews:Array = new Array();
      var gridX:int;
      var gridY:int;
      var transitionView:TransitionView;
      for (gridY = contentView.gridY; gridY < contentView.gridY + contentView.gridHeight; gridY++) {
        for (gridX = contentView.gridX; gridX < contentView.gridX + contentView.gridWidth; gridX++) {
          transitionView = getTransitionViewAt(gridX, gridY);
          
          transitionView.contentView = contentView; // set content view
          
          // give outgoing and incoming bitmap data to transition view
          transitionView.setOutgoing(bmp, -256 * gridX, -256 * gridY);
          transitionView.setIncoming(contentView.bitmapData, -256 * (gridX - contentView.gridX), -256 * (gridY - contentView.gridY));
          
          // empty space in bmp
          bmp.bitmapData.fillRect(new Rectangle(256 * gridX, 256 * gridY, 256, 256), 0x00000000);
          
          relevantTransitionViews.push(transitionView);
        }
      }
      
      contentView.transitionViewCount = relevantTransitionViews.length;
      for each (transitionView in relevantTransitionViews) {
        pendingTransitionViews.push(transitionView);
      }
    }
    
    protected function cascadePendingTransitionViews(timeFactor:Number = 1):void {
      
      var firstColumnIndex:int;
      var transitionView:TransitionView;
      
      // cascade depending on transition direction
      switch (transitionDirection) {
        case 'right':
          firstColumnIndex = 4;
          for each (transitionView in pendingTransitionViews) {
            if (transitionView.gridX < firstColumnIndex) {
              firstColumnIndex = transitionView.gridX;
            }
          }
          break;
        case 'left':
          firstColumnIndex = 0;
          for each (transitionView in pendingTransitionViews) {
            if (transitionView.gridX > firstColumnIndex) {
              firstColumnIndex = transitionView.gridX;
            }
          }
          break;
        case 'down':
          firstColumnIndex = 2;
          for each (transitionView in pendingTransitionViews) {
            if (transitionView.gridY < firstColumnIndex) {
              firstColumnIndex = transitionView.gridY;
            }
          }
          break;
        case 'up':
          firstColumnIndex = 0;
          for each (transitionView in pendingTransitionViews) {
            if (transitionView.gridY > firstColumnIndex) {
              firstColumnIndex = transitionView.gridY;
            }
          }
          break;
      }
      
      // cascade them
      for each (transitionView in pendingTransitionViews) {
        transitionView.visible = true;
        switch (transitionDirection) {
          case 'right':
            transitionView.transition(timeFactor, timeFactor * 500 * (transitionView.gridX - firstColumnIndex));
            break;
          case 'left':
            transitionView.transition(timeFactor, timeFactor * 500 * (firstColumnIndex - transitionView.gridX));
            break;
          case 'down':
            transitionView.transition(timeFactor, timeFactor * 500 * (transitionView.gridY - firstColumnIndex));
            break;
          case 'up':
            transitionView.transition(timeFactor, timeFactor * 500 * (firstColumnIndex - transitionView.gridY));
            break;
        }
      }
      
      // clear pending transitions for next call
      pendingTransitionViews = new Array();
    }
    
    protected function transitionViewCompleteListener(e:Event):void {
      var transitionView:TransitionView = e.currentTarget as TransitionView;
      
      bmp.bitmapData.draw(transitionView.incomingBmd, new Matrix(1, 0, 0, 1, 256 * transitionView.gridX, 256 * transitionView.gridY));
      transitionView.visible = false;
      
      // start display timer
      transitionView.contentView.onTransitionViewComplete();
    }
  }
}