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


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  Convenience methods to modify `NSMutableAttributedString` instances
 */
@interface NSMutableAttributedString (OHAdditions)

/******************************************************************************/
#pragma mark - Text Font

/**
 *  Set the font for the whole attributed string.
 *
 *  The font of the whole attributed string will be overridden.
 *
 *  @param font The font to apply
 *
 *  @note You can take advantage of `UIFont+OHAdditions` category to create a
 *        font with a given family, size and traits.
 */
- (void)setFont:(UIFont*)font;

/**
 *  Set the font for the given range of characters.
 *
 *  @param font  The font to apply
 *  @param range The range of characters to which the font should apply.
 *
 *  @note You can take advantage of `UIFont+OHAdditions` category to create a
 *        font with a given family, size and traits.
 */
- (void)setFont:(UIFont*)font range:(NSRange)range;

/******************************************************************************/
#pragma mark - Text Color

/**
 *  Set the foreground text color for the whole attributed string.
 *
 *  @param color The foreground color to apply
 */
- (void)setTextColor:(UIColor*)color;

/**
 *  Set the foreground text color for the given range of characters.
 *
 *  @param color The foreground color to apply
 *  @param range The range of characters to which the color should apply.
 */
- (void)setTextColor:(UIColor*)color range:(NSRange)range;

/**
 *  Set the background text color for the whole attributed string.
 *
 *  @param color The background color to apply
 */
- (void)setTextBackgroundColor:(UIColor*)color;

/**
 *  Set the background text color for the given range of characters.
 *
 *  @param color The background color to apply
 *  @param range The range of characters to which the color should apply.
 */
- (void)setTextBackgroundColor:(UIColor*)color range:(NSRange)range;

/******************************************************************************/
#pragma mark - Text Underlining

/**
 *  Set the underline for the whole attributed string.
 *
 *  @param underlined `YES` if you want the text to be underlined, `NO` otherwise.
 *
 *  @note This is a convenience method that ends up calling
 *        `setTextUnderlineStyle:range:` with the value
 *        `(NSUnderlineStyleSingle|NSUnderlinePatternSolid)` if underlined is
 *        `YES`, `NSUnderlineStyleNone` if underlined is `NO`.
 */
- (void)setTextUnderlined:(BOOL)underlined;

/**
 *  Set the underline for the given range of characters.
 *
 *  @param underlined `YES` if you want the text to be underlined, `NO` otherwise.
 *  @param range The range of characters to which the underline should apply.
 *
 *  @note This is a convenience method that ends up calling
 *        `setTextUnderlineStyle:range:` with the value
 *        `(NSUnderlineStyleSingle|NSUnderlinePatternSolid)` if underlined is
 *        `YES`, `NSUnderlineStyleNone` if underlined is `NO`.
 */
- (void)setTextUnderlined:(BOOL)underlined range:(NSRange)range;

/**
 *  Set the underline style for the given range of characters.
 *
 *  @param style The underline style mask, like
 *               `NSUnderlineStyleSingle|NSUnderlinePatternDot` or
 *               `NSUnderlineStyleDouble|NSUnderlinePatternSolid` for example.
 *  @param range The range of characters to which the underline style should
 *               apply.
 */
- (void)setTextUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range;

/**
 *  Set the underline color for the whole attributed string
 *
 *  @param color The color to apply to the underlining. If nil, the underlining
 *               will be the same color as the text foreground color.
 */
- (void)setTextUnderlineColor:(UIColor*)color;

/**
 *  Set the underline color for the given range of characters.
 *
 *  @param color The color to apply to the underlining. If nil, the underlining
 *               will be the same color as the text foreground color.
 *
 *  @param range The range of characters to which the underline color should
 *               apply.
 */
- (void)setTextUnderlineColor:(UIColor*)color range:(NSRange)range;

/******************************************************************************/
#pragma mark - Text Style & Traits

/**
 *  Enumerates on every font in the attributed string, allowing you to
 *  easily give new font symbolic traits to each font enumerated.
 *
 *  This method is useful to easily change font traits of a whole attributed
 *  string without changing/overridding the font family of each font run. For
 *  example, you can use this method to add or remove the
 *  `UIFontDescriptorTraitItalic``, `UIFontDescriptorTraitBold`,
 *  `UIFontDescriptorTraitExpanded` and/or `UIFontDescriptorTraitCondensed`
 *  traits of every enumerated font.
 *
 *  @param block A block that takes the enumerated font symbolic traits as
 *               only parameter and returns the new symbolic font traits to
 *               apply.
 *
 *  @note This method also calls the enumeration block for ranges where no font
 *        is explicitly defined (no NSFontAttribute set); in such case, the
 *        traits of the [NSAttributedString defaultFont] are passed as first
 *        parameter of the block. The font attribute is then explicitly
 *        set (even if it did not exist before), to be able to change the font
 *        traits for those ranges as well instead of keeping the default.
 */
- (void)changeFontTraitsWithBlock:(UIFontDescriptorSymbolicTraits(^)(UIFontDescriptorSymbolicTraits currentTraits, NSRange aRange))block;

/**
 *  Enumerates on every font in the given range of characters, allowing you to
 *  easily give new font symbolic traits to each font enumerated.
 *
 *  This method is useful to easily change font traits of a whole range without
 *  changing/overridding the font family of each font run. For example, you can
 *  use this method to add or remove the `UIFontDescriptorTraitItalic`,
 *  `UIFontDescriptorTraitBold`, `UIFontDescriptorTraitExpanded` and/or
 *  `UIFontDescriptorTraitCondensed` traits of every enumerated font.
 *
 *  @param range The range of characters to which the traits should be
 *               enumerated
 *  @param block A block that takes the enumerated font symbolic traits as
 *               only parameter and returns the new symbolic font traits to
 *               apply.
 *
 *  @note This method also calls the enumeration block for ranges where no font
 *        is explicitly defined (no NSFontAttribute set); in such case, the
 *        traits of the [NSAttributedString defaultFont] are passed as first
 *        parameter of the block. The font attribute is then explicitly
 *        set (even if it did not exist before), to be able to change the font
 *        traits for those ranges as well instead of keeping the default.
 */
- (void)changeFontTraitsInRange:(NSRange)range
                      withBlock:(UIFontDescriptorSymbolicTraits(^)(UIFontDescriptorSymbolicTraits currentTraits, NSRange aRange))block;

/**
 *  Change every fonts of the attributed string to their bold variant.
 *
 *  @param isBold `YES` if you want to use bold font variants, `NO` if you want to
 *                use non-bold font variants.
 *
 *  @note This is a convenience method that calls
 *        `changeFontTraitsInRange:withBlock:` with a block that adds (`isBold`
 *        = `YES`) or remove (isBold = `NO`) the `UIFontDescriptorTraitBold`
 *        trait to each enumerated font.
 */
- (void)setFontBold:(BOOL)isBold;

/**
 *  Change the font of the given range of characters to its bold variant.
 *
 *  @param isBold `YES` if you want to use bold font variants, `NO` if you want to
 *                use non-bold font variants.
 *  @param range The range of characters to which the bold font should apply.
 *
 *  @note This is a convenience method that calls
 *        `changeFontTraitsInRange:withBlock:` with a block that adds (`isBold`
 *        = `YES`) or remove (isBold = `NO`) the `UIFontDescriptorTraitBold`
 *        trait to each enumerated font.
 */
- (void)setFontBold:(BOOL)isBold range:(NSRange)range;

/**
 *  Change every fonts of the attributed string to their italics variant.
 *
 *  @param isItalics `YES` if you want to use italics font variants,
 *                   `NO` if you want to use non-italics font variants.
 *
 *  @note This is a convenience method that calls
 *        `changeFontTraitsInRange:withBlock:` with a block that adds (
 *        `isItalics` = `YES`) or remove (isItalics = `NO`) the
 *        `UIFontDescriptorTraitItalic` trait to each enumerated font.
 */
- (void)setFontItalics:(BOOL)isItalics;

/**
 *  Change the font of the given range of characters to its italics variant.
 *
 *  @param isItalics `YES` if you want to use italics font variants,
 *                   `NO` if you want to use non-italics font variants.
 *  @param range The range of characters to which the italics font should apply.
 *
 *  @note This is a convenience method that calls
 *        changeFontTraitsInRange:withBlock: with a block that adds (isItalics =
 *        `YES`) or remove (`isItalics` = `NO`) the
 *        `UIFontDescriptorTraitItalic` trait to each enumerated font.
 */
- (void)setFontItalics:(BOOL)isItalics range:(NSRange)range;

/******************************************************************************/
#pragma mark - Link

/**
 *  Add an URL link to the given range of characters.
 *
 *  @param linkURL the URL to apply
 *  @param range The range of characters to which the URL should apply.
 */
- (void)setURL:(NSURL*)linkURL range:(NSRange)range;

/******************************************************************************/
#pragma mark - Character Spacing

/**
 *  Set the character spacing (kern attribute) of the whole attributed string
 *
 *  @param characterSpacing The character spacing. This value specifies the
 *                          number of points by which to adjust kern-pair
 *                          characters. A value of 0 disables kerning.
 *
 *  @note For more info about typographical concepts, kerning and text layout,
 *       see the [Text Programming Guide](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/TypoFeatures/TextSystemFeatures.html#//apple_ref/doc/uid/TP40009542-CH6-51627-BBCCHIFF)
 */
- (void)setCharacterSpacing:(CGFloat)characterSpacing;

/**
 *  Set the character spacing (kern attribute) of the given range of characters.
 *
 *  @param characterSpacing The character spacing. This value specifies the
 *                          number of points by which to adjust kern-pair
 *                          characters. A value of 0 disables kerning.
 *  @param range The range of characters to which the character spacing
 *               (kerning) should apply.
 *
 *  @note For more info about typographical concepts, kerning and text layout,
 *       see the [Text Programming Guide](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/TypoFeatures/TextSystemFeatures.html#//apple_ref/doc/uid/TP40009542-CH6-51627-BBCCHIFF)
 */
- (void)setCharacterSpacing:(CGFloat)characterSpacing range:(NSRange)range;

/******************************************************************************/
#pragma mark - Subscript and Superscript

/**
 *  Set the baseline offset of the whole attributed string.
 *
 *  @param offset The character's offset from the baseline, in points.
 */
- (void)setBaselineOffset:(CGFloat)offset;

/**
 *  Set the baseline offset of the given range of characters.
 *
 *  @param offset The character's offset from the baseline, in points.
 *  @param range The range of characters to which the baseline offset should
 *               apply.
 */
- (void)setBaselineOffset:(CGFloat)offset range:(NSRange)range;

/**
 *  Set the given range of characters to be superscripted, meaning that
 *  they have a positive offset above the baseline and have a font half the
 *  current font size.
 *
 *  @param range The range of characters to which the superscript should apply.
 *
 *  @note This is a convenient method that calls -setBaselineOffset:range:
 *        using a positive offset of half of the pointSize of the font at the
 *        range's start location
 */
- (void)setSuperscriptForRange:(NSRange)range;

/**
 *  Set the given range of characters to be subscripted, meaning that
 *  they have a negative offset below the baseline and have a font half the
 *  current font size.
 *
 *  @param range The range of characters to which the subscript should apply.
 *
 *  @note This is a convenient method that calls -setBaselineOffset:range:
 *        using a negative offset of half of the pointSize of the font at the
 *        range's start location
 */
- (void)setSubscriptForRange:(NSRange)range;

/******************************************************************************/
#pragma mark - Paragraph Style

/**
 *  Set the paragraph's text alignment for the whole attributed string.
 *
 *  @param alignment The paragraph's text alignment to apply
 */
- (void)setTextAlignment:(NSTextAlignment)alignment;

/**
 *  Set the paragraph's text alignment for the given range of characters.
 *
 *  @param alignment The paragraph's text alignment to apply
 *  @param range The range of characters to which the text alignment should
 *               apply.
 */
- (void)setTextAlignment:(NSTextAlignment)alignment range:(NSRange)range;

/**
 *  Set the paragraph's line break mode for the whole attributed string.
 *
 *  @param lineBreakMode The paragraph's line break mode to apply
 */
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode;

/**
 *  Set the paragraph's line break mode for the given range of characters.
 *
 *  @param lineBreakMode The paragraph's line break mode to apply
 *  @param range The range of characters to which the line break mode should
 *               apply.
 */
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/**
 *  This methods allows you to change only certain Paragraph Styles properties
 *  without changing the others (for example changing the firstLineHeadIndent
 *  or line spacing without overriding the textAlignment).
 *
 *  It is useful as NSParagraphStyle objects carry multiple text styles in only
 *  one common attribute, but you sometimes want to change only one of the text
 *  style without altering the others.
 *
 *  @param block A block that takes the mutable paragraph style as the only
 *               parameter, allowing you to change its properties.
 *
 *  @note This method actually enumerate all paragraph styles of your
 *        attributed string, create a mutable copy of the NSParagraphStyle to
 *        pass it to the block, then reapply the modified paragraph style to
 *        the original range.
 *
 *  @note This method also calls the enumeration block for ranges where no
 *        paragraph style is explicitly defined (no NSParagraphStyleAttribute
 *        set); in such case, the [NSParagraphStyle defaultStyle] is passed as
 *        first parameter of the block. The paragraph style attribute is then
 *        explicitly set (even if it did not exist before), to be able to change
 *        the paragraph style for those ranges as well instead of keeping the default
 */
- (void)changeParagraphStylesWithBlock:(void(^)(NSMutableParagraphStyle* currentStyle, NSRange aRange))block;

/**
 *  This methods allows you to change only certain Paragraph Styles properties
 *  without changing the others (for example changing the firstLineHeadIndent
 *  or line spacing without overriding the textAlignment).
 *
 *  It is useful as NSParagraphStyle objects carry multiple text styles in only
 *  one common attribute, but you sometimes want to change only one of the text
 *  style without altering the others.
 *
 *  @param range The range of characters to which the paragraph style
 *               modifications should apply.
 *  @param block A block that takes the mutable paragraph style as the only
 *               parameter, allowing you to change its properties.
 *
 *  @note This method actually enumerate all paragraph styles in the given
 *        range of your attributed string, create a mutable copy of the
 *        NSParagraphStyle to pass it to the block, then reapply the modified
 *        paragraph style to the original range.
 *
 *  @note This method also calls the enumeration block for ranges where no
 *        paragraph style is explicitly defined (no NSParagraphStyleAttribute
 *        set); in such case, the [NSParagraphStyle defaultStyle] is passed as
 *        first parameter of the block. The paragraph style attribute is then
 *        explicitly set (even if it did not exist before), to be able to change
 *        the paragraph style for those ranges as well instead of keeping the default
 */
- (void)changeParagraphStylesInRange:(NSRange)range
                           withBlock:(void(^)(NSMutableParagraphStyle* currentStyle, NSRange aRange))block;

/**
 *  Override the Paragraph Styles, dropping the ones previously set if any.
 *  Be aware that this will override the text alignment, linebreakmode, and all
 *  other paragraph styles with the new values.
 *
 *  @param style The new paragraph style to apply
 */
- (void)setParagraphStyle:(NSParagraphStyle *)style;

/**
 *  Override the Paragraph Styles of the given range of characters, dropping
 *  the ones previously set if any.
 *  Be aware that this will override the text alignment, linebreakmode, and all
 *  other paragraph styles in the given range with the new values.
 *
 *  @param style The new paragraph style to apply
 *  @param range The range of characters to which the paragraphe style should
 *               apply.
 */
- (void)setParagraphStyle:(NSParagraphStyle*)style range:(NSRange)range;

@end
