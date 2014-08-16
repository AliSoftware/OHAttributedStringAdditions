//
//  UIFont+OHAdditions.h
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 16/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (OHAdditions)

+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                          bold:(BOOL)isBold
                        italic:(BOOL)isItalic;

+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                        traits:(UIFontDescriptorSymbolicTraits)symTraits;

- (instancetype)fontWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symTraits;
- (UIFontDescriptorSymbolicTraits)symbolicTraits;

@end
