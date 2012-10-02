package socialGrid.util {
  import flash.display.Graphics;
  
  public class GraphicsHelper {
    
    public static var degToRad:Number = 0.0174532925;
    
    public function GraphicsHelper() {}
    
    public static function drawArc(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, startAngle:Number, endAngle:Number, stepsPerPx:int = 1):void {
      
      var dA:Number = endAngle - startAngle;
      
      var pxLength:int = Math.round((2 * Math.PI * radius) * (dA / 360));
      
      var numSteps:int = Math.abs(pxLength * stepsPerPx);
      var stepAngle:Number = dA / numSteps;
      
      var angle:Number = startAngle;
      
      graphics.moveTo(centerX + radius * Math.cos(angle * degToRad), centerY + radius * Math.sin(angle * degToRad));
      
      var i:int;
      for (i = 0; i < numSteps; i++) {
        angle += stepAngle;
        graphics.lineTo(centerX + radius * Math.cos(angle * degToRad), centerY + radius * Math.sin(angle * degToRad));
      }
    }
    
    public static function moveToArcPosition(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, angle:Number):void {
      graphics.moveTo(centerX + radius * Math.cos(angle * degToRad), centerY + radius * Math.sin(angle * degToRad));
    }
    
    public static function lineToArcPosition(graphics:Graphics, centerX:Number, centerY:Number, radius:Number, angle:Number):void {
      graphics.lineTo(centerX + radius * Math.cos(angle * degToRad), centerY + radius * Math.sin(angle * degToRad));
    }
  }
}