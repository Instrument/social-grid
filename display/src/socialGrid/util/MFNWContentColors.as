package socialGrid.util {
  
  import flash.display.BlendMode;
  
  public class MFNWContentColors {
    
    protected static var colors:Array = [
      {color:0xc4807e, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0x8eb579, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xbc86ec, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xb97208, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0x57c2a5, blendMode:BlendMode.MULTIPLY, alpha:1},
      
      {color:0x6e6e6e, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xd9f5f0, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xb6b8ff, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xaba255, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0x7cddfd, blendMode:BlendMode.MULTIPLY, alpha:1},
      
      {color:0x5187c1, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0x838383, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xa858c6, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xe74db7, blendMode:BlendMode.MULTIPLY, alpha:1},
      {color:0xc0953f, blendMode:BlendMode.MULTIPLY, alpha:1}
    ];
    
    protected static var colorIndex:int = 0;
    
    public static function getNextColor():Object {
      
      var color:Object = colors[colorIndex];
      
      colorIndex++;
      if (colorIndex > colors.length - 1) {
        colorIndex = 0;
      }
      
      return color;
    }
  }
}