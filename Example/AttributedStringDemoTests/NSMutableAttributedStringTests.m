//
//  NSMutableAttributedStringTests.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 17/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHAttributedStringAdditions/NSMutableAttributedString+OHAdditions.h>

#import "OHASATestHelper.h"

@interface NSMutableAttributedStringTests : XCTestCase @end

@implementation NSMutableAttributedStringTests

/******************************************************************************/
#pragma mark - Text Font

- (void)test_setFont
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"Courier", 42);
    [str setFont:font];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:font}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFont_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"Courier", 42);
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
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 11)];
    UIFont* font2 = fontWithPostscriptName(@"Courier", 19);
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];
    
    [str changeFontTraitsWithBlock:^UIFontDescriptorSymbolicTraits(UIFontDescriptorSymbolicTraits currentTraits, NSRange _) {
        return currentTraits | UIFontDescriptorTraitBold;
    }];
    
    NSSet* attr = attributesSetInString(str);
    
    UIFont* font1Bold = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
    UIFont* font2Bold = fontWithPostscriptName(@"Courier-Bold", 19);
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
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, 11)];
    UIFont* font2 = fontWithPostscriptName(@"Courier", 19);
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];
    
    [str changeFontTraitsInRange:NSMakeRange(5, 3) withBlock:^UIFontDescriptorSymbolicTraits(UIFontDescriptorSymbolicTraits currentTraits, NSRange _) {
        return currentTraits | UIFontDescriptorTraitBold;
    }];
    
    NSSet* attr = attributesSetInString(str);

    UIFont* font1Bold = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
    UIFont* font2Bold = fontWithPostscriptName(@"Courier-Bold", 19);
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
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:YES];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontBold = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontBold}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_NO
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:NO];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoBold = fontWithPostscriptName(@"HelveticaNeue", 42);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontNoBold}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontBold_range_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:YES range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontBold = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
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
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue-Bold", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontBold:NO range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoBold = fontWithPostscriptName(@"HelveticaNeue", 42);
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
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:YES];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontItalic = fontWithPostscriptName(@"HelveticaNeue-Italic", 42);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontItalic}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue-Italic", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:NO];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoItalic = fontWithPostscriptName(@"HelveticaNeue", 42);
    NSSet* expectedAttributes = [NSSet setWithObject: @[@0,@11,@{NSFontAttributeName:fontNoItalic}] ];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setFontItalics_range_YES
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:YES range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontItalic = fontWithPostscriptName(@"HelveticaNeue-Italic", 42);
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
    UIFont* font = fontWithPostscriptName(@"HelveticaNeue-Italic", 42);
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, 11)];
    [str setFontItalics:NO range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    UIFont* fontNoItalic = fontWithPostscriptName(@"HelveticaNeue", 42);
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
    UIFont* font = fontWithPostscriptName(@"Helvetica", 42);
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
    UIFont* font = fontWithPostscriptName(@"Helvetica", 42);
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

- (void)test_setTextAlignment
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setTextAlignment:NSTextAlignmentJustified];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    NSSet* expectedAttributes = [NSSet setWithObject:@[@0,@11,@{NSParagraphStyleAttributeName:style}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setTextAlignment_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setTextAlignment:NSTextAlignmentJustified range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    NSSet* expectedAttributes = [NSSet setWithObject:@[@4,@2,@{NSParagraphStyleAttributeName:style}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);

}


- (void)test_setLineBreakMode
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setLineBreakMode:NSLineBreakByTruncatingMiddle];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSSet* expectedAttributes = [NSSet setWithObject:@[@0,@11,@{NSParagraphStyleAttributeName:style}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setLineBreakMode_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    [str setLineBreakMode:NSLineBreakByTruncatingMiddle range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByTruncatingMiddle;
    NSSet* expectedAttributes = [NSSet setWithObject:@[@4,@2,@{NSParagraphStyleAttributeName:style}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_changeParagraphStylesWithBlock
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSMutableParagraphStyle* styleMiddle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    styleMiddle.firstLineHeadIndent = 42;
    [str addAttribute:NSParagraphStyleAttributeName value:styleMiddle range:NSMakeRange(4, 2)];
    
    [str changeParagraphStylesWithBlock:^(NSMutableParagraphStyle *currentStyle, NSRange aRange) {
        currentStyle.lineSpacing = 29;
    }];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* styleOther = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    styleMiddle.lineSpacing = 29;
    styleOther.lineSpacing = 29;
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@0,@4,@{NSParagraphStyleAttributeName:styleOther}],
                                 @[@4,@2,@{NSParagraphStyleAttributeName:styleMiddle}],
                                 @[@6,@5,@{NSParagraphStyleAttributeName:styleOther}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_changeParagraphStylesInRange_withBlock
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSMutableParagraphStyle* styleMiddleOriginal = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    styleMiddleOriginal.firstLineHeadIndent = 42;
    [str addAttribute:NSParagraphStyleAttributeName value:styleMiddleOriginal range:NSMakeRange(4, 2)];
    
    [str changeParagraphStylesInRange:NSMakeRange(5, 3) withBlock:^(NSMutableParagraphStyle *currentStyle, NSRange aRange) {
        currentStyle.lineSpacing = 29;
    }];
    
    NSSet* attr = attributesSetInString(str);
    NSMutableParagraphStyle* styleOtherModified = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    NSMutableParagraphStyle* styleMiddleModified = [styleMiddleOriginal mutableCopy];
    styleMiddleModified.lineSpacing = 29;
    styleOtherModified.lineSpacing = 29;
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@4,@1,@{NSParagraphStyleAttributeName:styleMiddleOriginal}],
                                 @[@5,@1,@{NSParagraphStyleAttributeName:styleMiddleModified}],
                                 @[@6,@2,@{NSParagraphStyleAttributeName:styleOtherModified}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setParagraphStyle
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSMutableParagraphStyle* style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.firstLineHeadIndent = 42;
    style.lineSpacing = 29;
    style.defaultTabInterval = 37;
    style.paragraphSpacing = 18;
    style.alignment = NSTextAlignmentRight;
    
    [str setParagraphStyle:style];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObject:@[@0,@11,@{NSParagraphStyleAttributeName:style}]];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

- (void)test_setParagraphStyle_range
{
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"Hello world"];
    NSMutableParagraphStyle* style1 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style1.lineSpacing = 73;
    style1.tailIndent = 19;
    [str setParagraphStyle:style1 range:NSMakeRange(3, 4)];
    
    NSMutableParagraphStyle* style2 = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style2.firstLineHeadIndent = 42;
    style2.lineSpacing = 29;
    style2.defaultTabInterval = 37;
    style2.paragraphSpacing = 18;
    style2.alignment = NSTextAlignmentRight;
    [str setParagraphStyle:style2 range:NSMakeRange(4, 2)];
    
    NSSet* attr = attributesSetInString(str);
    NSSet* expectedAttributes = [NSSet setWithObjects:
                                 @[@3,@1,@{NSParagraphStyleAttributeName:style1}],
                                 @[@4,@2,@{NSParagraphStyleAttributeName:style2}],
                                 @[@6,@1,@{NSParagraphStyleAttributeName:style1}],
                                 nil];
    
    XCTAssertEqualObjects(attr, expectedAttributes);
}

@end
