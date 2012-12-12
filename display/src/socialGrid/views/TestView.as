package socialGrid.views {
  
  import flash.display.Bitmap;
  import flash.display.BitmapData;
  import flash.display.Sprite;
  import flash.geom.Matrix;
  
  import socialGrid.models.content.InstagramContentVO;
  import socialGrid.models.content.TwitterContentVO;
  import socialGrid.models.posts.InstagramPostVO;
  import socialGrid.models.posts.TwitterPostVO;
  
  public class TestView extends Sprite {
    
    public function TestView() {
      
      // make canvas
      
      var bmp:Bitmap = new Bitmap();
      addChild(bmp);
      bmp.bitmapData = new BitmapData(1280, 768, true, 0x00000000);
      
      // make fake data
      
      var twitterPostVO:TwitterPostVO = new TwitterPostVO();
      twitterPostVO.tweetText = 'PASSION PIT IS GOING TO BE A GREAT SHOW. CHECK OUT THEIR LATEST VIDEO: HTTP://T.CO/II7IMCHF';
      twitterPostVO.postTimestamp = new Date().time;
      twitterPostVO.authorHandle = '@PRISCILABACELAR';
      twitterPostVO.authorName = 'PRICILA R BACELAR';
      twitterPostVO.normalizeData();
      var twitterContentVO:TwitterContentVO = new TwitterContentVO(twitterPostVO);
      
      var instagramPostVO:InstagramPostVO = new InstagramPostVO();
      instagramPostVO.authorHandle = '@Swedeman';
      instagramPostVO.caption = 'WHAT A FESTIVAL, WILL DEFINITELY BE BACK #NEXTYEAR! IF MY MESSAGE GOES @MULTIPLE LINES THAT’S http://OK.com.';
      instagramPostVO.imageData = new BitmapData(512, 512, true, 0xff0a201d);
      var instagramContentVO:InstagramContentVO = new InstagramContentVO(instagramPostVO);
      
      // draw stuff
      
      bmp.bitmapData.draw(twitterContentVO.renderedData('3x3'), new Matrix(1, 0, 0, 1, 0, 0));
      bmp.bitmapData.draw(instagramContentVO.renderedData('2x2'), new Matrix(1, 0, 0, 1, 768, 0));
      bmp.bitmapData.draw(twitterContentVO.renderedData('1x1'), new Matrix(1, 0, 0, 1, 768, 512));
    }
  }
}