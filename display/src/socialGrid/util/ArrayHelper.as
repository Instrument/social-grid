package socialGrid.util {
  
  public class ArrayHelper {
    
    public static function addItemToArray(item:*, array:Array):void {
      if (array.indexOf(item) == -1) {
        array.push(item);
      }
    }
    
    public static function removeItemFromArray(item:*, array:Array):void {
      var index:int;
      index = array.indexOf(item);
      if (index != -1) {
        array.splice(index, 1);
      }
    }
  }
}