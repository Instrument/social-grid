package socialGrid.views {
  
  import aze.motion.easing.Cubic;
  import aze.motion.eaze;
  
  import flash.display.BlendMode;
  import flash.display.MovieClip;
  import flash.display.Shape;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.ColorTransform;
  import flash.text.TextFieldAutoSize;
  
  import socialGrid.assets.SocialGridAssets;
  import socialGrid.core.Locator;
  import socialGrid.util.GradientHelper;
  import socialGrid.util.GraphicsHelper;
  import socialGrid.util.StyledTextField;

  public class AppLoadingView extends Sprite {
    
    protected var bkgCircle:Sprite
    protected var loadingCircle:Sprite;
    protected var foldingTeepee:FoldingTeepee;
    protected var loadingTF:StyledTextField;
    
    protected var loadingShown:Boolean; // whether loading text has been shown
    
    protected var loadingSequenceFinished:Boolean; // whether the loading sequence is completely finished, outro included
    
    protected var loadingViewFinishedCallback:Function;
    
    protected var targetPercent:Number;
    protected var drawnPercent:Number;
    
    protected var _proxyPercent:Number; // value for proxy getter and setter used for outro animation
    
    public function AppLoadingView() {
      
      // yellow background
      //addChild(new SocialGridAssets.yellowBkg());
      
      graphics.beginFill(0xefefef, 1);
      graphics.drawRect(0, 0, 1280, 768);
      graphics.endFill();
      
      var fade:Shape = new Shape();
      addChild(fade);
      GradientHelper.drawCornerToCornerFade(fade.graphics, 0, 0, 1280, 768);
      fade.alpha = 0.1;
      fade.blendMode = BlendMode.MULTIPLY;
      
      bkgCircle = new Sprite();
      addChild(bkgCircle);
      bkgCircle.x = 640;
      bkgCircle.y = 384;
      with (bkgCircle.graphics) {
        beginFill(0x3bb3c5, 1);
        drawCircle(0, 0, 100);
        endFill();
      }
      //bkgCircle.alpha = 0.75;
      
      loadingCircle = new Sprite();
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
      var color:uint = 0x0a201d;
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
      
      drawPercent(0);
      setPercent(0);
      
      loadingTF.alpha = 0;
      //eaze(loadingTF).to(1.5, {alpha:1}).easing(Cubic.easeInOut);
      
      revealCrest();
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
      
      loadingCircle.graphics.beginFill(0x3bb3c5, 0.75);
      loadingCircle.graphics.moveTo(0, 0);
      loadingCircle.graphics.lineTo(0, -100);
      
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, 100, -90, -90 + value * 360, 1);
      
      loadingCircle.graphics.lineTo(0, 0);
      loadingCircle.graphics.endFill();
      
      
      loadingCircle.graphics.beginFill(0x3bb3c5, 1);
      
      var innerRad:Number = 104; // 80
      var outerRad:Number = 108; // 100
      
      loadingCircle.graphics.moveTo(0, -innerRad);
      
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, innerRad, -90, -90 + value * 360, 1);
      
      GraphicsHelper.lineToArcPosition(loadingCircle.graphics, 0, 0, outerRad, -90 + value * 360);
      
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, outerRad, -90 + value * 360, -90, 1);
      
      loadingCircle.graphics.lineTo(0, -innerRad);
      
      loadingCircle.graphics.endFill();
      
      loadingTF.text = 'LOADING / ' + Math.round(100 * value) + '%';
      
      //bkgCircle.alpha = 0.75 + value * 0.2; // gets it almost there
      
      if (value > 0.9) {
        //loadingCircle.alpha = 10 * (1 - value);
      }
    }
    
    public function get proxyPercent():Number { return _proxyPercent; }
    public function set proxyPercent(value:Number):void {
      _proxyPercent = value;
      
      loadingCircle.graphics.clear();
      loadingCircle.graphics.beginFill(0x3bb3c5, 1);
      
      var innerRad:Number = 104; // 80
      var outerRad:Number = 108; // 100
      
      loadingCircle.graphics.moveTo(0, -innerRad);
      
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, innerRad, -90, -90 - value * 360, 1);
      
      GraphicsHelper.lineToArcPosition(loadingCircle.graphics, 0, 0, outerRad, -90 - value * 360);
      
      GraphicsHelper.drawArc(loadingCircle.graphics, 0, 0, outerRad, -90 - value * 360, -90, 1);
      
      loadingCircle.graphics.lineTo(0, -innerRad);
      
      loadingCircle.graphics.endFill();
    }
    
    protected function revealCrest():void {
      foldingTeepee.visible = true;
      addEventListener(Event.ENTER_FRAME, foldingTeepeeFrameListener);
      foldingTeepee.play();
    }
    
    protected function doLoadOutro():void {
      bkgCircle.alpha = 1;
      //eaze(bkgCircle).to(0.5, {alpha:1}).easing(Cubic.easeInOut);
      
      eaze(loadingTF).to(0.75, {alpha:0}).easing(Cubic.easeInOut);
      
      _proxyPercent = 1;
      eaze(this).to(0.5, {proxyPercent:0}).easing(Cubic.easeInOut);
      eaze(loadingCircle).to(1, {alpha:0}).easing(Cubic.easeInOut).onComplete(onLoadingSequenceFinished);
    }
    
    protected function onLoadingSequenceFinished():void {
      loadingSequenceFinished = true;
      trace(loadingViewFinishedCallback);
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