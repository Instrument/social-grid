//
//  FileSender.h
//  PhotoBooth
//
//  Created by Ben Purdy on 10/23/12.
//
//

#ifndef PhotoBooth_FileSender_h
#define PhotoBooth_FileSender_h

#include <string>
#include "cinder/app/AppCocoaTouch.h"

class FileSender{
public:
    static void sendFile( cinder::cocoa::SafeUiImage &img );
};


#endif
