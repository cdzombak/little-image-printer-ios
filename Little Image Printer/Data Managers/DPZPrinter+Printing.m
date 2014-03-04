//
//  DPZPrinter+Printing.m
//  Little Image Printer
//
//  Created by Chris Dzombak on 3/3/14.
//  Copyright (c) 2014 David Wilkinson. All rights reserved.
//

#import "DPZPrinter+Printing.h"

#import <dispatch/dispatch.h>
#import "DPZAppDelegate.h"
#import "DPZImageProcessor.h"
#import "NSString+DPZURLEncode.h"

@implementation DPZPrinter (Printing)

- (void)printImage:(UIImage *)image context:(id)context withCompletionBlock:(DPZPrintCompletionBlock)completionBlock
{
    NSParameterAssert(image);
    
    void(^wrappedCompletionBlock)(BOOL, NSError*) = ^(BOOL success, NSError *error) {
        if (completionBlock) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionBlock(success, error, context);
            });
        }
    };
    
    NSString *printerCode = [self.code copy];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSError *htmlError;
        NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"print" ofType:@"html"];
        NSString *html = [NSMutableString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:&htmlError];
        
        if (htmlError || !html) {
            wrappedCompletionBlock(NO, htmlError);
            return;
        }
        
        DPZImageProcessor *imageProcessor = [[DPZImageProcessor alloc] initWithSourceImage:image];
        NSData *imageData = [imageProcessor generateJPG];
        NSString *contentType = @"image/jpg";
        
        NSString *dataUri = [NSString stringWithFormat:@"data:%@;base64,%@", contentType, [imageData base64EncodedStringWithOptions:(NSDataBase64EncodingOptions)0]];
        NSString *ditherClass = @"dither";
            
        NSString *finalHTML = [[html stringByReplacingOccurrencesOfString:@"_IMAGECLASS_" withString:ditherClass]
                               stringByReplacingOccurrencesOfString:@"_IMAGEURL_" withString:dataUri];
        NSString *urlEncodedHtml = [finalHTML dpz_urlEncode];
        
        NSString *body = [NSString stringWithFormat:@"html=%@", urlEncodedHtml];
        
        NSString *urlString = [NSString stringWithFormat:@"http://remote.bergcloud.com/playground/direct_print/%@", printerCode];
        NSURL *url = [NSURL URLWithString:urlString];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:[body dataUsingEncoding:NSUTF8StringEncoding]];
            
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:NO];
            
            NSAssert([response isKindOfClass:[NSHTTPURLResponse class]], @"Expected an HTTP response in %s", __PRETTY_FUNCTION__);
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            
            if (httpResponse.statusCode == 200) {
                wrappedCompletionBlock(YES, nil);
            } else {
                if (httpResponse.statusCode == 401) {
                    NSLog(@"Printer with print code %@ does not exist.", printerCode);
                }
                wrappedCompletionBlock(NO, error);
            }
        }];
        
        [(DPZAppDelegate *)[UIApplication sharedApplication].delegate setNetworkActivityIndicatorVisible:YES];
        [task resume];
    });
}

@end
