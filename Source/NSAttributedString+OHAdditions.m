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


#import "NSAttributedString+OHAdditions.h"

@implementation NSAttributedString (OHAdditions)

/******************************************************************************/
#pragma mark - Convenience Constructors

+ (instancetype)attributedStringWithString:(NSString*)string
{
    if (string)
    {
        return [[self alloc] initWithString:string];
    }
    else
    {
        return [self new];
    }
}

+ (instancetype)attributedStringWithFormat:(NSString*)format, ...
{
    va_list args;
    va_start(args, format);
    NSString* string = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);
    return [[self alloc] initWithString:string];
}

+ (instancetype)attributedStringWithAttributedString:(NSAttributedString*)attrStr
{
    if (attrStr)
    {
        return [[self alloc] initWithAttributedString:attrStr];
    }
    else
    {
        return [self new];
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

+ (void)loadHTMLString:(NSString*)htmlString
            completion:(void(^)(NSAttributedString* attrString))completion
{
    if (!completion) return;
    
    NSData* htmlData = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    if (htmlData)
    {
        NSDictionary* options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                  NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
        dispatch_async(dispatch_get_main_queue(), ^{
            NSAttributedString* attributedString = [[self alloc] initWithData:htmlData
                                                  options:options
                                                           documentAttributes:nil
                                                                        error:NULL];
            completion(attributedString);
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(nil);
        });
    }
}

/******************************************************************************/
#pragma mark - Size

- (CGSize)sizeConstrainedToSize:(CGSize)maxSize
{
    // Use NSStringDrawingUsesLineFragmentOrigin to compute bounds of multi-line strings (see Apple doc)
    CGRect bounds = [self boundingRectWithSize:maxSize
                                       options:NSStringDrawingUsesLineFragmentOrigin
                                       context:nil];

    // We need to ceil the returned values (see Apple doc)
    return CGSizeMake((CGFloat)ceil((double)bounds.size.width),
                      (CGFloat)ceil((double)bounds.size.height) );
}

/******************************************************************************/
#pragma mark - Text Font

+ (UIFont*)defaultFont
{
    // The default font used for NSAttributedString according to the doc
    return [UIFont fontWithName:@"Helvetica" size:12];
}

- (UIFont*)fontAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSFontAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateFontsInRange:(NSRange)enumerationRange
             includeUndefined:(BOOL)includeUndefined
                   usingBlock:(void (^)(UIFont*, NSRange, BOOL *))block
{
    NSParameterAssert(block);
    
    [self enumerateAttribute:NSFontAttributeName
                     inRange:enumerationRange
                     options:0
                  usingBlock:^(id font, NSRange aRange, BOOL *stop)
     {
         if (font || includeUndefined) block(font, aRange, stop);
     }];
}

/******************************************************************************/
#pragma mark - Text Color

- (UIColor*)textColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSForegroundColorAttributeName atIndex:index effectiveRange:aRange];
}

- (UIColor*)textBackgroundColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSBackgroundColorAttributeName atIndex:index effectiveRange:aRange];
}

/******************************************************************************/
#pragma mark - Text Underlining

- (BOOL)isTextUnderlinedAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSUnderlineStyle underlineStyle = [self textUnderlineStyleAtIndex:index effectiveRange:aRange];
    return underlineStyle != NSUnderlineStyleNone;
}

- (NSUnderlineStyle)textUnderlineStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSNumber* attr = [self attribute:NSUnderlineStyleAttributeName atIndex:index effectiveRange:aRange];
    return [attr integerValue];
}

- (UIColor*)textUnderlineColorAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSUnderlineColorAttributeName atIndex:index effectiveRange:aRange];
}

/******************************************************************************/
#pragma mark - Text Style & Traits

- (BOOL)isFontBoldAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    UIFont* font = [self fontAtIndex:index effectiveRange:aRange];
    UIFontDescriptorSymbolicTraits symTraits = font.fontDescriptor.symbolicTraits;
    return (symTraits & UIFontDescriptorTraitBold) != 0;
}

- (BOOL)isFontItalicsAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    UIFont* font = [self fontAtIndex:index effectiveRange:aRange];
    UIFontDescriptorSymbolicTraits symTraits = font.fontDescriptor.symbolicTraits;
    return (symTraits & UIFontDescriptorTraitItalic) != 0;
}

/******************************************************************************/
#pragma mark - Links

- (NSURL*)URLAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSLinkAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateURLsInRange:(NSRange)enumerationRange
                  usingBlock:(void (^)(NSURL*, NSRange, BOOL *))block
{
    NSParameterAssert(block);
    
    [self enumerateAttribute:NSLinkAttributeName
                     inRange:enumerationRange
                     options:0
                  usingBlock:^(id url, NSRange range, BOOL *stop)
     {
         if (url) block(url, range, stop);
     }];
}

/******************************************************************************/
#pragma mark - Character Spacing

- (CGFloat)characterSpacingAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [[self attribute:NSKernAttributeName atIndex:index effectiveRange:aRange] floatValue];
}

/******************************************************************************/
#pragma mark - Subscript and Superscript

- (CGFloat)baselineOffsetAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [[self attribute:NSBaselineOffsetAttributeName atIndex:index effectiveRange:aRange] floatValue];
}

/******************************************************************************/
#pragma mark - Paragraph Style

- (NSTextAlignment)textAlignmentAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSParagraphStyle* style = [self paragraphStyleAtIndex:index effectiveRange:aRange];
    return style.alignment;
}

- (NSLineBreakMode)lineBreakModeAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    NSParagraphStyle* style = [self paragraphStyleAtIndex:index effectiveRange:aRange];
    return style.lineBreakMode;
}

- (NSParagraphStyle*)paragraphStyleAtIndex:(NSUInteger)index effectiveRange:(NSRangePointer)aRange
{
    return [self attribute:NSParagraphStyleAttributeName atIndex:index effectiveRange:aRange];
}

- (void)enumerateParagraphStylesInRange:(NSRange)enumerationRange
                       includeUndefined:(BOOL)includeUndefined
                             usingBlock:(void (^)(NSParagraphStyle*, NSRange, BOOL *))block
{
    NSParameterAssert(block);
    
    [self enumerateAttribute:NSParagraphStyleAttributeName
                     inRange:enumerationRange
                     options:0
                  usingBlock:^(id style, NSRange aRange, BOOL *stop)
     {
         if (style || includeUndefined) block(style, aRange, stop);
     }];
}

@end




