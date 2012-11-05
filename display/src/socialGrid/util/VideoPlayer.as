package socialGrid.util {
  
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.TimerEvent;
  import flash.media.Video;
  import flash.net.NetConnection;
  import flash.net.NetStream;
  import flash.utils.Timer;
  
  public class VideoPlayer extends Sprite {
    
    protected var autosize:Boolean;
    protected var _isPlaying:Boolean;
    protected var lastStreamTime:Number; // used for checking end of video
    protected var streamTimeRepeatCount:int;
    
    public var video:Video;
    protected var client:Object;
    protected var connection:NetConnection;
    protected var stream:NetStream;
    
    public var metadata:VideoMetadata;
    
    protected var playbackTimer:Timer;
    protected var playbackTimeLimitTimer:Timer;
    
    public function VideoPlayer(w:Number = 400, h:Number = 300, autosize:Boolean = true) {
      
      this.autosize = autosize;
      
      video = new Video(w, h);
      addChild(video);
      
      client = new Object();
      client.onMetaData = onMetaData;
      
      connection = new NetConnection();
      connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventListener);
      connection.addEventListener(IOErrorEvent.IO_ERROR, connectionErrorListener);
      connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, connectionErrorListener);
      connection.connect(null);
      
      playbackTimer = new Timer(13);
      playbackTimer.addEventListener(TimerEvent.TIMER, playbackTimerListener);
    }
    
    public function load(url:String):void {
      
      metadata = null;
      lastStreamTime = 0;
      streamTimeRepeatCount = 0;
      
      stream = new NetStream(connection);
      stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusEventListener);
      stream.client = client;
      video.attachNetStream(stream);
      
      stream.play(url);
      stream.pause();
      _isPlaying = false;
    }
    
    public function play():void {
      if (!_isPlaying) {
        togglePause();
      }
    }
    
    public function pause():void {
      if (_isPlaying) {
        togglePause();
      }
    }
    
    public function togglePause():void {
      stream.togglePause();
      _isPlaying = !_isPlaying;
      if (_isPlaying) {
        playbackTimer.start();
      } else {
        playbackTimer.stop();
      }
    }
    
    public function limitPlaybackTime(limit:Number):void {
      playbackTimeLimitTimer = new Timer(limit, 1);
      playbackTimeLimitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, playbackTimeLimitTimerListener);
      playbackTimeLimitTimer.start();
    }
    
    public function dispose():void {
      connection.close();
    }
    
    protected function onMetaData(obj:Object):void {
      if (metadata) { return; }
      
      metadata = new VideoMetadata(obj);
      
      // override metadata dimensions with actual stream dimensions
      metadata.width = video.videoWidth;
      metadata.width = video.videoHeight;
      
      if (autosize) {
        video.width = metadata.width;
        video.height = metadata.height;
      }
      
      // captures first video frame
      stream.seek(0);
      metadata.firstFrame = new BitmapData(video.width, video.height, true, 0xff000000);
      metadata.firstFrame.draw(video);
      
      dispatchEvent(new Event('video_metadata'));
    }
    
    protected function onVideoEnd():void {
      pause();
      dispatchEvent(new Event('video_end_reached'));
    }
    
    protected function playbackTimerListener(e:TimerEvent):void {
      if (_isPlaying && metadata) {
        
        // check for end of stream
        if (
          stream.time >= metadata.duration ||
          stream.time >= metadata.duration - 0.1 && streamTimeRepeatCount > 10 // if stream time is close to end, but repeating
        ) {
          onVideoEnd();
        }
        
        // check for repeating time
        if (stream.time == lastStreamTime) {
          streamTimeRepeatCount++;
        } else {
          streamTimeRepeatCount = 0;
        }
        
        // set last stream time
        lastStreamTime = stream.time;
      }
    }
    
    protected function playbackTimeLimitTimerListener(e:TimerEvent):void {
      onVideoEnd();
    }
    
    protected function netStatusEventListener(e:NetStatusEvent):void {
      switch (e.info.code) {
        case 'NetStream.Play.StreamNotFound':
          dispatchEvent(new Event('video_error'));
          break;
      }
    }
    
    protected function connectionErrorListener(e:Event):void {
      // can be IOErrorEvent.IO_ERROR or SecurityErrorEvent.SECURITY_ERROR
      dispatchEvent(new Event('video_error'));
    }
  }
}