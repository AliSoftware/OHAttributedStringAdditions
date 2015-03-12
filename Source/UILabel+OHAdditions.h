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
 *  Convenience methods to get text layout information from the UILabel and
 *  especially determine which character is at a given point.
 */
@interface UILabel (OHAdditions)

/**
 *  Returns a new `NSTextContainer` configured with the current label's settings
 *  (namely `maximumNumberOfLines` and `lineBreakMode`)
 */
@property(nonatomic, readonly) NSTextContainer* currentTextContainer;

/**
 *  The index of the character at a given point.
 *
 *  Typically used to know which character was tapped on the UILabel.
 *
 *  @param point The point's coordinates, expressed in the label's coordinate
 *               system
 *
 *  @return The index of the character present at that position, or
 *          `NSNotFound` if no character is present at that point.
 *
 *  @note This method is does not handle UILabel's text shrinking feature
 *        (like when you set `adjustFontSizeToFitWidth` to `YES`).
 *
 *  @note The actual `NSTextContainer` and `NSLayoutManager` used by `UILabel`
 *        internally to layout its text are not publicly exposed. This forces
 *        us to create and use our own `NSLayoutManager` for the computation,
 *        which may not be configured *exactly* the same as the private one,
 *        so slight deviations might happen (especially when text schrinking
 *        is on or similar stuff).  
 *
 *        If you really need precise detection, consider using `UITextView`
 *        (with `editable=NO`) instead, which already support all that stuff.
 */
- (NSUInteger)characterIndexAtPoint:(CGPoint)point;

@end
