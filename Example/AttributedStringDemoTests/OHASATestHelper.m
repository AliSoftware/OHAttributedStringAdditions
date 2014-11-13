//
//  OHASATestHelper.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 07/09/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import "OHASATestHelper.h"

@implementation OHASATestHelper

@end

NSSet* attributesSetInString(NSAttributedString* str)
{
    NSMutableSet* set = [NSMutableSet set];
    [str enumerateAttributesInRange:NSMakeRange(0, str.length)
                            options:0
                         usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop)
     {
         if (attrs.count > 0) [set addObject:@[@(range.location),@(range.length),attrs]];
     }];
    return [NSSet setWithSet:set];
}

UIFont* fontWithPostscriptName(NSString* postscriptName, CGFloat size)
{
    NSDictionary* attributes = @{ UIFontDescriptorNameAttribute: postscriptName }; // UIFontDescriptorNameAttribute = Postscript name, should not change across iOS versions.
    
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    return [UIFont fontWithDescriptor:desc size:size];
}
