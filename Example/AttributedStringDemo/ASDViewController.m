//
//  ASDViewController.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 13/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import "ASDViewController.h"

#import <OHAttributedStringAdditions/OHAttributedStringAdditions.h>

@interface ASDViewController () <UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UITextView* textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* bottomDistance;
@end

@implementation ASDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.textView.attributedText = [self originalString];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAnimation:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSAttributedString*)originalString
{
    static NSAttributedString* originalString;
    static dispatch_once_t onceToken;
#define LIST_TITLE @"Easily get, set or change"
    dispatch_once(&onceToken, ^{
        NSString* html = @""
        "Hello <b>you</b>!<br>"
        "<br>"
        "<p>This is <a href='https://github.com/AliSoftware/OHAttributedStringAdditions'>OHAttributedStringAdditions</a>,"
            " a cool <i>category</i> that lets you <font color='red'>manipulate</font> <tt>NSAttributedString</tt>"
            " with nicer methods<sup>(1)</sup>.</p>"
        "<p>For example you can change the <font face='Zapfino'>font</font>, make text"
            " <b>bold</b>, <i>italics</i> or <u>underlined</u>, …</p>"
        "<p style='text-align:center'>Amazing, isn't it?</p>"
        "<p style='text-indent:30px;'>You can even <font color='#da0'>indent</font> the first line of your"
            " paragraphs to make nice text layouts, justify paragraphs, and a lot more!</p>"
        "<p><sup>(1)</sup>" LIST_TITLE ":<ul>"
        "<li>Fonts : <tt>setFont:range:</tt></li>"
        "<li>Colors : <tt>setTextColor:range:</tt></li>"
        "<li>Style : <tt>setTextBold:range:</tt>, <tt>setTextUnderlined:range:</tt>, …</li>"
        "<li>URLs : <tt>setURL:range:</tt></li>"
        "<li>Paragraph style (indentation, text alignment, …)</li>"
        "<li>And much more</li>"
        "</ul></p>"
        "<p style='text-indent:30px'><font color='gray'>Note: Part of this attributed string is created"
            " by using <font color='#00c'>basic HTML code</font>, and some other attribues"
            " are <font color='#00c'>set by code</font> to demonstrate the usage of"
            " <tt>OHAttributedStringAdditions</tt> methods.</font></p>"
        "<i><center>Don't hesitate to try the search field at the top of the screen."
            " Searched text will be highlighted dynamically!</center></i>";
        
        NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithHTML:html];
        
        // Scale the font size by +50%
        [str enumerateFontsInRange:NSMakeRange(0,str.length)
                  includeUndefined:YES
                        usingBlock:^(UIFont *font, NSRange range, BOOL *stop)
        {
            if (!font) font = [NSAttributedString defaultFont];
            UIFont* newFont = [font fontWithSize:font.pointSize * 1.5f] ;
            [str setFont:newFont range:range];
        }];
        
        [str setTextUnderlined:YES range:[str.string rangeOfString:@"Amazing"]];
        NSRange listTitleRange = [str.string rangeOfString:LIST_TITLE];
        [str setTextColor:[UIColor colorWithRed:0 green:0.5 blue:0 alpha:1.] range:listTitleRange];
        [str setTextUnderlineStyle:NSUnderlineStyleThick|NSUnderlinePatternDot range:listTitleRange];
        
        [str changeParagraphStylesInRange:NSMakeRange(0, str.length)
                                withBlock:^(NSMutableParagraphStyle* style, NSRange aRange)
        {
            // For example, justify only paragraphs that have a indentation
            if (style.firstLineHeadIndent > 0)
            {
                style.alignment = NSTextAlignmentJustified;
            }
        }];
        
        originalString = [str copy];
    });
    return originalString;
}

// MARK: Tap on a link

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    // Intercept taps on links to display an alert instead of opening it in Safari
    [[[UIAlertView alloc] initWithTitle:@"URL Tapped"
                                message:URL.absoluteString
                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    return NO;
}

// MARK: Text Search

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length > 0)
    {
        NSMutableAttributedString* highlightedString = [[self originalString] mutableCopy];
        
        NSRegularExpressionOptions options = NSRegularExpressionCaseInsensitive|NSRegularExpressionIgnoreMetacharacters;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:searchText
                                                                               options:options
                                                                                 error:NULL];
        [regex enumerateMatchesInString:self.textView.text
                                options:0
                                  range:NSMakeRange(0, self.textView.text.length)
                             usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop)
         {
             [highlightedString setTextBackgroundColor:[UIColor yellowColor] range:result.range];
         }];
        
        self.textView.attributedText = highlightedString;
    }
    else
    {
        // Reset to unhighlighted string
        self.textView.attributedText = [self originalString];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    self.textView.attributedText = [self originalString];
    [searchBar resignFirstResponder];
}

- (void)keyboardAnimation:(NSNotification*)notif
{
    NSTimeInterval animDuration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect endFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.bottomDistance.constant = self.view.window.bounds.size.height - endFrame.origin.y;
    [UIView animateWithDuration:animDuration animations:^{
        [self.textView layoutIfNeeded];
    }];
}

@end
