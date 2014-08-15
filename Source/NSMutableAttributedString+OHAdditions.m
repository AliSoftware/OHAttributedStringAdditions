/*******************************************************************************
 * This software is under the MIT License quoted below:
 *******************************************************************************
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


#import "NSMutableAttributedString+OHAdditions.h"

@implementation NSMutableAttributedString (OHAdditions)

/******************************************************************************/
#pragma mark - Text Font

- (void)setFont:(UIFont*)font
{
	[self setFontName:font.fontName size:font.pointSize];
}

- (void)setFont:(UIFont*)font range:(NSRange)range
{
    if (font)
    {
        [self removeAttribute:NSFontAttributeName range:range]; // Work around for Apple leak
        [self addAttribute:NSFontAttributeName value:(id)font range:range];
    }
}

- (void)setFontName:(NSString*)fontName size:(CGFloat)size
{
	[self setFontName:fontName size:size range:NSMakeRange(0,self.length)];
}

- (void)setFontName:(NSString*)fontName size:(CGFloat)size range:(NSRange)range
{
    UIFont* aFont = [UIFont fontWithName:fontName size:size];
    [self setFont:aFont range:range];
}

- (void)setFontFamily:(NSString*)fontFamily
                 size:(CGFloat)size
                 bold:(BOOL)isBold
               italic:(BOOL)isItalic
                range:(NSRange)range
{
	UIFontDescriptorSymbolicTraits traits = (isBold?UIFontDescriptorTraitBold:0) | (isItalic?UIFontDescriptorTraitItalic:0);
	NSDictionary* attributes = @{ UIFontDescriptorFamilyAttribute: fontFamily,
                                  UIFontDescriptorTraitsAttribute: @{UIFontSymbolicTrait:@(traits)}};
	
    UIFontDescriptor* desc = [UIFontDescriptor fontDescriptorWithFontAttributes:attributes];
    UIFont* aFont = [UIFont fontWithDescriptor:desc size:size];
    
	[self removeAttribute:NSFontAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:NSFontAttributeName value:(id)aFont range:range];
}

/******************************************************************************/
#pragma mark - Text Color

- (void)setTextColor:(UIColor*)color
{
	[self setTextColor:color range:NSMakeRange(0,self.length)];
}

- (void)setTextColor:(UIColor*)color range:(NSRange)range
{
	[self removeAttribute:NSForegroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:NSForegroundColorAttributeName value:(id)color range:range];
}

- (void)setTextBackgroundColor:(UIColor*)color
{
    [self setTextBackgroundColor:color range:NSMakeRange(0, self.length)];
}

- (void)setTextBackgroundColor:(UIColor*)color range:(NSRange)range
{
	[self removeAttribute:NSBackgroundColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:NSBackgroundColorAttributeName value:(id)color range:range];
}

/******************************************************************************/
#pragma mark - Text Style

- (void)setTextUnderlined:(BOOL)underlined
{
	[self setTextUnderlined:underlined range:NSMakeRange(0,self.length)];
}

- (void)setTextUnderlined:(BOOL)underlined range:(NSRange)range
{
	NSUnderlineStyle style = underlined ? (NSUnderlineStyleSingle|NSUnderlinePatternSolid) : NSUnderlineStyleNone;
	[self setTextUnderlineStyle:style range:range];
}

- (void)setTextUnderlineStyle:(NSUnderlineStyle)style range:(NSRange)range
{
	[self removeAttribute:NSUnderlineStyleAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:NSUnderlineStyleAttributeName value:@(style) range:range];
}

- (void)setTextUnderlineColor:(UIColor*)color range:(NSRange)range
{
	[self removeAttribute:NSUnderlineColorAttributeName range:range]; // Work around for Apple leak
	[self addAttribute:NSUnderlineColorAttributeName value:color range:range];
}


- (void)changeFontWithTraits:(UIFontDescriptorSymbolicTraits)newTraits range:(NSRange)range
{
    NSUInteger startPoint = range.location;
	NSRange effectiveRange;
    [self beginEditing];
	do
    {
		// Get font at startPoint
		UIFont* currentFont = [self attribute:NSFontAttributeName atIndex:startPoint effectiveRange:&effectiveRange];
        if (!currentFont)
        {
            currentFont = [UIFont systemFontOfSize:12];
        }
		// The range for which this font is effective
		NSRange fontRange = NSIntersectionRange(range, effectiveRange);
        
		// Create the font variant for this font according to new traits
        UIFontDescriptor* fontDesc = [currentFont fontDescriptor];
        fontDesc = [fontDesc fontDescriptorWithSymbolicTraits:newTraits];
		UIFont* newFont = [UIFont fontWithDescriptor:fontDesc size:currentFont.pointSize];
        
        if (!newFont)
        {
            NSLog(@"[NSMutableAttributedString+OHAdditions] Warning: can't find an italic font variant for font family %@. "
                  @"Try another font family (like Helvetica) instead.", currentFont.familyName);
        }
        
        // Apply the new font with new traits
		if (newFont)
        {
			[self removeAttribute:NSFontAttributeName range:fontRange]; // Work around for Apple leak
			[self addAttribute:NSFontAttributeName value:(id)newFont range:fontRange];
		}
		
		// If the fontRange was not covering the whole range, continue with next run
		startPoint = NSMaxRange(effectiveRange);
	} while(startPoint<NSMaxRange(range));
    [self endEditing];
}

// TODO: Check out the effect of the NSStrokeWidthAttributeName attribute
//       to see if we can also fake bold fonts by increasing the font weight
- (void)setFontBold:(BOOL)isBold range:(NSRange)range
{
	[self changeFontWithTraits:(isBold?UIFontDescriptorTraitBold:0) range:range];
}

// TODO: Check out the effect of the NSObliquenessAttributeName attribute
//       to see if we can also fake italics fonts by increasing the font skew
- (void)setFontItalics:(BOOL)isItalics range:(NSRange)range
{
    [self changeFontWithTraits:(isItalics?UIFontDescriptorTraitItalic:0) range:range];
}

/******************************************************************************/
#pragma mark - Link

- (void)setURL:(NSURL*)linkURL range:(NSRange)range
{
    [self removeAttribute:NSLinkAttributeName range:range]; // Work around for Apple leak
    if (linkURL)
    {
        [self addAttribute:NSLinkAttributeName value:(id)linkURL range:range];
    }
}

/******************************************************************************/
#pragma mark - Character Spacing

- (void)setCharacterSpacing:(CGFloat)chracterSpacing
{
	[self setCharacterSpacing:chracterSpacing range:NSMakeRange(0,self.length)];
}
- (void)setCharacterSpacing:(CGFloat)characterSpacing range:(NSRange)range
{
    [self addAttribute:NSKernAttributeName value:@(characterSpacing) range:range];
}

/******************************************************************************/
#pragma mark - Subscript and Superscript

- (void)setBaselineOffset:(CGFloat)offset
{
    [self setBaselineOffset:offset range:NSMakeRange(0, self.length)];
}

- (void)setBaselineOffset:(CGFloat)offset range:(NSRange)range
{
    [self removeAttribute:NSBaselineOffsetAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:NSBaselineOffsetAttributeName value:@(offset) range:range];
}

- (void)setSuperscriptForRange:(NSRange)range
{
    UIFont* font = [self attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
    CGFloat offset = + font.pointSize / 2;
    [self setBaselineOffset:offset range:range];
}

- (void)setSubscriptForRange:(NSRange)range
{
    UIFont* font = [self attribute:NSFontAttributeName atIndex:range.location effectiveRange:NULL];
    CGFloat offset = - font.pointSize / 2;
    [self setBaselineOffset:offset range:range];
}

/******************************************************************************/
#pragma mark - Paragraph Style

- (void)setTextAlignment:(NSTextAlignment)alignment
{
	[self setTextAlignment:alignment range:NSMakeRange(0,self.length)];
}

- (void)setTextAlignment:(NSTextAlignment)alignment range:(NSRange)range
{
    [self modifyParagraphStylesInRange:range withBlock:^(NSMutableParagraphStyle *paragraphStyle) {
        paragraphStyle.alignment = alignment;
    }];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    [self setLineBreakMode:lineBreakMode range:NSMakeRange(0,self.length)];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode range:(NSRange)range
{
    [self modifyParagraphStylesInRange:range withBlock:^(NSMutableParagraphStyle *paragraphStyle) {
        paragraphStyle.lineBreakMode = lineBreakMode;
    }];
}


- (void)modifyParagraphStylesWithBlock:(void(^)(NSMutableParagraphStyle* paragraphStyle))block
{
    [self modifyParagraphStylesInRange:NSMakeRange(0,self.length) withBlock:block];
}

- (void)modifyParagraphStylesInRange:(NSRange)range withBlock:(void(^)(NSMutableParagraphStyle* paragraphStyle))block
{
    NSParameterAssert(block != nil);
    
    NSRangePointer rangePtr = &range;
    NSUInteger loc = range.location;
    [self beginEditing];
    while (NSLocationInRange(loc, range))
    {
        NSParagraphStyle* currentStyle = [self attribute:NSParagraphStyleAttributeName
                                                 atIndex:loc
                                   longestEffectiveRange:rangePtr
                                                 inRange:range];
        NSMutableParagraphStyle* newStyle = [currentStyle mutableCopy];
        block(newStyle);
        [self setParagraphStyle:newStyle range:*rangePtr];
        
        loc = NSMaxRange(*rangePtr);
    }
    [self endEditing];
}

- (void)setParagraphStyle:(NSParagraphStyle *)style
{
    [self setParagraphStyle:style range:NSMakeRange(0,self.length)];
}

// TODO: Check the behavior when applying a paragraph style only to some
//       characters in the middle of an actual paragraph.
- (void)setParagraphStyle:(NSParagraphStyle*)style range:(NSRange)range
{
    [self removeAttribute:NSParagraphStyleAttributeName range:range]; // Work around for Apple leak
    [self addAttribute:NSParagraphStyleAttributeName value:(id)style range:range];
}

@end
