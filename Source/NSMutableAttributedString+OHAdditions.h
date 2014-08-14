/***********************************************************************************
 * This software is under the MIT License quoted below:
 ***********************************************************************************
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
 ***********************************************************************************/


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString (OHAdditions)

// MARK: Text Font

- (void)setFont:(UIFont*)font;
- (void)setFont:(UIFont*)font range:(NSRange)range;
- (void)setFontName:(NSString*)fontName size:(CGFloat)size;
- (void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range;
- (void)setFontFamily:(NSString*)fontFamily size:(CGFloat)size bold:(BOOL)isBold italic:(BOOL)isItalic range:(NSRange)range;

// MARK: Text Color

- (void)setTextColor:(UIColor*)color;
- (void)setTextColor:(UIColor*)color range:(NSRange)range;
- (void)setTextBackgroundColor:(UIColor*)color;
- (void)setTextBackgroundColor:(UIColor*)color range:(NSRange)range;

// MARK: Text Style

- (void)setTextUnderlined:(BOOL)underlined;
- (void)setTextUnderlined:(BOOL)underlined range:(NSRange)range;
- (void)setTextUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range;
- (void)setTextUnderlineColor:(UIColor*)color range:(NSRange)range;

- (void)setTextBold:(BOOL)isBold range:(NSRange)range;
- (void)setTextItalics:(BOOL)isItalics range:(NSRange)range;

// MARK: Link

- (void)setURL:(NSURL*)linkURL range:(NSRange)range;

// MARK: Character Spacing

- (void)setCharacterSpacing:(CGFloat)characterSpacing;
- (void)setCharacterSpacing:(CGFloat)characterSpacing range:(NSRange)range;

// MARK: Subscript and Superscript

- (void)setBaselineOffset:(CGFloat)offset;
- (void)setBaselineOffset:(CGFloat)offset range:(NSRange)range;
- (void)setSuperscriptForRange:(NSRange)range;
- (void)setSubscriptForRange:(NSRange)range;

// MARK: Paragraph Style

- (void)setTextAlignment:(NSTextAlignment)alignment;
- (void)setTextAlignment:(NSTextAlignment)alignment range:(NSRange)range;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode;
- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range;

/* Allows you to modify only certain Paragraph Styles without changing the others (for example changing the firstLineHeadIndent without overriding the textAlignment) */
- (void)modifyParagraphStylesWithBlock:(void(^)(NSMutableParagraphStyle* paragraphStyle))block;
- (void)modifyParagraphStylesInRange:(NSRange)range withBlock:(void(^)(NSMutableParagraphStyle* paragraphStyle))block;
/* Override the Paragraph Styles, dropping the ones previously set if any.
 Be aware that this will override the text alignment, linebreakmode, and all other paragraph styles with the new values */
- (void)setParagraphStyle:(NSParagraphStyle *)style;
- (void)setParagraphStyle:(NSParagraphStyle*)style range:(NSRange)range;

@end
