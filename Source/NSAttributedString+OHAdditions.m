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


#import "NSAttributedString+OHAdditions.h"

@implementation NSAttributedString (OHAdditions)

- (NSRange)fullRange
{
    return NSMakeRange(0, self.length);
}

// MARK: Convenience Constructors

+ (instancetype)attributedStringWithString:(NSString*)string
{
    if (string)
    {
        return [[self alloc] initWithString:string];
    }
    else
    {
        return nil;
    }
}

+ (instancetype)attributedStringWithAttributedString:(NSAttributedString*)attrStr
{
    if (attrStr)
    {
        return [[self alloc] initWithAttributedString:attrStr];
    }
    else
    {
        return nil;
    }
}

+ (instancetype)attributedStringWithHTML:(NSString*)htmlString
{
    NSData* htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    if (htmlData)
    {
        NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
        __block id attributedString = nil;
        dispatch_block_t block = ^{
            attributedString = [[self alloc] initWithData:htmlData
                                                  options:options
                                       documentAttributes:nil
                                                    error:NULL];
        };
        
        if ([NSThread isMainThread])
        {
            block();
        }
        else
        {
            // See Apple Doc: HTML importer should always be called on the main thread
            dispatch_sync(dispatch_get_main_queue(), block);
        }
        
        return attributedString;
    }
    else
    {
        return nil;
    }
}

// MARK: Size

- (CGSize)sizeConstrainedToSize:(CGSize)maxSize
{
	return [self sizeConstrainedToSize:maxSize fitRange:NULL];
}

- (CGSize)sizeConstrainedToSize:(CGSize)maxSize fitRange:(NSRange*)fitRange
{
    // Use NSStringDrawingUsesLineFragmentOrigin to compute bounds of multi-line strings (see Apple doc)
    CGRect bounds = [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    // We need to ceil the returned values (see Apple doc)
    return CGSizeMake( ceilf(bounds.size.width), ceilf(bounds.size.height) );
}

// MARK: Text Font

- (UIFont*)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSFontAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateFontsInRange:(NSRange)enumerationRange usingBlock:(void (^)(UIFont*, NSRange, BOOL *))block
{
    [self enumerateAttribute:NSFontAttributeName inRange:enumerationRange options:0 usingBlock:block];
}

// MARK: Text Color

- (UIColor*)textColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSForegroundColorAttributeName atIndex:index effectiveRange:aRange];
}

- (UIColor*)textBackgroundColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSBackgroundColorAttributeName atIndex:index effectiveRange:aRange];
}

// MARK: Text Style

- (BOOL)textUnderlinedAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSUnderlineStyle underlineStyle = [self textUnderlineStyleAtIndex:index effectiveRange:aRange];
    return (underlineStyle & ~UIFontDescriptorClassMask) != NSUnderlineStyleNone;
}

- (NSUnderlineStyle)textUnderlineStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    id attr = [self attribute:NSUnderlineStyleAttributeName atIndex:index effectiveRange:aRange];
    return [(NSNumber*)attr integerValue];
}

- (UIColor*)textUnderlineColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSUnderlineColorAttributeName atIndex:index effectiveRange:aRange];
}

- (BOOL)textBoldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    UIFont* font = [self fontAtIndex:index effectiveRange:aRange];
    NSDictionary* traits = [font.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    UIFontDescriptorSymbolicTraits symTraits = (uint32_t)[traits[UIFontSymbolicTrait] longValue];
    return (symTraits & UIFontDescriptorTraitBold) != 0;
}

- (BOOL)textItalicsAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    UIFont* font = [self fontAtIndex:index effectiveRange:aRange];
    NSDictionary* traits = [font.fontDescriptor objectForKey:UIFontDescriptorTraitsAttribute];
    UIFontDescriptorSymbolicTraits symTraits = (uint32_t)[traits[UIFontSymbolicTrait] longValue];
    return (symTraits & UIFontDescriptorTraitItalic) != 0;
}

// MARK: Links

- (NSURL*)URLAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSLinkAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateURLsInRange:(NSRange)enumerationRange usingBlock:(void (^)(NSURL*, NSRange, BOOL *))block
{
    [self enumerateAttribute:NSLinkAttributeName inRange:enumerationRange options:0 usingBlock:block];
}


// MARK: Character Spacing

- (CGFloat)characterSpacingAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [[self attribute:NSKernAttributeName atIndex:index effectiveRange:aRange] floatValue];
}

// MARK: Subscript and Superscript

- (CGFloat)baselineOffsetAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [[self attribute:NSBaselineOffsetAttributeName atIndex:index effectiveRange:aRange] floatValue];
}

// MARK: Paragraph Style

- (NSTextAlignment)textAlignmentAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSParagraphStyle* style = [self attribute:NSParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
    return style.alignment;
}

- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSParagraphStyle* style = [self attribute:NSParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
    return style.lineBreakMode;
}

- (NSParagraphStyle*)paragraphStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateParagraphStylesInRange:(NSRange)enumerationRange usingBlock:(void (^)(NSParagraphStyle*, NSRange, BOOL *))block
{
    [self enumerateAttribute:NSParagraphStyleAttributeName inRange:enumerationRange options:0 usingBlock:block];
}

@end




