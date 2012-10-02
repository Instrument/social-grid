package socialGrid.util {
  
  public class Highlighter {
    
    public function Highlighter() {}
    
    public static function highlightSocial(value:String):String {
      
      value = highlight(value, /(@\w+)/g);
      value = highlight(value, /(#\w+)/g);
      value = highlight(value, /http:\/\/[^ ]+/gi);
      
      return value;
    }
    
    public static function highlight(value:String, pattern:RegExp):String {
      var match:String;
      for each (match in value.match(pattern)) {
        value = value.replace(match, '<highlight>' + match + '</highlight>');
      }
      return value;
    }
  }
}