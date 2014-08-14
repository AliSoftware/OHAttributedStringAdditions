//
//  ASDViewController.m
//  AttributedStringDemo
//
//  Created by Olivier Halligon on 13/08/2014.
//  Copyright (c) 2014 AliSoftware. All rights reserved.
//

#import "ASDViewController.h"

#import "OHAttributedStringAdditions.h"

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
    dispatch_once(&onceToken, ^{
        NSString* html = @""
        "Hello <b>world</b>!<br>"
        "<br>"
        "This is <a href='https://github.com/AliSoftware/OHAttributedStringAdditions'>OHAttributedStringAdditions</a>, a cool <i>category</i> that "
        "lets you <font color='red'>manipulate</font> <tt>NSAttributedString</tt> with nicer methods<sup>(1)</sup>.<br>"
        "<p style='text-align:center'>Amazing, isn't it?</p>"
        "<p style='text-indent:20px;'>You can even indent your text paragraphs to make nice text layouts, justify paragraphs, and all!</p>"
        "<p><sup>(1)</sup>Easily get, set or change:<ul>"
        "<li>Fonts : <tt>setFont:range:</tt></li>"
        "<li>Colors : <tt>setTextColor:range:</tt></li>"
        "<li>Style : <tt>setTextBold:range:</tt>, <tt>setTextUnderlined:range:</tt>, …</li>"
        "<li>URLs : <tt>setURL:range:</tt></li>"
        "<li>And much more</li>"
        "</ul>";
        
        NSMutableAttributedString* str = [NSMutableAttributedString attributedStringWithHTML:html];
        
        // Scale the font size by +50%
        [str enumerateFontsInRange:str.fullRange usingBlock:^(UIFont *font, NSRange range, BOOL *stop) {
            UIFont* newFont = [UIFont fontWithName:font.fontName size:font.pointSize * 1.5];
            [str setFont:newFont range:range];
        }];
        
        [str setTextUnderlined:YES range:[str.string rangeOfString:@"Amazing"]];
        
        [str enumerateParagraphStylesInRange:str.fullRange usingBlock:^(NSParagraphStyle *style, NSRange range, BOOL *stop) {
            // For example, justify only paragraphs that have a indentation
            if (style.firstLineHeadIndent > 0)
            {
                [str setTextAlignment:NSTextAlignmentJustified range:range];
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
