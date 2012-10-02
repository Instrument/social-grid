package socialGrid.util {
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  
  public class BitmapResizer {
    
    public static var resizedBmd:BitmapData;
    
    public function BitmapResizer() {}
    
    public static function resizeBitmapData(bmd:BitmapData, width:Number, height:Number = -1):BitmapData {
      
      if (height == -1) { height = width; }
      
      // clear old bitmap data
      if (resizedBmd) {
        resizedBmd.dispose();
      }
      
      var matrix:Matrix = new Matrix();
      matrix.scale(width / bmd.width, height / bmd.height);
      
      resizedBmd = new BitmapData(width, height, true, 0x000000);
      
      resizedBmd.draw(bmd, matrix, null, null, null, true);
      
      return resizedBmd;
    }
  }
}