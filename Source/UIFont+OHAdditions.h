//
//  UIFont+OHAdditions.h
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 16/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (OHAdditions)

/**
 *  Returns a font given a family name, size, and whether it should be bold
 *  and/or italic.
 *
 *  @param fontFamily The name of the font family, like "Helvetica"
 *  @param size       The size of the font to return
 *  @param isBold     YES if you need the bold variant of the font
 *  @param isItalic   YES if you need the italic variant of the font
 *
 *  @return The corresponding UIFont.
 *
 *  @note This is a convenience method that calls +fontWithFamily:size:traits:
 *        with the traits corresponding to the bold and/or italic flags.
 */
+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                          bold:(BOOL)isBold
                        italic:(BOOL)isItalic;

/**
 *  Returns a font given a family name, size and symbolic traits.
 *
 *  @param fontFamily The name of the font family, like "Helvetica"
 *  @param size       The size of the font to return
 *  @param symTraits  A mask of symbolic traits, combined as an bitwise-OR mask.
 *         e.g. UIFontDescriptorTraitBold|UIFontDescriptorTraitCondensed
 *
 *  @return The corresponding UIFont.
 */
+ (instancetype)fontWithFamily:(NSString*)fontFamily
                          size:(CGFloat)size
                        traits:(UIFontDescriptorSymbolicTraits)symTraits;

/**
 *  Returns a font with the same family name, size and attributs as the
 *  receiver, but with the new symbolic  traits replacing the current ones
 *
 *  @param symTraits The new symbolic traits to use for the derived font
 *
 *  @return The UIFont variant  corresponding to the receiver but with the
 *          new symbolic traits
 */
- (instancetype)fontWithSymbolicTraits:(UIFontDescriptorSymbolicTraits)symTraits;

/**
 *  Returns the symbolic traits of the font, telling if its bold, italics, etc.
 *
 *  @return The font symbolic traits, as returned by its font descriptor.
 *
 *  @note This is a convenience method that simply calls
 *        fontDescriptor.symbolicTraits on the receiver.
 */
- (UIFontDescriptorSymbolicTraits)symbolicTraits;

@end
