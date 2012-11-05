package socialGrid.util {
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.geom.Matrix;
  
  import socialGrid.core.Locator;
  
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
    
    public static function fitBitmapDataTo(bmd:BitmapData, width:Number, height:Number = -1):BitmapData {
      
      if (height == -1) { height = width; }
      
      // clear old bitmap data
      if (resizedBmd) {
        resizedBmd.dispose();
      }
      
      var oW:Number = bmd.width;
      var oH:Number = bmd.height;
      
      var nW:Number = oW;
      var nH:Number = oH;
      
      // check for being too big
      if (nW > width) {
        nW = width;
        nH = nW / oW * oH;
      }
      if (nH > height) {
        nH = height;
        nW = nH / oH * oW;
      }
      
      // check for being too small
      if (nW < width) {
        nW = width;
        nH = nW / oW * oH;
      }
      if (nH < height) {
        nH = height;
        nW = nH / oH * oW;
      }
      
      var matrix:Matrix = new Matrix();
      matrix.scale(nW / bmd.width, nH / bmd.height);
      
      matrix.tx = 0.5 * (width - nW);
      matrix.ty = 0.5 * (height - nH);
      
      resizedBmd = new BitmapData(width, height, true, 0x000000);
      resizedBmd.draw(bmd, matrix, null, null, null, true);
      
      return resizedBmd;
    }
  }
}