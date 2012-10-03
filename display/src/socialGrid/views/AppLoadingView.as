package socialGrid.views {
  
  import aze.motion.easing.Cubic;
  import aze.motion.easing.Expo;
  import aze.motion.eaze;
  
  import flash.display.BlendMode;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.ColorTransform;
  import flash.text.TextFieldAutoSize;
  
  import socialGrid.core.Locator;
  import socialGrid.util.GradientHelper;
  import socialGrid.util.GraphicsHelper;
  import socialGrid.util.StyledTextField;

  public class AppLoadingView extends Sprite {
    
    protected var bkg:Shape;
    protected var bkgCircle:Shape;
    protected var loadingCircle:Shape;
    protected var foldingTeepee:FoldingTeepee;
    protected var loadingTF:StyledTextField;
    protected var cover:Shape;
    
    protected var loadingCircleInnerRadius:Number;
    protected var loadingCircleOuterRadius:Number;
    
    protected var loadingShown:Boolean; // whether loading text has been shown
    
    protected var loadingSequenceFinished:Boolean; // whether the loading sequence is completely finished, outro included
    
    protected var loadingViewFinishedCallback:Function;
    
    protected var targetPercent:Number;
    protected var drawnPercent:Number;
    
    protected var _outroPercent:Number; // value for proxy getter and setter used for outro animation
    
    public function AppLoadingView() {
      
      loadingCircleInnerRadius = 104;
      loadingCircleOuterRadius = 108;
      
      // draw initial color
      graphics.beginFill(0x000000, 1);
      graphics.drawRect(0, 0, 1280, 768);
      graphics.endFill();
    }
    
    public function init():void {
      
      bkg = new Shape();
      addChild(bkg);
      with (bkg.graphics) {
        beginFill(Locator.instance.appModel.config.loadingBackgroundColor, 1);
        drawRect(0, 0, 1280, 768);
        endFill();
      }
      
      var fade:Shape = new Shape();
      addChild(fade);
      GradientHelper.drawCornerToCornerFade(fade.graphics, 0, 0, 1280, 768);
      fade.alpha = 0.1;
      fade.blendMode = BlendMode.MULTIPLY;
      
      bkgCircle = new Shape();
      addChild(bkgCircle);
      bkgCircle.x = 640;
      bkgCircle.y = 384;
      with (bkgCircle.graphics) {
        beginFill(Locator.instance.appModel.config.loadingCircleColor, 1);
        drawCircle(0, 0, 100);
        endFill();
      }
      
      loadingCircle = new Shape();
      addChild(loadingCircle);
      loadingCircle.x = 640;
      loadingCircle.y = 384;
      
      foldingTeepee = new FoldingTeepee();
      addChild(foldingTeepee);
      foldingTeepee.x = 512;
      foldingTeepee.y = 256;
      foldingTeepee.stop();
      foldingTeepee.visible = false;
      
      // color transform teepee
      var color:uint = Locator.instance.appModel.config.loadingIconColor;
      var rgbObj:Object = {
        red: ((color & 0xFF0000) >> 16),
        green: ((color & 0x00FF00) >> 8),
        blue: ((color & 0x0000FF))
      };
      foldingTeepee.transform.colorTransform = new ColorTransform(0, 0, 0, 1, rgbObj.red, rgbObj.green, rgbObj.blue);
      
      loadingTF = new StyledTextField('app-loading-text');
      addChild(loadingTF);
      loadingTF.x = 512 + 88;
      loadingTF.y = 432 + 68;
      
      loadingTF.width = 256;
      loadingTF.autoSize = TextFieldAutoSize.LEFT;
      loadingTF.wordWrap = true;
      
      cover = new Shape();
      addChild(cover);
      with (cover.graphics) {
        beginFill(0x000000, 1);
        drawRect(0, 0, 1280, 768);
        endFill();
      }
      
      // initial state
      drawPercent(0);
      setPercent(0);
      loadingTF.alpha = 0;
      
      // reveal
      eaze(cover).to(1, {alpha:0}).easing(Expo.easeInOut).onComplete(revealCrest);
    }
    
    public function setLoadingViewFinishedCallback(callback:Function):void {
      loadingViewFinishedCallback = callback;
      
      // check for being done already
      if (loadingSequenceFinished) {
        loadingViewFinishedCallback.apply();
      }
    }
    
    public function setAssetsPercent(value:Number):void {
      setPercent(0.8 * value);
    }
    
    public function setInitialMediaPercent(value:Number):void {
      setPercent(0.8 + 0.2 * value);
    }
    
    public function setPercent(value:Number):void {
      
      targetPercent = value;
      addEventListener(Event.ENTER_FRAME, loaderFrameListener);
    }
    
    public function drawPercent(value:Number):void {
      
      drawnPercent = value;
      
      loadingCircle.graphics.clear();
      
      // circle fill
      loadingCircle.graphics.beginFill(Locator.instance.appModel.config.loadingCircleColor, 0.75);
      loadingCircle.graphics.moveTo(0, 0);
      loadingCircle.graphics.lineTo(0, -100);
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, 100, -90, -90 + value * 360, 1);
      loadingCircle.graphics.lineTo(0, 0);
      loadingCircle.graphics.endFill();
      
      // ring fill
      loadingCircle.graphics.beginFill(Locator.instance.appModel.config.loadingCircleColor, 1);
      loadingCircle.graphics.moveTo(0, -loadingCircleInnerRadius);
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, loadingCircleInnerRadius, -90, -90 + value * 360, 1);
      GraphicsHelper.lineToArcPosition(loadingCircle.graphics, 0, 0, loadingCircleOuterRadius, -90 + value * 360);
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, loadingCircleOuterRadius, -90 + value * 360, -90, 1);
      loadingCircle.graphics.lineTo(0, -loadingCircleInnerRadius);
      loadingCircle.graphics.endFill();
      
      loadingTF.text = 'LOADING / ' + Math.round(100 * value) + '%';
    }
    
    public function get outroPercent():Number { return _outroPercent; }
    public function set outroPercent(value:Number):void {
      _outroPercent = value;
      
      value = 1 - value;
      
      loadingCircle.graphics.clear();
      
      // ring fill backwards
      loadingCircle.graphics.beginFill(Locator.instance.appModel.config.loadingCircleColor, 1);
      loadingCircle.graphics.moveTo(0, -loadingCircleInnerRadius);
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, loadingCircleInnerRadius, -90, -90 - value * 360, 1);
      GraphicsHelper.lineToArcPosition(loadingCircle.graphics, 0, 0, loadingCircleOuterRadius, -90 - value * 360);
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, loadingCircleOuterRadius, -90 - value * 360, -90, 1);
      loadingCircle.graphics.lineTo(0, -loadingCircleInnerRadius);
      loadingCircle.graphics.endFill();
    }
    
    protected function revealCrest():void {
      foldingTeepee.visible = true;
      addEventListener(Event.ENTER_FRAME, foldingTeepeeFrameListener);
      foldingTeepee.play();
    }
    
    protected function doLoadOutro():void {
      bkgCircle.alpha = 1;
      
      eaze(loadingTF).to(0.75, {alpha:0}).easing(Cubic.easeInOut);
      
      _outroPercent = 0;
      eaze(this).to(0.5, {outroPercent:1}).easing(Cubic.easeInOut);
      eaze(loadingCircle).to(1, {alpha:0}).easing(Cubic.easeInOut).onComplete(onLoadingSequenceFinished);
    }
    
    protected function onLoadingSequenceFinished():void {
      loadingSequenceFinished = true;
      if (loadingViewFinishedCallback != null) {
        loadingViewFinishedCallback.apply();
      }
    }
    
    protected function foldingTeepeeFrameListener(e:Event):void {
      if (!loadingShown && foldingTeepee.currentFrame >= 0.3 * foldingTeepee.totalFrames) {
        loadingShown = true;
        eaze(loadingTF).to(1.5, {alpha:1}).easing(Cubic.easeInOut);
        eaze(bkgCircle).to(1.5, {alpha:0.75}).easing(Cubic.easeInOut);
      }
      
      if (foldingTeepee.currentFrame == foldingTeepee.totalFrames) {
        foldingTeepee.stop();
        removeEventListener(Event.ENTER_FRAME, foldingTeepeeFrameListener);
      }
    }
    
    protected function loaderFrameListener(e:Event):void {
      var dp:Number = targetPercent - drawnPercent;
      
      if (Math.abs(dp) > 0.01) {
        drawPercent(drawnPercent + 0.25 * dp);
      } else {
        drawPercent(targetPercent);
        removeEventListener(Event.ENTER_FRAME, loaderFrameListener);
      }
      
      if (drawnPercent == 1) {
        doLoadOutro();
      }
    }
  }
}