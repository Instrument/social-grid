package socialGrid.views {
  
  import aze.motion.easing.Cubic;
  import aze.motion.eaze;
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.DisplayObject;
  import flash.display.IBitmapDrawable;
  import flash.display.Shader;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.filters.ShaderFilter;
  import flash.geom.Matrix;
  import flash.utils.ByteArray;
  
  import socialGrid.assets.SocialGridAssets;
  
  public class TransitionView extends Sprite {
    
    public var transitionDirection:String;
    
    public var gridX:int;
    public var gridY:int;
    
    public var outgoingBmd:BitmapData; // original outgoing bitmap data
    public var incomingBmd:BitmapData; // original incoming bitmap data
    
    protected var outTransBmd:BitmapData; // transformed outgoing bitmap data
    protected var inTransBmd:BitmapData; // transformed incoming bitmap data
    
    protected var outBmp1:Bitmap; // surfaces for transition
    protected var outBmp2:Bitmap;
    protected var inBmp1:Bitmap;
    protected var inBmp2:Bitmap;
    
    protected var outBmp1Shader:Shader;
    protected var outBmp1ShaderFilter:ShaderFilter;
    protected var outBmp2Shader:Shader;
    protected var outBmp2ShaderFilter:ShaderFilter;
    protected var inBmp1Shader:Shader;
    protected var inBmp1ShaderFilter:ShaderFilter;
    protected var inBmp2Shader:Shader;
    protected var inBmp2ShaderFilter:ShaderFilter;
    
    public var contentView:ContentView;
    
    protected var percentTransition:Number;
    
    // vars for transition
    protected var sliderPos:Number;
    
    protected var angle1:Number;
    protected var angleDeg1:Number;
    protected var percentAngle1:Number;
    
    protected var angle2:Number;
    protected var angleDeg2:Number;
    protected var percentAngle2:Number;
    
    public function TransitionView() {
      
      outgoingBmd = new BitmapData(256, 256, true, 0x00000000);
      incomingBmd = new BitmapData(256, 256, true, 0x00000000);
      
      outTransBmd = new BitmapData(256, 256, true, 0x00000000);
      inTransBmd = new BitmapData(256, 256, true, 0x00000000);
      
      outBmp1 = new Bitmap();
      outBmp1.bitmapData = new BitmapData(128, 256, true, 0x00000000);
      addChild(outBmp1);
      
      outBmp2 = new Bitmap();
      outBmp2.bitmapData = new BitmapData(128, 256, true, 0x00000000);
      addChild(outBmp2);
      
      inBmp1 = new Bitmap();
      inBmp1.bitmapData = new BitmapData(128, 256, true, 0x00000000);
      addChild(inBmp1);
      
      inBmp2 = new Bitmap();
      inBmp2.bitmapData = new BitmapData(128, 256, true, 0x00000000);
      addChild(inBmp2);
      
      outBmp1Shader = new Shader(new SocialGridAssets.TintShader() as ByteArray);
      outBmp1ShaderFilter = new ShaderFilter(outBmp1Shader);
      
      outBmp2Shader = new Shader(new SocialGridAssets.TintShader() as ByteArray);
      outBmp2ShaderFilter = new ShaderFilter(outBmp2Shader);
      
      inBmp1Shader = new Shader(new SocialGridAssets.TintShader() as ByteArray);
      inBmp1ShaderFilter = new ShaderFilter(inBmp1Shader);
      
      inBmp2Shader = new Shader(new SocialGridAssets.TintShader() as ByteArray);
      inBmp2ShaderFilter = new ShaderFilter(inBmp2Shader);
    }
    
    public function setOutgoing(target:IBitmapDrawable, offsetX:Number, offsetY:Number):void {
      outgoingBmd.draw(target, new Matrix(1, 0, 0, 1, offsetX, offsetY));
      
      var transMatrix:Matrix = new Matrix();
      
      switch (transitionDirection) {
        case 'right':
          outTransBmd.draw(outgoingBmd);
          break;
        case 'left':
          inTransBmd.draw(outgoingBmd);
          break;
        case 'down':
          transMatrix.rotate(-0.5 * Math.PI);
          transMatrix.translate(0, 256);
          outTransBmd.draw(outgoingBmd, transMatrix);
          break;
        case 'up':
          transMatrix.rotate(-0.5 * Math.PI);
          transMatrix.translate(0, 256);
          inTransBmd.draw(incomingBmd, transMatrix);
          break;
      }
    }
    
    public function setIncoming(target:IBitmapDrawable, offsetX:Number, offsetY:Number):void {
      incomingBmd.draw(target, new Matrix(1, 0, 0, 1, offsetX, offsetY));
      
      var transMatrix:Matrix = new Matrix();
      
      switch (transitionDirection) {
        case 'right':
          inTransBmd.draw(incomingBmd);
          break;
        case 'left':
          outTransBmd.draw(incomingBmd);
          break;
        case 'down':
          transMatrix.rotate(-0.5 * Math.PI);
          transMatrix.translate(0, 256);
          inTransBmd.draw(incomingBmd, transMatrix);
          break;
        case 'up':
          transMatrix.rotate(-0.5 * Math.PI);
          transMatrix.translate(0, 256);
          outTransBmd.draw(incomingBmd, transMatrix);
          break;
      }
    }
    
    public function setTransitionDirection(value:String):void {
      transitionDirection = value;
      switch (transitionDirection) {
        case 'right':
        case 'left':
          x = 256 * gridX;
          y = 256 * gridY;
          rotation = 0;
          break;
        case 'down':
        case 'up':
          x = 256 * gridX + 256;
          y = 256 * gridY;
          rotation = 90;
          break;
      }
    }
    
    public function transition(timeFactor:Number = 1, delay:Number = 0):void {
      
      outBmp1.bitmapData.draw(outTransBmd, new Matrix(1, 0, 0, 1, 0, 0));
      outBmp2.bitmapData.draw(outTransBmd, new Matrix(1, 0, 0, 1, -128, 0));
      
      inBmp1.bitmapData.draw(inTransBmd, new Matrix(1, 0, 0, 1, 0, 0));
      inBmp2.bitmapData.draw(inTransBmd, new Matrix(1, 0, 0, 1, -128, 0));
      
      initializeTintShader(outBmp1Shader, outBmp1.bitmapData, 0.75);
      initializeTintShader(outBmp2Shader, outBmp2.bitmapData, 0.15);
      initializeTintShader(inBmp1Shader, inBmp1.bitmapData, 0.75);
      initializeTintShader(inBmp2Shader, inBmp2.bitmapData, 0.15);
      
      percentTransitionProxy = 0;
      
      eaze(this).delay(0.001 * delay).to(timeFactor * 1, {percentTransitionProxy: 1}).easing(Cubic.easeInOut).onComplete(onTransitionComplete);
    }
    
    protected function initializeTintShader(shader:Shader, bmd:BitmapData, variance:Number):void {
      
      var oldInput:BitmapData = shader.data.src.input as BitmapData;
      if (oldInput) {
        oldInput.dispose();
      }
      
      shader.data.src.input = bmd.clone();
      shader.data.color.value[0] = variance;
      shader.data.color.value[1] = variance;
      shader.data.color.value[2] = variance;
    }
    
    protected function onTransitionComplete():void {
      dispatchEvent(new Event('transition_view_complete'));
    }
    
    public function get percentTransitionProxy():Number { return percentTransition; }
    public function set percentTransitionProxy(value:Number):void {
      value = Math.max(value, 0);
      value = Math.min(value, 1);
      percentTransition = value;
      
      // slider pos determined by direction
      switch (transitionDirection) {
        case 'right':
        case 'down':
          sliderPos = percentTransition * 256;
          break;
        case 'left':
        case 'up':
          sliderPos = (1 - percentTransition) * 256;
          break;
      }
      
      // ensures correct surfaces are on top
      if (sliderPos < 128 && getChildIndex(inBmp1) > getChildIndex(outBmp1)) { // put outgoing on top
        addChild(inBmp1);
        addChild(inBmp2);
        addChild(outBmp1);
        addChild(outBmp2);
      }
      if (sliderPos >= 128 && getChildIndex(outBmp1) > getChildIndex(inBmp1)) { // put incoming on top
        addChild(outBmp1);
        addChild(outBmp2);
        addChild(inBmp1);
        addChild(inBmp2);
      }
      
      // positioning math
      angle1 = Math.acos(0.5 * sliderPos / 128);
      angleDeg1 = angle1 / Math.PI * 180;
      percentAngle1 = angleDeg1 / 90; // from 1 to 0
      
      angle2 = Math.acos(0.5 * (256 - sliderPos) / 128);
      angleDeg2 = angle2 / Math.PI * 180;
      percentAngle2 = angleDeg2 / 90; // from 0 to 1
      
      inBmp1.rotationY = -angleDeg1;
      
      inBmp2.rotationY = -inBmp1.rotationY;
      inBmp2.x = inBmp1.x + 128 * Math.cos(inBmp2.rotationY / 180 * Math.PI);
      inBmp2.z = inBmp1.z + 128 * Math.sin(inBmp2.rotationY / 180 * Math.PI);
      
      outBmp1.x = sliderPos;
      outBmp1.rotationY = -angleDeg2;
      
      outBmp2.rotationY = -outBmp1.rotationY;
      outBmp2.x = outBmp1.x + 128 * Math.cos(outBmp1.rotationY / 180 * Math.PI);
      outBmp2.z = outBmp1.z - 128 * Math.sin(outBmp1.rotationY / 180 * Math.PI);
      
      
      outBmp1Shader.data.amount.value = [percentAngle1 - 1];
      outBmp1.filters = [outBmp1ShaderFilter];
      
      outBmp2Shader.data.amount.value = [1 - percentAngle1];
      outBmp2.filters = [outBmp2ShaderFilter];
      
      inBmp1Shader.data.amount.value = [percentAngle2 - 1];
      inBmp1.filters = [inBmp1ShaderFilter];
      
      inBmp2Shader.data.amount.value = [1 - percentAngle2];
      inBmp2.filters = [inBmp2ShaderFilter];
      
      // gets rid of blur caused by 3d matrix and optimizes display if not actively transitioning
      if (sliderPos == 0) {
        applyTransformMatrix(outBmp1);
        applyTransformMatrix(outBmp2);
        inBmp1.visible = inBmp2.visible = false;
      } else if (!inBmp1.visible || !inBmp2.visible) {
        inBmp1.visible = inBmp2.visible = true;
      }
      if (sliderPos == 256) {
        applyTransformMatrix(inBmp1);
        applyTransformMatrix(inBmp2);
        outBmp1.visible = outBmp2.visible = false;
      } else if (!outBmp1.visible || !outBmp2.visible) {
        outBmp1.visible = outBmp2.visible = true;
      }
    }
    
    protected function applyTransformMatrix(target:DisplayObject):void {
      var matrix:Matrix = new Matrix();
      matrix.tx = target.x;
      target.transform.matrix = matrix;
    }
  }
}