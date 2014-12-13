//
//  UIFont+OHAdditions.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 16/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import "UIFont+OHAdditions.h"

@implementation UIFont (OHAdditions)

+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                          bold:(BOOL)isBold
                        italic:(BOOL)isItalic
{
    UIFontDescriptorSymbolicTraits traits = 0;
    if (isBold) traits |= UIFontDescriptorTraitBold;
    if (isItalic) traits |= UIFontDescriptorTraitItalic;
    
    return [self fontWithFamily:fontFamily size:size traits:traits];
}

+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                        traits:(UIFontDescriptorSymbolicTraits)symTraits
{
    NSDictionary* attributes = @{ UIFontDescriptorFamilyAttribute: fontFamily,
                                  UIFontDescriptorTraitsAttribute: @{UIFontSymbolicTrait:@(symTraits)}};
    
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    return [UIFont fontWithDescriptor:desc size:size];
}

+ (instancetype)fontWithPostscriptName:(NSString*)postscriptName size:(CGFloat)size
{
    // UIFontDescriptorNameAttribute = Postscript name, should not change across iOS versions.
    NSDictionary* attributes = @{ UIFontDescriptorNameAttribute: postscriptName };
    
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    return [UIFont fontWithDescriptor:desc size:size];
}

- (instancetype)fontWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symTraits
{
    NSDictionary* attributes = @{UIFontDescriptorFamilyAttribute: self.familyName,
                                 UIFontDescriptorTraitsAttribute: @{UIFontSymbolicTrait:@(symTraits)}};
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    return [UIFont fontWithDescriptor:desc size:self.pointSize];
}

- (UIFontDescriptorSymbolicTraits)symbolicTraits
{
    return self.fontDescriptor.symbolicTraits;
}

@end
