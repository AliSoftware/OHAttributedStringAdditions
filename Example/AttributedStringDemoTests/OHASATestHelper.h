//
//  OHASATestHelper.h
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 07/09/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OHASATestHelper : NSObject

@end

NSSet* attributesSetInString(NSAttributedString* str);
UIFont* fontWithPostscriptName(NSString* postscriptName, CGFloat size);
