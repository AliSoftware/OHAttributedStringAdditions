//
//  NSAttributedStringTests.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 16/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OHAttributedStringAdditions/NSAttributedString+OHAdditions.h>

#import <OHHTTPStubs/XCTestExpectation+OHRetroCompat.h>
#import "OHASATestHelper.h"

@interface NSAttributedStringTests : XCTestCase @end

@implementation NSAttributedStringTests

/******************************************************************************/
#pragma mark - Convenience Constructors

- (void)test_attributedStringWithString
{
    NSAttributedString* str = [NSAttributedString attributedStringWithString:@"Foo"];
    XCTAssertEqualObjects(str.string, @"Foo");
    XCTAssertEqual(attributesSetInString(str).count, 0U);
}

- (void)test_attributedStringWithString_nil
{
    NSAttributedString* str = [NSAttributedString attributedStringWithString:nil];
    XCTAssertNotNil(str);
    XCTAssertEqualObjects(str.string, @"");
    XCTAssertEqual(attributesSetInString(str).count, 0U);
}

- (void)test_attributedStringWithFormat
{
    NSAttributedString* str = [NSAttributedString attributedStringWithFormat:@"Foo-%@-%d-%.2f",@"Bar",42,1.234];
    XCTAssertNotNil(str);
    XCTAssertEqualObjects(str.string, @"Foo-Bar-42-1.23");
    XCTAssertEqual(attributesSetInString(str).count, 0U);
}

- (void)test_attributedStringWithAttributedString
{
    NSMutableAttributedString* base = [[NSMutableAttributedString alloc] initWithString:@"Hello, World"];
    [base addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(5,2)];
    NSAttributedString* str = [NSAttributedString attributedStringWithAttributedString:base];
    
    XCTAssertEqualObjects(str.string, @"Hello, World");
    NSSet* attrs = attributesSetInString(str);
    XCTAssertEqual(attrs.count, 1U);
    NSArray* colorAttr = @[ @5 , @2 , @{NSForegroundColorAttributeName:[UIColor blueColor]} ];
    XCTAssertTrue(([attrs containsObject:colorAttr]));
}

- (void)test_attributedStringWithAttributedString_nil
{
    NSAttributedString* str = [NSAttributedString attributedStringWithAttributedString:nil];
    
    XCTAssertNotNil(str);
    XCTAssertEqualObjects(str.string, @"");
    XCTAssertEqual(attributesSetInString(str).count, 0U);
}

NSString* HTMLFixture()
{
    return @"<p style='font-family:Helvetica; text-align:center; text-indent:20px; margin:0;'>"
    "Hello <b>world</b>, <i>this</i> is simple <tt>HTML</tt>."
    "</p>";
}

void assertHTMLAttributes(XCTestCase* self, NSAttributedString* str)
{
    NSMutableParagraphStyle* paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paraStyle.alignment = NSTextAlignmentCenter;
    paraStyle.firstLineHeadIndent = 20;
    paraStyle.tabStops = @[];
    paraStyle.defaultTabInterval = 36;
    paraStyle.baseWritingDirection = NSWritingDirectionLeftToRight;
    
    NSDictionary* commonAttr = @{ NSForegroundColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                  NSFontAttributeName: fontWithPostscriptName(@"Helvetica", 12),
                                  NSKernAttributeName: @0,
                                  NSParagraphStyleAttributeName: paraStyle,
                                  NSStrokeColorAttributeName: [UIColor colorWithRed:0 green:0 blue:0 alpha:1],
                                  NSStrokeWidthAttributeName: @0
                                  };
    
    NSSet* attrs = attributesSetInString(str);
    
    NSArray* attr_0_6 = @[ @0, @6, commonAttr ];
    XCTAssertTrue(([attrs containsObject:attr_0_6]));
    
    NSMutableDictionary* boldAttr = [NSMutableDictionary dictionaryWithDictionary:commonAttr];
    [boldAttr setObject:fontWithPostscriptName(@"Helvetica-Bold", 12) forKey:NSFontAttributeName];
    NSArray* attr_6_11 = @[ @6 , @5 , boldAttr ];
    XCTAssertTrue(([attrs containsObject:attr_6_11]));
    
    NSArray* attr_11_13 = @[ @11 , @2 , commonAttr ];
    XCTAssertTrue(([attrs containsObject:attr_11_13]));
    
    NSMutableDictionary* italicAttr = [NSMutableDictionary dictionaryWithDictionary:commonAttr];
    [italicAttr setObject:fontWithPostscriptName(@"Helvetica-Oblique", 12) forKey:NSFontAttributeName];
    NSArray* attr_13_17 = @[ @13 , @4 , italicAttr ];
    XCTAssertTrue(([attrs containsObject:attr_13_17]));
    
    NSArray* attr_17_28 = @[ @17 , @11 , commonAttr ];
    XCTAssertTrue(([attrs containsObject:attr_17_28]));
    
    NSMutableDictionary* teletextAttr = [NSMutableDictionary dictionaryWithDictionary:commonAttr];
    [teletextAttr setObject:fontWithPostscriptName(@"Courier", 12) forKey:NSFontAttributeName];
    NSArray* attr_28_32 = @[ @28 , @4 , teletextAttr ];
    XCTAssertTrue(([attrs containsObject:attr_28_32]));
    
    NSArray* attr_32_34 = @[ @32 , @2 , commonAttr ];
    XCTAssertTrue(([attrs containsObject:attr_32_34]));
}
- (void)test_attributedStringWithHTML
{
    NSAttributedString* str = [NSAttributedString attributedStringWithHTML:HTMLFixture()];
    
    XCTAssertEqualObjects(str.string, @"Hello world, this is simple HTML.\n");

    assertHTMLAttributes(self, str);
}

- (void)test_attributedStringWithHTML_nil
{
    NSAttributedString* str = [NSAttributedString attributedStringWithHTML:nil];
    
    XCTAssertNil(str);
}

- (void)test_loadHTMLString_completion
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTML import complete"];
    [NSAttributedString loadHTMLString:HTMLFixture() completion:^(NSAttributedString *attrString) {
        assertHTMLAttributes(self, attrString);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

- (void)test_loadHTMLString_completion_nil
{
    XCTestExpectation* expectation = [self expectationWithDescription:@"HTML import complete"];
    [NSAttributedString loadHTMLString:nil completion:^(NSAttributedString *attrString) {
        XCTAssertNil(attrString);
        [expectation fulfill];
    }];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

/******************************************************************************/
#pragma mark - Size

- (void)test_sizeConstrainedToSize_01
{
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:@"Hello World"];
    CGSize sz = [str sizeConstrainedToSize:CGSizeMake(200, CGFLOAT_MAX)];
    XCTAssertEqual(sz.width, 62);
    XCTAssertEqual(sz.height, 14);
}

- (void)test_sizeConstrainedToSize_02
{
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:@"Hello World"];
    CGSize sz = [str sizeConstrainedToSize:CGSizeMake(40, CGFLOAT_MAX)];
    XCTAssertEqual(sz.width, 32);
    XCTAssertEqual(sz.height, 28);
}

- (void)test_sizeConstrainedToSize_03
{
    NSAttributedString* str = [[NSAttributedString alloc] initWithString:@"Hello World"];
    CGSize sz = [str sizeConstrainedToSize:CGSizeMake(40, 16)];
    XCTAssertEqual(sz.width, 31);
    XCTAssertEqual(sz.height, 14);
}

/******************************************************************************/
#pragma mark - Text Font

- (void)runTestWithAttribute:(NSString*)attributeName
                      value1:(id)value1
                      value2:(id)value2
                expectation1:(id)expectation1
                expectation2:(id)expectation2
                   testBlock:(id(^)(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr))block
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    if (value1) {
        [str addAttribute:attributeName value:value1 range:NSMakeRange(0, str.length)];
    }
    if (value2) {
        [str addAttribute:attributeName value:value2 range:NSMakeRange(4, 2)];
    }
    
    NSRange range;
    id value;
    
    value = block(str,0,&range);
    XCTAssertEqualObjects(value, expectation1);
    XCTAssertEqual(range.location, 0U);
    XCTAssertEqual(range.length, 4U);
    
    value = block(str,2,&range);
    XCTAssertEqualObjects(value, expectation1);
    XCTAssertEqual(range.location, 0U);
    XCTAssertEqual(range.length, 4U);
    
    value = block(str,4,&range);
    XCTAssertEqualObjects(value, expectation2);
    XCTAssertEqual(range.location, 4U);
    XCTAssertEqual(range.length, 2U);
    
    value = block(str,5,&range);
    XCTAssertEqualObjects(value, expectation2);
    XCTAssertEqual(range.location, 4U);
    XCTAssertEqual(range.length, 2U);
    
    value = block(str,6,&range);
    XCTAssertEqualObjects(value, expectation1);
    XCTAssertEqual(range.location, 6U);
    XCTAssertEqual(range.length, 5U);
    
    value = block(str,10,&range);
    XCTAssertEqualObjects(value, expectation1);
    XCTAssertEqual(range.location, 6U);
    XCTAssertEqual(range.length, 5U);
}

- (void)runTestWithAttribute:(NSString*)attributeName
                      value1:(id)value1
                      value2:(id)value2
                   testBlock:(id(^)(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr))block
{
    [self runTestWithAttribute:attributeName
                        value1:value1 value2:value2
                  expectation1:value1 expectation2:value2
                     testBlock:block];
}

- (void)test_fontAtIndex_effectiveRange
{
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    UIFont* font2 = fontWithPostscriptName(@"Courier", 24);
    [self runTestWithAttribute:NSFontAttributeName
                        value1:font1 value2:font2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str fontAtIndex:idx effectiveRange:rangePtr];
     }];
}

- (void)test_enumerateFontsInRange_includeUndefined_usingBlock_01
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, str.length)];
    UIFont* font2 = fontWithPostscriptName(@"Courier", 24);
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];

    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateFontsInRange:NSMakeRange(0, str.length)
              includeUndefined:YES
                    usingBlock:^(UIFont *font, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), font ?: [NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@0,@4,font1],
                                @[@4,@2,font2],
                                @[@6,@5,font1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

- (void)test_enumerateFontsInRange_includeUndefined_usingBlock_02
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(0, str.length)];
    UIFont* font2 = fontWithPostscriptName(@"Courier", 24);
    [str addAttribute:NSFontAttributeName value:font2 range:NSMakeRange(4, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateFontsInRange:NSMakeRange(5, 3)
              includeUndefined:YES
                    usingBlock:^(UIFont *font, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), font ?: [NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@5,@1,font2],
                                @[@6,@2,font1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

- (void)test_enumerateFontsInRange_includeUndefined_usingBlock_03
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(4, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateFontsInRange:NSMakeRange(5, 3)
              includeUndefined:NO
                    usingBlock:^(UIFont *aFont, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), aFont ?: [NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@5,@1,font1] ];
    XCTAssertEqualObjects(stack, expectedStack);
}

- (void)test_enumerateFontsInRange_includeUndefined_usingBlock_04
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    UIFont* font1 = fontWithPostscriptName(@"HelveticaNeue", 42);
    [str addAttribute:NSFontAttributeName value:font1 range:NSMakeRange(4, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateFontsInRange:NSMakeRange(5, 3)
              includeUndefined:YES
                    usingBlock:^(UIFont *aFont, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), aFont ?: [NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@5,@1,font1],
                                @[@6,@2,[NSNull null]]];
    XCTAssertEqualObjects(stack, expectedStack);
}

/******************************************************************************/
#pragma mark - Text Color

- (void)test_textColorAtIndex_effectiveRange
{
    UIColor* color1 = [UIColor blueColor];
    UIColor* color2 = [UIColor redColor];
    [self runTestWithAttribute:NSForegroundColorAttributeName
                        value1:color1 value2:color2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str textColorAtIndex:idx effectiveRange:rangePtr];
     }];
}

- (void)test_textBackgroundColorAtIndex_effectiveRange
{
    UIColor* color1 = [UIColor blueColor];
    UIColor* color2 = [UIColor redColor];
    [self runTestWithAttribute:NSBackgroundColorAttributeName
                        value1:color1 value2:color2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str textBackgroundColorAtIndex:idx effectiveRange:rangePtr];
     }];
}

/******************************************************************************/
#pragma mark - Text Underlining

- (void)test_isTextUnderlinedAtIndex_effectiveRange_01
{
    NSUnderlineStyle style1 = NSUnderlineStyleSingle|NSUnderlinePatternDot;
    NSUnderlineStyle style2 = NSUnderlineStyleDouble|NSUnderlinePatternDash;
    [self runTestWithAttribute:NSUnderlineStyleAttributeName
                        value1:@(style1) value2:@(style2)
                  expectation1:@YES expectation2:@YES
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str isTextUnderlinedAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_isTextUnderlinedAtIndex_effectiveRange_02
{
    NSUnderlineStyle style1 = NSUnderlineStyleDouble|NSUnderlinePatternDash;
    NSUnderlineStyle style2 = NSUnderlineStyleNone;
    [self runTestWithAttribute:NSUnderlineStyleAttributeName
                        value1:@(style1) value2:@(style2)
                  expectation1:@YES expectation2:@NO
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str isTextUnderlinedAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_textUnderlineStyleAtIndex_effectiveRange
{
    NSUnderlineStyle style1 = NSUnderlineStyleSingle|NSUnderlinePatternDot;
    NSUnderlineStyle style2 = NSUnderlineStyleDouble|NSUnderlinePatternDash;
    [self runTestWithAttribute:NSUnderlineStyleAttributeName
                        value1:@(style1) value2:@(style2)
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str textUnderlineStyleAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_textUnderlineColorAtIndex_effectiveRange
{
    UIColor* color1 = [UIColor blueColor];
    UIColor* color2 = [UIColor redColor];
    [self runTestWithAttribute:NSUnderlineColorAttributeName
                        value1:color1 value2:color2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str textUnderlineColorAtIndex:idx effectiveRange:rangePtr];
     }];
}

/******************************************************************************/
#pragma mark - Text Style & Traits

- (void)test_isFontBoldAtIndex_effectiveRange
{
    UIFont* font1 = fontWithPostscriptName(@"Helvetica", 12);
    UIFont* font2 = fontWithPostscriptName(@"HelveticaNeue-CondensedBold", 12);
    [self runTestWithAttribute:NSFontAttributeName
                        value1:font1 value2:font2
                  expectation1:@NO expectation2:@YES
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str isFontBoldAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_isFontItalicsAtIndex_effectiveRange
{
    UIFont* font1 = fontWithPostscriptName(@"Helvetica-Bold", 12);
    UIFont* font2 = fontWithPostscriptName(@"Helvetica-Oblique", 12);
    [self runTestWithAttribute:NSFontAttributeName
                        value1:font1 value2:font2
                  expectation1:@NO expectation2:@YES
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str isFontItalicsAtIndex:idx effectiveRange:rangePtr]);
     }];
}

/******************************************************************************/
#pragma mark - Link

- (void)test_URLAtIndex_effectiveRange
{
    NSURL* url1 = nil;
    NSURL* url2 = [NSURL URLWithString:@"foo://bar"];
    [self runTestWithAttribute:NSLinkAttributeName
                        value1:url1 value2:url2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str URLAtIndex:idx effectiveRange:rangePtr];
     }];
}

- (void)test_enumerateURLsInRange_usingBlock_01
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    NSURL* url1 = [NSURL URLWithString:@"foo://1"];
    [str addAttribute:NSLinkAttributeName value:url1 range:NSMakeRange(1, 8)];
    NSURL* url2 = [NSURL URLWithString:@"foo://2"];
    [str addAttribute:NSLinkAttributeName value:url2 range:NSMakeRange(5, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateURLsInRange:NSMakeRange(0, str.length)
                   usingBlock:^(NSURL *link, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), link?:[NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@1,@4,url1],
                                @[@5,@2,url2],
                                @[@7,@2,url1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

- (void)test_enumerateURLsInRange_usingBlock_02
{
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    NSURL* url1 = [NSURL URLWithString:@"foo://1"];
    [str addAttribute:NSLinkAttributeName value:url1 range:NSMakeRange(1, 8)];
    NSURL* url2 = [NSURL URLWithString:@"foo://2"];
    [str addAttribute:NSLinkAttributeName value:url2 range:NSMakeRange(5, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateURLsInRange:NSMakeRange(6, 4)
                   usingBlock:^(NSURL *link, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), link ?: [NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@6,@1,url2],
                                @[@7,@2,url1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

/******************************************************************************/
#pragma mark - Character Spacing

- (void)test_characterSpacingAtIndex_effectiveRange
{
    [self runTestWithAttribute:NSKernAttributeName
                        value1:nil value2:@(4.2f)
                  expectation1:@(0.f) expectation2:@(4.2f)
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str characterSpacingAtIndex:idx effectiveRange:rangePtr]);
     }];
}

/******************************************************************************/
#pragma mark - Subscript and Superscript

- (void)test_baselineOffsetAtIndex_effectiveRange
{
    [self runTestWithAttribute:NSBaselineOffsetAttributeName
                        value1:nil value2:@(4.2f)
                  expectation1:@(0.f) expectation2:@(4.2f)
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str baselineOffsetAtIndex:idx effectiveRange:rangePtr]);
     }];
}

/******************************************************************************/
#pragma mark - Paragraph Style

- (void)test_textAlignmentAtIndex_effectiveRange
{
    NSParagraphStyle* style1 = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle* style2 = [style1 mutableCopy];
    style2.alignment = NSTextAlignmentRight;
    
    [self runTestWithAttribute:NSParagraphStyleAttributeName
                        value1:style1 value2:style2
                  expectation1:@(NSTextAlignmentNatural) expectation2:@(NSTextAlignmentRight)
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str textAlignmentAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_lineBreakModeAtIndex_effectiveRange
{
    NSParagraphStyle* style1 = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle* style2 = [style1 mutableCopy];
    style2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    
    [self runTestWithAttribute:NSParagraphStyleAttributeName
                        value1:style1 value2:style2
                  expectation1:@(NSLineBreakByWordWrapping) expectation2:@(NSLineBreakByTruncatingMiddle)
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return @([str lineBreakModeAtIndex:idx effectiveRange:rangePtr]);
     }];
}

- (void)test_paragraphStyleAtIndex_effectiveRange
{
    NSParagraphStyle* defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle* style1 = [defaultStyle mutableCopy];
    style1.lineSpacing = 5;
    style1.firstLineHeadIndent = 12;
    style1.defaultTabInterval = 42;
    
    NSMutableParagraphStyle* style2 = [defaultStyle mutableCopy];
    style2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    style2.alignment = NSTextAlignmentRight;
    style2.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    [self runTestWithAttribute:NSParagraphStyleAttributeName
                        value1:style1 value2:style2
                     testBlock:^id(NSAttributedString *str, NSUInteger idx, NSRangePointer rangePtr)
     {
         return [str paragraphStyleAtIndex:idx effectiveRange:rangePtr];
     }];
}

- (void)test_enumerateParagraphStylesInRange_includeUndefined_usingBlock_01
{
    NSParagraphStyle* defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle* style1 = [defaultStyle mutableCopy];
    style1.lineSpacing = 5;
    style1.firstLineHeadIndent = 12;
    style1.defaultTabInterval = 42;
    
    NSMutableParagraphStyle* style2 = [defaultStyle mutableCopy];
    style2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    style2.alignment = NSTextAlignmentRight;
    style2.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    [str addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(1, 8)];
    [str addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(5, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateParagraphStylesInRange:NSMakeRange(0, str.length)
                        includeUndefined:NO
                              usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), style?:[NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@1,@4,style1],
                                @[@5,@2,style2],
                                @[@7,@2,style1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

- (void)test_enumerateParagraphStylesInRange_includeUndefined_usingBlock_02
{
    NSParagraphStyle* defaultStyle = [NSParagraphStyle defaultParagraphStyle];
    NSMutableParagraphStyle* style1 = [defaultStyle mutableCopy];
    style1.lineSpacing = 5;
    style1.firstLineHeadIndent = 12;
    style1.defaultTabInterval = 42;
    
    NSMutableParagraphStyle* style2 = [defaultStyle mutableCopy];
    style2.lineBreakMode = NSLineBreakByTruncatingMiddle;
    style2.alignment = NSTextAlignmentRight;
    style2.baseWritingDirection = NSWritingDirectionRightToLeft;
    
    NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithString:@"Hello World"];
    [str addAttribute:NSParagraphStyleAttributeName value:style1 range:NSMakeRange(1, 8)];
    [str addAttribute:NSParagraphStyleAttributeName value:style2 range:NSMakeRange(5, 2)];
    
    NSMutableArray* stack = [NSMutableArray array];
    [str enumerateParagraphStylesInRange:NSMakeRange(6, 4)
                        includeUndefined:NO
                              usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL *stop)
     {
         [stack addObject:@[@(range.location), @(range.length), style?:[NSNull null]]];
     }];
    
    NSArray* expectedStack = @[ @[@6,@1,style2],
                                @[@7,@2,style1]];
    XCTAssertEqualObjects(stack, expectedStack);
}

@end
