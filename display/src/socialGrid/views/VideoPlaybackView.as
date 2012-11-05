package socialGrid.views {
  
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.geom.Matrix;
  
  import socialGrid.core.Locator;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.VideoPlayer;
  import socialGrid.views.contentViews.VideoContentView;
  
  public class VideoPlaybackView extends Sprite {
    
    public var contentViews:Array;
    public var videoPlayers:Array;
    
    public function VideoPlaybackView() {
      contentViews = new Array();
      videoPlayers = new Array();
    }
    
    public function playbackVideoContentView(videoContentView:VideoContentView):void {
      
      var videoPlayer:VideoPlayer = new VideoPlayer(256 * videoContentView.gridWidth, 256 * videoContentView.gridHeight, false);
      addChild(videoPlayer);
      videoPlayers.push(videoPlayer);
      videoPlayer.addEventListener('video_end_reached', videoFinishedListener);
      
      contentViews.push(videoContentView);
      
      videoPlayer.x = 256 * videoContentView.gridX;
      videoPlayer.y = 256 * videoContentView.gridY;
      
      //trace('playing back ' + videoContentView.videoUrl);
      
      videoPlayer.load(videoContentView.videoUrl);
      videoPlayer.play();
    }
    
    public function endCurrentVideos():void {
      var videoPlayer:VideoPlayer;
      for each (videoPlayer in videoPlayers) {
        videoPlayer.limitPlaybackTime(Math.random() * 2000);
      }
    }
    
    protected function removeVideoPlayerAndContentView(videoPlayer:VideoPlayer):void {
      var contentView:VideoContentView = contentViews[videoPlayers.indexOf(videoPlayer)];
      
      videoPlayer.pause();
      // take screenshot
      Locator.instance.ui.gridView.bmp.bitmapData.draw(videoPlayer, new Matrix(1, 0, 0, 1, videoPlayer.x, videoPlayer.y));
      
      // dispose of video player
      videoPlayer.removeEventListener('video_end_reached', videoFinishedListener);
      videoPlayer.dispose();
      removeChild(videoPlayer);
      ArrayHelper.removeItemFromArray(videoPlayer, videoPlayers);
      
      // remove content view reference
      ArrayHelper.removeItemFromArray(contentView, contentViews);
      contentView.onVideoPlaybackComplete();
    }
    
    protected function videoFinishedListener(e:Event):void {
      var videoPlayer:VideoPlayer = e.currentTarget as VideoPlayer;
      removeVideoPlayerAndContentView(videoPlayer);
    }
  }
}