/*******************************************************************************
 *
 * Copyright (c) 2010 Olivier Halligon
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 ******************************************************************************/


#import <UIKit/UIKit.h>

/**
 *  Convenience methods to create new `UIFont` instances and query font traits
 */
@interface UIFont (OHAdditions)

/**
 *  Returns a font given a family name, size, and whether it should be bold
 *  and/or italic.
 *
 *  If the font family is not found, this will return the "Helvetica" font with
 *  the requested size, but neither bold nor italics (This behavior is
 *  inherited by NSFontDescriptor's own native behavior)
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
 *  Returns a font given its Postscript Name and size
 *
 *  @note Font PostScript names are unlikely to change across OS versions
 *  (whereas it seems like common, display names may change)
 *
 *  @param postscriptName The PostScript name of the font
 *  @param size           The size of the font
 *
 *  @return The UIFont object with the specified PS name and size.
 */
+ (instancetype)fontWithPostscriptName:(NSString*)postscriptName
                                  size:(CGFloat)size;

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
