//
//  Uploader.m
//  PhotoBooth
//
//  Created by Ben Purdy on 10/23/12.
//
//

#include "FileSender.h"

#import "Uploader.h"
#import <UIKit/UIKit.h>

@implementation Uploader

+ ( void )open:(UIImage *)img
{
    // prepare some strings to use in the post
    NSString *urlString     = [[NSUserDefaults standardUserDefaults] stringForKey:@"post_url"];
    NSString *sourceName    = [[NSUserDefaults standardUserDefaults] stringForKey:@"source_id"];
    NSString *endOfLine     = @"\r\n";
    NSString *boundary      = @"---------------------------14737809831466499882746641449";
    NSString *contentType   = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    NSData *imageData       = UIImageJPEGRepresentation(img, 90);
    NSMutableData *body     = [NSMutableData data];
 
    
    // construct the actual post body
    
    // Add "source" parameter to post (so multiple sources can be used if needed)
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary, endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"source\"%@%@", endOfLine, endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@%@", sourceName, endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];

    // Add the image data
    [body appendData:[[NSString stringWithFormat:@"--%@%@", boundary, endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: attachment; name=\"image\"; filename=\"image.jpg\"%@", endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg%@%@", endOfLine, endOfLine] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    
    [body appendData:[endOfLine dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"--%@--", boundary] dataUsingEncoding:NSUTF8StringEncoding]];

    // instantiate the request and set properties.
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:body];
    
    [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];

    NSLog(@"Finished Uploading.");
}

@end


void FileSender::sendFile( cinder::cocoa::SafeUiImage &img )
{
    // image needs to be flipped.  This could be done in cinder as well but UIImage has a nice quick way to do it.
    UIImage* flippedImage = [UIImage imageWithCGImage:((UIImage *)img).CGImage
                                               scale:1.0 orientation: UIImageOrientationUpMirrored];
    
    [Uploader open:flippedImage];
}
