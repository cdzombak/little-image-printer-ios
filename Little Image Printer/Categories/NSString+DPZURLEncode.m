//
//  NSString+DPZURLEncode.m
//
//  Created by David Wilkinson on 26/08/2012.
//  Copyright (c) 2012 David Wilkinson. All rights reserved.
//

#import "NSString+DPZURLEncode.h"

@implementation NSString (DPZURLEncode)

- (NSString*)dpz_urlEncode
{
    NSString *s = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                        (__bridge CFStringRef)self,
                                                                                        NULL,
                                                                                        (CFStringRef)@":/?#[]@!$ &'()*+,;=\"<>%{}|\\^~`",
                                                                                        CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return s;
}

- (NSString *)dpz_urlDecode
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
