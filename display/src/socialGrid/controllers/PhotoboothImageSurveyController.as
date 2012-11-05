package socialGrid.controllers {
  
  import flash.display.Bitmap;
  import flash.display.Loader;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.TimerEvent;
  import flash.net.URLRequest;
  import flash.utils.Timer;
  
  import socialGrid.core.Locator;
  import socialGrid.models.content.PhotoboothImageContentVO;
  import socialGrid.util.ArrayHelper;
  import socialGrid.util.PhotoboothImageSurvey;
  
  public class PhotoboothImageSurveyController {
    
    protected var surveyTimer:Timer;
    protected var survey:PhotoboothImageSurvey;
    
    protected var imagesToLoad:Array;
    
    protected var imageLoader:Loader;
    
    protected var isLoadingImage:Boolean;
    
    public function PhotoboothImageSurveyController() {
      
      survey = new PhotoboothImageSurvey();
      
      surveyTimer = new Timer(1000);
      surveyTimer.addEventListener(TimerEvent.TIMER, surveyTimerListener);
      
      imageLoader = new Loader();
      imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageLoaderCompleteListener);
      imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageLoaderErrorListener);
      
      imagesToLoad = new Array();
    }
    
    public function start():void {
      surveyTimer.start();
    }
    
    protected function surveyPhotoboothImages():void {
      var photoboothImageUrls:Array = survey.surveyPhotoboothImages();
      //trace(photoboothImageUrls.length + ' new photobooth images found');
      var url:String;
      for each (url in photoboothImageUrls) {
        ArrayHelper.addItemToArray(url, imagesToLoad);
      }
      loadNextImage();
    }
    
    protected function loadNextImage():void {
      if (isLoadingImage || !imagesToLoad.length) { return; }
      isLoadingImage = true;
      imageLoader.load(new URLRequest(imagesToLoad.shift()));
    }
    
    protected function surveyTimerListener(e:TimerEvent):void {
      surveyPhotoboothImages();
    }
    
    protected function imageLoaderCompleteListener(e:Event):void {
      //trace('photobooth image load complete!');
      
      var bmp:Bitmap = Bitmap(imageLoader.content);
      var photoboothImageContentVO:PhotoboothImageContentVO = new PhotoboothImageContentVO(bmp.bitmapData.clone());
      bmp.bitmapData.dispose();
      
      Locator.instance.appModel.contentModel.addContentVO(photoboothImageContentVO);
      
      isLoadingImage = false;
      loadNextImage();
    }
    
    protected function imageLoaderErrorListener(e:IOErrorEvent):void {
      //trace('photobooth image load error');
      isLoadingImage = false;
      loadNextImage();
    }
  }
}