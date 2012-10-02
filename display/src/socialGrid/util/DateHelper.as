package socialGrid.util {
  
  public class DateHelper {
    
    public static var days:Array = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
    
    public static var months:Array = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    
    public static var months3Letter:Array = ['jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec'];
    
    public function DateHelper() {}
    
    public static function parseTwitterDateTime(dateTime:String):Number {
      
      // post date
      var matches:Array = dateTime.match(/\w+?, (\d+) (\w+) (\d+) (\d+?):(\d+?):(\d+) \+(\d+)/);
      
      var year:int = int(matches[3]);
      
      // find month
      var month:int;
      var i:int;
      for (i = 0; i < months.length; i++) {
        if (String(months[i]).substr(0, 3).toLowerCase() == matches[2].toLowerCase()) {
          month = i;
        }
      }
      
      var day:int = int(matches[1]) - 1;
      var hour:int = int(matches[4]);
      var min:int = int(matches[5]);
      var sec:int = int(matches[6]);
      var ms:int = int(matches[7]);
      
      var date:Date = new Date(year, month, day, hour, min, sec, ms);
      
      return date.time;
    }
    
    public static function getStandardTimeFromTimestamp(timestamp:Number):String {
      
      var date:Date = new Date(timestamp);
      
      var hour:int = date.getHours();
      var timeExtension:String;
      
      if (hour > 12){
        hour = (hour == 12) ? 12 : hour - 12;
        timeExtension = "PM";
      }else{
        hour = (hour == 0) ? 12 : hour ;
        timeExtension = "AM";
      }
      
      return months[date.getMonth()] + ' ' + normalizeNumDigits(date.getDate(), 2) + ', ' + hour + ':' + normalizeNumDigits(date.getMinutes(), 2) + timeExtension;
      
    }
    
    public static function normalizeNumDigits(value:*, numDigits:int):String {
      value = String(value);
      while (value.length < numDigits) {
        value = '0' + value;
      }
      return value;
    }
  }
}