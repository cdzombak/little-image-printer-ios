//
//  DPZImageProcessor.h
//  Little Image Printer
//
//  Created by David Wilkinson on 02/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

@interface DPZImageProcessor : NSObject

- (id)initWithSourceImageURL:(NSURL *)sourceImageURL;
- (id)initWithSourceImage:(UIImage *)sourceImage;
- (UIImage *)processImage;
- (NSData *)generatePNG;
- (NSData *)generateJPG;

@property (nonatomic, assign) CGFloat brightness;
@property (nonatomic, assign) CGFloat contrast;

@end
