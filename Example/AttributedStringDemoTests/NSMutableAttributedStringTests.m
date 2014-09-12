//
//  NSMutableAttributedStringTests.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 17/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableAttributedString+OHAdditions.h"

#import "OHASATestHelper.h"

@interface NSMutableAttributedStringTests : XCTestCase @end

@implementation NSMutableAttributedStringTests

/******************************************************************************/
#pragma mark - Text Font

- (void)test_setFont
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"Courier" size:42];
    [str setFont:font];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:font}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFont_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"Courier" size:42];
    [str setFont:font range:NSMakeRange(4,2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSFontAttributeName:font}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Text Color

- (void)test_setTextColor
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor purpleColor];
    [str setTextColor:color];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSForegroundColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextColor_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor purpleColor];
    [str setTextColor:color range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSForegroundColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextBackgroundColor
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor purpleColor];
    [str setTextBackgroundColor:color];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSBackgroundColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextBackgroundColor_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor purpleColor];
    [str setTextBackgroundColor:color range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSBackgroundColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Text Underlining

- (void)test_setTextUnderlined_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setTextUnderlined:YES];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextUnderlined_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setTextUnderlined:NO];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextUnderlined_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setTextUnderlined:YES range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid)}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextUnderlineStyle_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSUnderlineStyle style = NSUnderlinePatternDashDotDot | NSUnderlineStyleDouble;
    [str setTextUnderlineStyle:style range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSUnderlineStyleAttributeName:@(style)}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextUnderlineColor
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor orangeColor];
    [str setTextUnderlineColor:color];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSUnderlineColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextUnderlineColor_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIColor* color = [UIColor orangeColor];
    [str setTextUnderlineColor:color range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@4,@2,@{NSUnderlineColorAttributeName:color}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Text Style & Traits

- (void)test_changeFontTraitsWithBlock
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font1 = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 11)];
    UIFont* font2 = [UIFont fontWithName:@"Courier" size:19];
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];
    
    [str changeFontTraitsWithBlock:^UIFontDescriptorSymbolicTraits(UIFontDescriptorSymbolicTraits currentTraits) {
        return currentTraits | UIFontDescriptorTraitBold;
    }];
    
    NSSet* attr = attributesSetInString(str);
    
    UIFont* font1Bold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    UIFont* font2Bold = [UIFont fontWithName:@"Courier-Bold" size:19];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font1Bold}],
                                 @[@4,@2,@{NSFontAttributeName:font2Bold}],
                                 @[@6,@5,@{NSFontAttributeName:font1Bold}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_changeFontTraitsInRange_withBlock
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font1 = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 11)];
    UIFont* font2 = [UIFont fontWithName:@"Courier" size:19];
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];
    
    [str changeFontTraitsInRange:NSMakeRange(5, 3) withBlock:^UIFontDescriptorSymbolicTraits(UIFontDescriptorSymbolicTraits currentTraits) {
        return currentTraits | UIFontDescriptorTraitBold;
    }];
    
    NSSet* attr = attributesSetInString(str);

    UIFont* font1Bold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    UIFont* font2Bold = [UIFont fontWithName:@"Courier-Bold" size:19];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font1}],
                                 @[@4,@1,@{NSFontAttributeName:font2}],
                                 @[@5,@1,@{NSFontAttributeName:font2Bold}],
                                 @[@6,@2,@{NSFontAttributeName:font1Bold}],
                                 @[@8,@3,@{NSFontAttributeName:font1}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:YES];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontBold}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:NO];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoBold = [UIFont fontWithName:@"HelveticaNeue" size:42];
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontNoBold}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_range_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:YES range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontBold = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:fontBold}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_range_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:NO range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoBold = [UIFont fontWithName:@"HelveticaNeue" size:42];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:fontNoBold}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:YES];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontItalic = [UIFont fontWithName:@"HelveticaNeue-Italic" size:42];
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontItalic}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:NO];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoItalic = [UIFont fontWithName:@"HelveticaNeue" size:42];
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontNoItalic}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_range_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:YES range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontItalic = [UIFont fontWithName:@"HelveticaNeue-Italic" size:42];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:fontItalic}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_range_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"HelveticaNeue-Italic" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:NO range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoItalic = [UIFont fontWithName:@"HelveticaNeue" size:42];
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:fontNoItalic}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Link

- (void)test_setURL_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSURL* url = [NSURL URLWithString:@"foo://bar"];
    [str addAttribute:NSLinkAttributeName value:url range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@4,@2,@{NSLinkAttributeName:url}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Character Spacing

- (void)test_setCharacterSpacing
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setCharacterSpacing:42];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@0,@11,@{NSKernAttributeName: @42}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setCharacterSpacing_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setCharacterSpacing:42 range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@4,@2,@{NSKernAttributeName: @42}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Subscript and Superscript

- (void)test_setBaselineOffset
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setBaselineOffset:42];

    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@0,@11,@{NSBaselineOffsetAttributeName:@42}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setBaselineOffset_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setBaselineOffset:42 range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@4,@2,@{NSBaselineOffsetAttributeName:@42}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setSuperscriptForRange
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setSuperscriptForRange:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:font, NSBaselineOffsetAttributeName:@(21)}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setSubscriptForRange
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = [UIFont fontWithName:@"Helvetica" size:42];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setSubscriptForRange:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSFontAttributeName:font}],
                                 @[@4,@2,@{NSFontAttributeName:font, NSBaselineOffsetAttributeName:@(-21)}],
                                 @[@6,@5,@{NSFontAttributeName:font}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

/******************************************************************************/
#pragma mark - Paragraph Style

// ------------------------------------------------------------------------------------------
#if 0 // TODO - Work In Progress
// ------------------------------------------------------------------------------------------

- (void)test_setTextAlignment
{
    #pragma message("Implement this")
}

- (void)test_setTextAlignment_range
{
    #pragma message("Implement this")
}

- (void)test_setLineBreakMode
{
    #pragma message("Implement this")
}

- (void)test_setLineBreakMode_range
{
    #pragma message("Implement this")
}

- (void)test_changeParagraphStylesWithBlock
{
    #pragma message("Implement this")
}

- (void)test_changeParagraphStylesInRange_withBlock
{
    #pragma message("Implement this")
}

- (void)test_setParagraphStyle
{
    #pragma message("Implement this")
}

- (void)test_setParagraphStyle_range
{
    #pragma message("Implement this")
}

#endif

@end
