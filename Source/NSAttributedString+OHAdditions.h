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
 *  Convenience methods to create and manipulate `NSAttributedString` instances
 */
@interface NSAttributedString (OHAdditions)

/******************************************************************************/
#pragma mark - Convenience Constructors

/**
 *  Build an NSAttributedString from a plain NSString
 *
 *  @param string The string to build the attributed string from. May be `nil`.
 *
 *  @return A new attributed string with the given string and default attributes
 *
 *  @note This is a convenience method around alloc/initWithString but which
 *        allows the parameter to be `nil`. If you pass `nil`, this method will
 *        return an empty NSAttributedString.
 */
+ (instancetype)attributedStringWithString:(NSString*)string;


/**
 *  Build an NSAttributedString from a format and arguments, (like `stringWithFormat:`)
 *
 *  @param format The format to build the attributed string from. You can use every
 *                placeholder that you usually use in `-[NSString stringWithFormat:]`
 *
 *  @return A new attributed string with the formatted string and default attributes
 *
 *  @note This is a convenience method that calls `-[NSAttributedString initWithString:]`
 *        with its parameter build from `-[NSString stringWithFormat:]`.
 */
+ (instancetype)attributedStringWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);

/**
 *  Build an NSAttributedString from another NSAttributedString
 *
 *  @param attrStr The attributed string to build the attributed string from.
 *                 May be `nil`.
 *
 *  @return A new NSAttributedString with the same content as the original
 *
 *  @note This method is generally only useful to build:
 *
 *         - an NSAttributedString from an NSMutableAttributedString
 *         - or an NSMutableAttributedString from an NSAttributedString
 */
+ (instancetype)attributedStringWithAttributedString:(NSAttributedString*)attrStr;

/**
 *  Build an NSAttributedString from HTML text.
 *
 *  The HTML import mechanism is meant for implementing something like markdown
 *  (that is, text styles, colors, and so on), not for general HTML import.
 *
 *  @param htmlString The HTML string to build the attributed string from
 *
 *  @return An NSAttributedString build from the HTML markup,
 *          or `nil` if `htmlString` cannot be parsed.
 *
 *  @note **Important**
 *
 *        When this method is called from a thread other than the
 *        main thread, the call will be dispatched synchronously on the main
 *        thread (because the HTML importer needs to be executed on the main
 *        thread only). Therefore, you should never call it on a thread that is
 *        itself dispatched synchrnously from the main thread, or it will lead
 *        to a deadlock. If you are in such a case, prefer using the
 *        +loadHTMLString:completion: method instead.
 */
+ (instancetype)attributedStringWithHTML:(NSString*)htmlString;

/**
 *  Parse a string containing HTML markup into an NSAttributedString
 *
 *  @param htmlString The HTML string to build the attributed string from
 *  @param completion This block is called on the mainQueue upon completion
 *         (when the HTML string has been parsed), returning asynchronously
 *         the resulting `NSAttributedString` (or `nil` if it cannot be parsed).
 *
 *  @note This method is dispatched asynchronously on the main thread (because
 *        the HTML importer needs to be executed on the main thead only).
 */
+ (void)loadHTMLString:(NSString*)htmlString
            completion:(void(^)(NSAttributedString* attrString))completion;

/******************************************************************************/
#pragma mark - Size

/**
 *  Returns the size (in points) needed to draw the attributed string.
 *
 *  @param maxSize The width and height constraints to apply when computing the
 *         string’s bounding rectangle.
 *
 *  @return the CGSize (width and height) required to draw the entire contents of the string.
 *
 *  @note This method allows the string to be rendered in multiple  lines if
 *        needed, taking the attributedString's lineBreak mode configured in the
 *        string's paragraph attributes into account).
 */
- (CGSize)sizeConstrainedToSize:(CGSize)maxSize;

/******************************************************************************/
#pragma mark - Text Font

/**
 *  The default font used in an NSAttributedString when no specific font
 *  attribute is defined.
 *
 *  @return The "Helvetica" font with size 12.
 */
+ (UIFont*)defaultFont;

/**
 *  Returns the font applied at the given character index.
 *
 *  @param index  The character index for which to return the font
 *  @param aRange If non-NULL:
 *
 *          - If the font attribute exists at index, upon return `aRange`
 *            contains a range over which the font applies.
 *          - If the font attribute does not exist at index, upon return
 *            `aRange` contains the range over which the font attribute does
 *            not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         font attribute.
 *
 *  @return The value for the font attribute of the character at index `index`,
 *          or `nil` if there is no font attribute.
 */
- (UIFont*)fontAtIndex:(NSUInteger)index
        effectiveRange:(NSRangePointer)aRange;

/**
 *  Executes the Block for every font attribute runs in the specified range.
 *
 *  If this method is sent to an instance of NSMutableAttributedString, mutation
 *  (deletion, addition, or change) is allowed, as long as it is within the
 *  range provided to the block; after a mutation, the enumeration continues
 *  with the range immediately following the processed range, after the length
 *  of the processed range is adjusted for the mutation. (The enumerator
 *  basically assumes any change in length occurs in the specified range.)
 *
 *  @param enumerationRange If non-NULL, contains the maximum range over which
 *                          the font attributes are enumerated, clipped to
 *                          enumerationRange.
 *  @param block The Block to apply to ranges of the font attribute in the
 *               attributed string. The Block takes three arguments:
 *
 *               - `font`: The font of the enumerated text run.
 *               - `range`: An NSRange indicating the run of the font.
 *               - `stop`: A reference to a Boolean value. The block can set the
 *                         value to YES to stop further processing of the set.
 *                         The stop argument is an out-only argument. You should
 *                         only ever set this Boolean to YES within the Block.
 *  @param includeUndefined If set to YES, this method will also call the block
 *                          for every range that does not have any font defined,
 *                          passing nil to the first argument of the block.
 */
- (void)enumerateFontsInRange:(NSRange)enumerationRange
             includeUndefined:(BOOL)includeUndefined
                   usingBlock:(void (^)(UIFont* font, NSRange range, BOOL *stop))block;

/******************************************************************************/
#pragma mark - Text Color

/**
 *  Returns the foreground text color applied at the given character index.
 *
 *  @param index  The character index for which to return the foreground color
 *  @param aRange If non-NULL:
 *
 *          - If the foreground color attribute exists at index, upon return
 *            `aRange` contains a range over which the foreground color applies.
 *          - If the foreground color attribute does not exist at index, upon
 *            return `aRange` contains the range over which the foreground color
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         foreground color attribute.
 *
 *  @return The value for the foreground color attribute of the character at
 *          index `index`, or `nil` if there is no foreground color attribute.
 */
- (UIColor*)textColorAtIndex:(NSUInteger)index
              effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns the background text color applied at the given character index.
 *
 *  @param index  The character index for which to return the background color
 *  @param aRange If non-NULL:
 *
 *          - If the background color attribute exists at index, upon return
 *            `aRange` contains a range over which the background color applies.
 *          - If the background color attribute does not exist at index, upon
 *            return `aRange` contains the range over which the background color
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         background color attribute.
 *
 *  @return The value for the background color attribute of the character at
 *          index `index`, or `nil` if there is no background color attribute.
 */
- (UIColor*)textBackgroundColorAtIndex:(NSUInteger)index
                        effectiveRange:(NSRangePointer)aRange;

/******************************************************************************/
#pragma mark - Text Underlining

/**
 *  Returns whether the underline attribute is applied at the given character
 *  index.
 *
 *  @param index  The character index for which to return the underline state
 *  @param aRange If non-NULL:
 *
 *          - If the underline attribute exists at index, upon return `aRange`
 *            contains a range over which the underline applies (with the same
 *            underlineStyle).
 *          - If the underline attribute does not exist at index, upon return
 *            `aRange` contains the range over which the underline does not
 *            exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         underline attribute.
 *
 *  @return YES if the character at index `index` is underlined,
 *          NO otherwise.
 *
 *  @note This is a convenience method that calls the method
 *        -textUnderlineStyleAtIndex:effectiveRange: and returns YES if the
 *        result is other than NSUnderlineStyleNone.
 */
- (BOOL)isTextUnderlinedAtIndex:(NSUInteger)index
                 effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns the underline style applied at the given character index.
 *
 *  @param index  The character index for which to return the underline style
 *  @param aRange If non-NULL:
 *
 *          - If the underline style attribute exists at index, upon return
 *            `aRange` contains a range over which the underline style applies.
 *          - If the underline style attribute does not exist at index, upon
 *            return `aRange` contains the range over which the underline style
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         underline style attribute.
 *
 *  @return The value for the underline style attribute of the character at
 *          index `index`, or NSUnderlineStyleNone if there is no underline style
 *          attribute.
 */
- (NSUnderlineStyle)textUnderlineStyleAtIndex:(NSUInteger)index
                               effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns the underline color applied at the given character index.
 *
 *  @param index  The character index for which to return the underline color
 *  @param aRange If non-NULL:
 *
 *          - If the underline color attribute exists at index, upon return
 *            `aRange` contains a range over which the underline color applies.
 *          - If the underline color attribute does not exist at index, upon
 *            return `aRange` contains the range over which the underline color
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         underline color attribute.
 *
 *  @return The value for the underline color attribute of the character at
 *          index `index`, or `nil` if there is no underline color attribute.
 */
- (UIColor*)textUnderlineColorAtIndex:(NSUInteger)index
                       effectiveRange:(NSRangePointer)aRange;

/******************************************************************************/
#pragma mark - Text Style & Traits

/**
 *  Returns whether the text is bold at the given character index.
 *
 *  @param index  The character index for which to return the bold state
 *  @param aRange If non-NULL:
 *
 *          - If a bold font attribute exists at index, upon return `aRange`
 *            contains a range over which the bold font applies.
 *          - If no font attribute exists at index, or the font attribute does
 *            not have bold traits, upon return `aRange` contains the range over
 *            which the non-bold font attribute apply.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         bold font attribute.
 *
 *  @return YES if the character at index `index` is bold,
 *          NO otherwise.
 *
 *  @note This method actually fetch the font at the given index and the uses
 *        NSFontDescriptor to check if the font has bold symbolic traits.
 */
- (BOOL)isFontBoldAtIndex:(NSUInteger)index
           effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns whether the text is in italics at the given character index.
 *
 *  @param index  The character index for which to return the italics state
 *  @param aRange If non-NULL:
 *
 *          - If an italics font attribute exists at index, upon return `aRange`
 *            contains a range over which the italics font applies.
 *          - If no font attribute exists at index, or the font attribute does
 *            not have italics traits, upon return `aRange` contains the range
 *            over which the non-italics font attribute apply.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         italics font attribute.
 *
 *  @return YES if the character at index `index` is in italics,
 *          NO otherwise.
 *
 *  @note This method actually fetch the font at the given index and the uses
 *        NSFontDescriptor to check if the font has italics symbolic traits.
 */
- (BOOL)isFontItalicsAtIndex:(NSUInteger)index
              effectiveRange:(NSRangePointer)aRange;

/******************************************************************************/
#pragma mark - Link

/**
 *  Returns the URL attribute at the given character index.
 *
 *  @param index  The character index for which to return the URL
 *  @param aRange If non-NULL:
 *
 *          - If the URL attribute exists at index, upon return `aRange`
 *            contains a range over which the URL applies.
 *          - If the URL attribute does not exist at index, upon return `aRange`
 *            contains the range over which the URL attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         URL attribute.
 *
 *  @return The value for the URL attribute of the character at index `index`,
 *          or `nil` if there is no URL attribute.
 */
- (NSURL*)URLAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/**
 *  Executes the Block for every URL attribute runs in the specified range.
 *
 *  If this method is sent to an instance of NSMutableAttributedString, mutation
 *  (deletion, addition, or change) is allowed, as long as it is within the
 *  range provided to the block; after a mutation, the enumeration continues
 *  with the range immediately following the processed range, after the length
 *  of the processed range is adjusted for the mutation. (The enumerator
 *  basically assumes any change in length occurs in the specified range.)
 *
 *  @param enumerationRange If non-NULL, contains the maximum range over which
 *                          the URL attributes are enumerated, clipped to
 *                          enumerationRange.
 *  @param block The Block to apply to ranges of the URL attribute in the
 *               attributed string. The Block takes three arguments:
 *
 *               - `link`: The URL of the enumerated text run.
 *               - `range`: An NSRange indicating the run of the URL.
 *               - `stop`: A reference to a Boolean value. The block can set the
 *                         value to YES to stop further processing of the set.
 *                         The stop argument is an out-only argument. You should
 *                         only ever set this Boolean to YES within the Block.
 */
- (void)enumerateURLsInRange:(NSRange)enumerationRange
                  usingBlock:(void (^)(NSURL* link, NSRange range, BOOL *stop))block;

/******************************************************************************/
#pragma mark - Character Spacing

/**
 *  Returns the character spacing (kern attribute) applied at the given
 *  character index.
 *
 *  @param index  The character index for which to return the character spacing
 *  @param aRange If non-NULL:
 *
 *          - If the kern attribute exists at index, upon return `aRange`
 *            contains a range over which the kern attribute’s value applies.
 *          - If the kern attribute does not exist at index, upon return
 *            `aRange` contains the range over which the attribute does not
 *            exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         kern attribute.
 *
 *  @return The value for the kern attribute of the character at index `index`,
 *          or 0 if there is no kern attribute (kerning disabled).
 *
 *  @note For more info about typographical concepts, kerning and text layout,
 *       see the [Text Programming Guide](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/TypoFeatures/TextSystemFeatures.html#//apple_ref/doc/uid/TP40009542-CH6-51627-BBCCHIFF)
 */
- (CGFloat)characterSpacingAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/******************************************************************************/
#pragma mark - Subscript and Superscript

/**
 *  Returns the baseline offset applied at the given character index.
 *
 *  @param index  The character index for which to return the baseline offset
 *  @param aRange If non-NULL:
 *
 *          - If the baseline offset attribute exists at index, upon return
 *            `aRange` contains a range over which the baseline offset applies.
 *          - If the baseline offset attribute does not exist at index, upon
 *            return `aRange` contains the range over which the baseline offset
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         baseline offset attribute.
 *
 *  @return The value for the baseline offset of the character at index `index`,
 *          or 0 if there is no baseline offset attribute.
 */
- (CGFloat)baselineOffsetAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/******************************************************************************/
#pragma mark - Paragraph Style

/**
 *  Returns the paragraph's text alignment applied at the given character index.
 *
 *  @param index  The character index for which to return the text aligment
 *  @param aRange If non-NULL:
 *
 *          - If the paragraph style attribute exists at index, upon return
 *            `aRange` contains a range over which the paragraph style's text
 *            alignment applies.
 *          - If the paragraph style attribute does not exist at index, upon
 *            return `aRange` contains the range over which the paragraph style
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         paragraph style attribute's text aligmnent.
 *
 *  @return The value for the paragraph style's aligment attribute at the
 *          character index `index`, or the default NSTextAlignmentLeft if there
 *          is no paragraph style attribute.
 *
 *  @note This is a convenience method that calls
 *        -paragraphStyleAtIndex:effectiveRange: and returns the returned
 *        object's aligbment property.
 */
- (NSTextAlignment)textAlignmentAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns the paragraph's line break mode applied at the given character
 *  index.
 *
 *  @param index  The character index for which to return the line break mode
 *  @param aRange If non-NULL:
 *
 *          - If the paragraph style attribute exists at index, upon return
 *            `aRange` contains a range over which the paragraph style's line
 *            break mode applies.
 *          - If the paragraph style attribute does not exist at index, upon
 *            return `aRange` contains the range over which the paragraph style
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         paragraph style attribute's line break mode.
 *
 *  @return The value for the paragraph style's line break mode attribute at the
 *          character index `index`, or the default NSLineBreakByWordWrapping if
 *          there is no paragraph style attribute.
 *
 *  @note This is a convenience method that calls
 *        -paragraphStyleAtIndex:effectiveRange: and returns the returned
 *        object's lineBreakMode property.
 */
- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/**
 *  Returns the paragraph style applied at the given character index.
 *
 *  @param index  The character index for which to return the paragraph style
 *  @param aRange If non-NULL:
 *
 *          - If the paragraph style attribute exists at index, upon return
 *            `aRange` contains a range over which the paragraph style applies.
 *          - If the paragraph style attribute does not exist at index, upon
 *            return `aRange` contains the range over which the paragraph style
 *            attribute does not exist.
 *
 *         The range isn’t necessarily the maximum range covered by the
 *         paragraph style attribute.
 *
 *  @return The value for the paragraph style attribute at the character index
 *          `index`, or `nil` if there is no paragraph style attribute.
 */
- (NSParagraphStyle*)paragraphStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange;

/**
 *  Executes the Block for every paragraph style attribute runs in the
 *  specified range.
 *
 *  If this method is sent to an instance of NSMutableAttributedString, mutation
 *  (deletion, addition, or change) is allowed, as long as it is within the
 *  range provided to the block; after a mutation, the enumeration continues
 *  with the range immediately following the processed range, after the length
 *  of the processed range is adjusted for the mutation. (The enumerator
 *  basically assumes any change in length occurs in the specified range.)
 *
 *  @param enumerationRange If non-NULL, contains the maximum range over which
 *                          the paragraph style attributes are enumerated,
 *                          clipped to enumerationRange.
 *  @param block The Block to apply to ranges of the paragraph style attribute
 *               in the attributed string. The Block takes three arguments:
 *
 *               - `style`: The paragraph style of the enumerated text run.
 *               - `range`: An NSRange indicating the run of the paragraph
 *                          style.
 *               - `stop`: A reference to a Boolean value. The block can set the
 *                         value to YES to stop further processing of the set.
 *                         The stop argument is an out-only argument. You should
 *                         only ever set this Boolean to YES within the Block.
 *  @param includeUndefined If set to YES, this method will also call the block
 *                          for every range that does not have any paragraph style
 *                          defined, passing nil to the first argument of the block.
 *
 */
- (void)enumerateParagraphStylesInRange:(NSRange)enumerationRange
                       includeUndefined:(BOOL)includeUndefined
                             usingBlock:(void (^)(NSParagraphStyle* style, NSRange range, BOOL *stop))block;

@end



