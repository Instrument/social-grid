package socialGrid.util {
  
  public class RandomHelper {
    
    public static function getWeightedIndex(weights:Array):int {
      
      if (!weights || !weights.length) { return -1; }
      
      // find total
      var total:Number = 0;
      var weight:Number;
      for each (weight in weights) {
        total += weight;
      }
      
      // normalize weights
      var normalizedWeight:Number;
      var placeholder:Number = 0;
      var i:int;
      for (i = 0; i < weights.length; i++) {
        normalizedWeight = weights[i] / total;
        placeholder += normalizedWeight;
        weights[i] = placeholder;
      }
      
      weights.splice(0, 0, 0); // add 0 to beginning
      var roll:Number = Math.random();
      for (i = 0; i < weights.length - 1; i++) {
        if (roll >= weights[i] && roll < weights[i + 1]) {
          return i;
        }
      }
      
      return -1;
    }
  }
}