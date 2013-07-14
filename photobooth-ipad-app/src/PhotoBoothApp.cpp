#include "cinder/app/AppCocoaTouch.h"
#include "cinder/app/Renderer.h"
#include "cinder/ImageIo.h"
#include "cinder/Surface.h"
#include "cinder/gl/gl.h"
#include "cinder/gl/Texture.h"
#include "cinder/gl/TextureFont.h"
#include "cinder/gl/Fbo.h"
#include "cinder/TriMesh.h"
#include "cinder/Camera.h"
#include "cinder/Timeline.h"

#include "cinder/gl/Texture.h"
#include "cinder/ip/Flip.h"
#include "cinder/Capture.h"

#include "FileSender.h"

#include <string>
#include <sstream>


using namespace ci;
using namespace ci::app;
using namespace std;


// Super-cheesey way to handle retina/non-retina displays.
#define DISPLAY_SCALE       0.5

#define CAM_WIDTH           640
#define CAM_HEIGHT          480


#define STATE_PREVIEW       1
#define STATE_COUNT_DOWN    2
#define STATE_ACCEPT        3


class PhotoBoothApp : public AppCocoaTouch {
    
  public:
    
	virtual void	setup();
	virtual void	update();
	virtual void	draw();
    virtual void	quit();
    
    void	touchesBegan( TouchEvent event );
    
    int width, height;
    
	Capture				mCapture;
	gl::Texture			mCameraTexture;
    Surface             mCameraSurface;
    gl::Texture         mPreviewTexture;
    Anim<Vec2f>         mPreviewTexturePos;
    
    double              mCountDownStartTime;
    int                 mCountDownNumber;
    float               mCountDownFractional;
    Anim<float>         mCameraFlash;
    
    int                 mCurrentState;
    
    gl::Texture         mCameraButtonTexture;
    gl::Texture         mIntroTexture;
    gl::Texture         mLightBg;
    gl::Texture         mDarkBg;
    
    Anim<Vec2f>         mCameraButtonPos;
    
    vector<gl::Texture> mNumberTextures;
    gl::Texture         mNumberBg;
    gl::Texture         mNumberProgress;
    
    Anim<float>         mDarkBgAlpha;
    
    gl::Texture         mConfirmMessage;
    gl::Texture         mSaveTexture;
    gl::Texture         mDiscardTexture;
    
    Anim<Vec2f>         mSavePos, mDiscardPos;
};

void PhotoBoothApp::setup()
{
    // Start cameara.
    try{
        
        vector<Capture::DeviceRef> devices( Capture::getDevices() );
        
        // Look for a camera called "Front Camera"
        for( vector<Capture::DeviceRef>::const_iterator deviceIt = devices.begin(); deviceIt != devices.end(); ++deviceIt ) {
            Capture::DeviceRef device = *deviceIt;
            
            if(device->getName() == "Front Camera"){
                mCapture = Capture( CAM_WIDTH, CAM_HEIGHT, device );
                mCapture.start();
            }
        }
	}
	catch( ... ) {
		console() << "Failed to initialize camera" << std::endl;
	}
    
    // Load textures
    mConfirmMessage         = loadImage( loadResource("assets/confirm_message.png"));
    mSaveTexture            = loadImage( loadResource("assets/save.png"));
    mDiscardTexture         = loadImage( loadResource("assets/discard.png"));
    mCameraButtonTexture    = loadImage( loadResource("assets/camera.png"));
    mIntroTexture           = loadImage( loadResource("assets/attract.png" ));
    mLightBg                = loadImage( loadResource("assets/bkg_light.png" ));
    mDarkBg                 = loadImage( loadResource("assets/bkg_dark.png" ));
    mNumberBg               = loadImage( loadResource("assets/countdown_bkg.png") );
    mNumberProgress         = loadImage( loadResource("assets/countdown_progress.png") );
    
    mNumberTextures.push_back( loadImage( loadResource("assets/countdown_5.png")));
    mNumberTextures.push_back( loadImage( loadResource("assets/countdown_4.png")));
    mNumberTextures.push_back( loadImage( loadResource("assets/countdown_3.png")));
    mNumberTextures.push_back( loadImage( loadResource("assets/countdown_2.png")));
    mNumberTextures.push_back( loadImage( loadResource("assets/countdown_1.png")));

    width               = getWindowWidth() / DISPLAY_SCALE;
	height              = getWindowHeight() / DISPLAY_SCALE;
    
    mCurrentState       = STATE_PREVIEW;
    
    mDiscardPos         = Vec2f(100, height + 100 );
    mSavePos            = Vec2f(width - 700, height + 100);
    mCameraButtonPos    = Vec2f(width/2 - mCameraButtonTexture.getWidth() / 2, 650 - mCameraButtonTexture.getHeight() / 2);
}


void PhotoBoothApp::quit(){
    if(mCapture.isCapturing()){
        mCapture.stop();
    }
}


void PhotoBoothApp::touchesBegan( TouchEvent event ){

    TouchEvent::Touch touch = event.getTouches().front();
    Vec2f cameraButtonTargetPos = Vec2f(mCameraButtonPos.value());
    
    float touchX = touch.getX() / DISPLAY_SCALE;
    float touchY = touch.getY() / DISPLAY_SCALE;
    
    switch(mCurrentState) {
        case STATE_PREVIEW:
        
            // see if the camera icon has been tapped (touch coordinates are reversed for landscape mode)
            
            cameraButtonTargetPos.x += mCameraButtonTexture.getWidth() / 2.0f;
            cameraButtonTargetPos.y += mCameraButtonTexture.getHeight() / 2.0f;
            
            if( cameraButtonTargetPos.distance( Vec2f(touchX, touchY) ) < (mCameraButtonTexture.getWidth() * 2) ) {
               mCountDownStartTime = getElapsedSeconds();
               mCurrentState = STATE_COUNT_DOWN;
            }
        
        break;

        case STATE_COUNT_DOWN:
            // stub..
        break;
        
        case STATE_ACCEPT:
            
            if(touchY > 1280) { // only look for touches near the bottom of the screen.
                
                // just split the screen in half, no need to do precise hit detection for save/cancel buttons..
                if(touchX > width / 2){
                    
                    ip::flipVertical( &mCameraSurface );
                    cinder::cocoa::SafeUiImage img = cocoa::createUiImage( mCameraSurface );
                    
                    
                    // Call into objective C to do upload via cocoa
                    FileSender::sendFile(img);

                    
                    timeline().apply( &mPreviewTexturePos, Vec2f(0, -height ), 1.0f, EaseInCubic() );
                    
                }else{
                    timeline().apply( &mPreviewTexturePos, Vec2f(0, height ), 1.0f, EaseInBack() );
                }
                
                mCurrentState = STATE_PREVIEW;
                
                timeline().apply( &mDarkBgAlpha, 0.0f, 1.0f, EaseInCubic() );
                
                // Hide buttons
                timeline().apply( &mDiscardPos, Vec2f(100, height + 100 ), 1.0f, EaseInCubic() );
                timeline().apply( &mSavePos, Vec2f(width-700, height + 100 ), 1.0f, EaseInCubic() );
            }
        break;
    }
}


void PhotoBoothApp::update()
{
    if(mCurrentState == STATE_COUNT_DOWN){
        
        mCountDownNumber = int(getElapsedSeconds() - mCountDownStartTime);
        mCountDownFractional = (getElapsedSeconds() - mCountDownStartTime) - int(getElapsedSeconds() - mCountDownStartTime);
        
        // check to see if the count-down has hit the end.
        if(mCountDownNumber == mNumberTextures.size()){
            mCameraFlash = 1;
            mDarkBgAlpha = 1;
            mCurrentState = STATE_ACCEPT;
            
            mPreviewTexturePos = Vec2f(0,0);
            mPreviewTexture = gl::Texture( mCameraTexture );
            
            timeline().apply( &mCameraFlash, 0.0f, 0.8f, EaseOutCubic() );
            
            // Show buttons
            timeline().apply( &mDiscardPos, Vec2f(100, height-200), 1.0f, EaseOutQuint() ).delay(0.25f);
            timeline().apply( &mSavePos, Vec2f(width-700, height-200), 1.0f, EaseOutQuint() ).delay(0.50f);
        }
    }
    
    // don't update the camera texture after the snapshot has been taken.
    if( mCapture && mCapture.checkNewFrame() && (mCurrentState != STATE_ACCEPT) ) {
        mCameraSurface = mCapture.getSurface();
		mCameraTexture = gl::Texture( mCapture.getSurface() );
	}
}


void PhotoBoothApp::draw()
{
    gl::enableAlphaBlending();
    
    gl::clear();
    gl::color(1, 1, 1, 1);
    glDepthMask( GL_FALSE );

    // Set up the view for landscape mode.
	gl::setMatricesWindow(width * DISPLAY_SCALE, height * DISPLAY_SCALE);
    gl::scale(DISPLAY_SCALE, DISPLAY_SCALE);
    
    // draw the live camera preview
	if( mCameraTexture ) {
        // flip the texture vertically
        mCameraTexture.setFlipped(false);
        
        // draw the texture mirrored.
        gl::draw( mCameraSurface, Rectf(width, 0, 0, height) );
	}

    // draw "idle" stuff (text and images overlayed on the live camera preview)
    if(mCurrentState == STATE_PREVIEW){
        gl::color(1, 1, 1, 0.75f);
        gl::draw(mLightBg, Rectf(0, 0, width, height));
        gl::color(1, 1, 1, 1);
        gl::draw(mIntroTexture, Rectf(0,0,width, height));
        
        gl::draw(mCameraButtonTexture, mCameraButtonPos.value() - Vec2f(0, abs( sin(getElapsedSeconds() * 3) * 30)));

        
        //gl::draw(mCameraButtonTexture, Rectf(mCameraButtonPos.value().x,mCameraButtonPos.value().y, mCameraButtonTexture.getWidth() * 0.5 + mCameraButtonPos.value().x, mCameraButtonTexture.getHeight() * 0.5 + mCameraButtonPos.value().y) );//  mCameraButtonPos.value() );
    }
        
    // Draw the preview image with dark background.
    if(mPreviewTexture){
        
        // draw background image and prompt text.
        if(mDarkBgAlpha > 0){
            gl::color(1, 1, 1, mDarkBgAlpha);
            gl::draw(mDarkBg, Vec2f::zero());
            gl::draw(mConfirmMessage, Vec2f(width/2 - mConfirmMessage.getWidth() / 2, 125 - mConfirmMessage.getHeight() / 2));
        }
        
        float aspect = mPreviewTexture.getAspectRatio();
        
        float imageHeight = height - 500; // margins are keyed off of hard-coded height, this is not very multi-resolution friendly.
        float imageWidth = imageHeight * aspect;
        
        float marginX = (width - imageWidth) / 2;
        float marginY = (height - imageHeight) / 2;
        
        gl::draw(mPreviewTexture, Rectf(marginX, marginY, width - marginX, height - marginY) + mPreviewTexturePos);
        

        // Draw semi-transparent pillar boxes to show how the sqare version of the image will look.
        if(mCurrentState == STATE_ACCEPT) {
            float pillarWidth = (imageWidth - imageHeight) / 2;
            gl::color(0, 0, 0, 0.35f);
            gl::drawSolidRect( Rectf( marginX, height - marginY, pillarWidth + marginX, marginY ) );
            gl::drawSolidRect( Rectf( width - marginX - pillarWidth, height - marginY, width - marginX, marginY ) );
        }
    }
    
    // draw the "flash"
    if(mCurrentState == STATE_ACCEPT){
        gl::color(1, 1, 1, mCameraFlash);
        gl::drawSolidRect( Rectf(0, 0, width, height));
    }
    
    // draw count-down timer
    if(mCurrentState == STATE_COUNT_DOWN){
        
        // draw dark circle background
        Vec2f centerPos = Vec2f(width / 2 - mNumberBg.getWidth() / 2, height / 2 - mNumberBg.getHeight() / 2);
        gl::draw( mNumberBg, centerPos);
        
        // background ring that "fills up" for each second.
        gl::draw(mNumberProgress, Area(0, mNumberProgress.getHeight() * mCountDownFractional, mNumberProgress.getWidth(), mNumberProgress.getHeight()), Rectf(centerPos.x,centerPos.y+mNumberProgress.getHeight() * mCountDownFractional, mNumberBg.getWidth()+centerPos.x, centerPos.y+mNumberBg.getHeight()));
        
        // Draw number.
        gl::enableAdditiveBlending();
        gl::draw( mNumberTextures[mCountDownNumber], centerPos);
    }

    gl::color(1, 1, 1, 1);
    gl::draw(mSaveTexture, mSavePos);
    gl::draw(mDiscardTexture, mDiscardPos);
}

CINDER_APP_COCOA_TOUCH( PhotoBoothApp, RendererGl )
