//
//  Printer.h
//  Little Image Printer
//
//  Created by David Wilkinson on 04/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

@interface DPZPrinter : NSManagedObject

@property (nonatomic, retain) NSString *code;
@property (nonatomic, retain) NSString *name;

+ (NSString *)entityName;

@end
