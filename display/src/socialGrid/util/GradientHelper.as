package socialGrid.util {
  
  import flash.display.GradientType;
  import flash.display.Graphics;
  import flash.geom.Matrix;
  
  import socialGrid.core.Locator;

  public class GradientHelper {
    
    public static function drawCornerToCornerFade(graphics:Graphics, x1:Number, y1:Number, x2:Number, y2:Number):void {
      
      var width:Number = x2 - x1;
      var height:Number = y2 - y1;
      
      var angle:Number = Math.atan2(height, width);
      
      var length:Number = Math.sqrt(width * width + height * height);
      var length2:Number = 2 * Math.sin(angle) * width;
      
      var matrix:Matrix = new Matrix();
      matrix.createGradientBox(length, length2, angle, 0, 0);
      var colors:Array = [0x000000, 0x000000];
      var alphas:Array = [0, 1];
      var ratios:Array = [0, 255];
      
      with (graphics) {
        beginGradientFill(GradientType.LINEAR,colors, alphas, ratios, matrix);
        drawRect(x1, y1, width, height);
        endFill();
      }
      
    }
  }
}