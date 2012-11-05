package socialGrid.views.contentViews {
  
  import flash.display.BitmapData;
  import flash.events.Event;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.BaseContentVO;
  import socialGrid.models.content.UserVideoContentVO;
  
  public class VideoContentView extends BaseContentView {
    
    public var videoUrl:String;
    
    public var duration:Number;
    
    public function VideoContentView(contentVO:BaseContentVO, bitmapData:BitmapData, cloneData:Boolean = false) {
      
      super(contentVO, bitmapData, cloneData);
      
      contentViewType = 'video';
      
      var videoContentVO:UserVideoContentVO = contentVO as UserVideoContentVO;
      
      duration = videoContentVO.metadata.duration * 1000;
      
      videoUrl = videoContentVO.videoUrl;
    }
    
    override public function getTimeUntilFinished():Number {
      return duration - (new Date().time - timeStarted);
    }
    
    override protected function startDisplay():void {
      super.startDisplay();
      
      // start video playback
      Locator.instance.ui.videoPlaybackView.playbackVideoContentView(this);
    }
    
    public function onVideoPlaybackComplete():void {
      //trace('video playback complete');
      onDisplayComplete();
    }
  }
}