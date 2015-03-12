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

#import "UILabel+OHAdditions.h"

@implementation UILabel (OHAdditions)

- (NSTextContainer*)currentTextContainer
{
    NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize:self.bounds.size];
    textContainer.lineFragmentPadding  = 0;
    textContainer.maximumNumberOfLines = (NSUInteger)self.numberOfLines;
    textContainer.lineBreakMode = self.lineBreakMode;
    return textContainer;
}

- (NSUInteger)characterIndexAtPoint:(CGPoint)point
{
    NSTextContainer* textContainer = self.currentTextContainer;
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];

    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager addTextContainer:textContainer];
    
    // UILabel centers its text vertically, so adjust the point coordinates accordingly
    NSRange glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
    CGRect wholeTextRect = [layoutManager boundingRectForGlyphRange:glyphRange
                                                    inTextContainer:textContainer];
    point.y -= (CGRectGetHeight(self.bounds)-CGRectGetHeight(wholeTextRect))/2;

    // Bail early if point outside the whole text bounding rect
    if (!CGRectContainsPoint(wholeTextRect, point)) return NSNotFound;
    
    // ask the layoutManager which glyph is under this tapped point
    NSUInteger glyphIdx = [layoutManager glyphIndexForPoint:point
                                            inTextContainer:textContainer
                             fractionOfDistanceThroughGlyph:NULL];
    
    // as explained in Apple's documentation the previous method returns the nearest glyph
    // if no glyph was present at that point. So if we want to ensure the point actually
    // lies on that glyph, we should check that explicitly
    CGRect glyphRect = [layoutManager boundingRectForGlyphRange:NSMakeRange(glyphIdx, 1)
                                                inTextContainer:textContainer];
    if (CGRectContainsPoint(glyphRect, point))
    {
        return [layoutManager characterIndexForGlyphAtIndex:glyphIdx];
    } else {
        return NSNotFound;
    }
}

@end
