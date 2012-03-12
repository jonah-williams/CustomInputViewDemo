# Customizing the iOS keyboard

Our applications need input and the default iOS keyboards are often not optimally suited to providing the sort of data we want. When we find that we really wish the keyboard had some extra controls or want to help our users enter a specific set of symbols it is time to customize our apps' keyboards.

## What controls the keyboard anyway?

Our first exposure to different keyboard types probably comes from `UITextField` and `UITextView`. Both provide conform to the `UITextInputTraits` protocol which gives us options to set the keyboard type, return key type, keyboard appearance, and other behaviors. Those options cover many of the types of text input we might want to support; plain text, passwords, email addresses, urls, and so on. That's a good place to start customizing our keyboard options but `UITextInputTraits` itself doesn't present the keyboard so when we need behavior the protocol doesn't provide we will have to keep looking.

Traversing up the class hierarchy we see that `UITextField`, `UITextView`, and indeed all `UIView` objects inherit from `UIResponer`. All of the responder objects in our views form a responder chain, a sequence of objects which will be given a chance to respond to non-touch input events. (If this isn't a familiar topic then take a look at "Responder Objects and the Responder Chain" in the "Event Handling Guide for iOS" for a full discussion of how the system works.)  Whenever a responder becomes the first responder (see `-becomeFirstResponer`) it determines what, if any, keyboard needs to be shown.
`UIResponder` gives us two read-only properties for controlling the keyboard's appearance; `inputView` which provides the keyboard itself and `inputAccessoryView` which controls the accessory view attached to the top of the keyboard (containing the "next" and "previous" buttons when editing a form in Mobile Safari for example). By returning our own views from these properties we can replace the system keyboards with any custom `UIView` we care to construct.

## Start simple: customizing UITextView

`UITextField` (and `UITextView`) redefine their `inputView` and `inputAccessoryView` properties to be `readwrite` instead of `readonly`. When working with these view classes we can therefore set their keyboard easily from some other class, like our view controller.

Suppose we were want to support editing [markdown](http://daringfireball.net/projects/markdown/) formatted text in our app. The system keyboards work well for this but it takes three taps to enter a \# or \* and \` doesn't appear on the keyboard at all. That's going to make it difficult for our users to emphasize text or insert code blocks. Let's add an input accessory view to give them "emphasize", "strong", and "code" formatting controls.

Given a simple view controller with `UITextView *textView` and `UIView *accessoryView` outlets we can set the text view's `inputAccessoryView` in our `-viewDidLoad`.

	@interface MarkdownViewController : UIViewController

	@property (nonatomic, strong) IBOutlet UITextView *textView;
	@property (nonatomic, strong) IBOutlet UIView *accessoryView;
	
	@end

	@implementation MarkdownViewController

	@synthesize textView;
	@synthesize accessoryView;
	
	- (void)viewDidLoad
	{
	    [super viewDidLoad];
	    self.textView.inputAccessoryView = self.accessoryView;
	}
	
	- (void)viewDidUnload
	{
	    [super viewDidUnload];
	    self.textView = nil;
	    self.accessoryView = nil;
	}
	
	@end

Now when the text view becomes the first responder we see our accessory view added to the top of the keyboard.

### Responding to input

Showing our accessory view is only half of the solution. We also want to make changes to our text view's content when a user taps one of the accessory view's buttons. Let's create a custom view class for our accessory view and give it a reference to the text field.

	@interface MarkdownInputAccessoryView : UIView
	
	@property(nonatomic, weak) id <UITextInput> delegate;
	
	- (IBAction)toggleStrong:(id)sender;
	- (IBAction)toggleEmphasis:(id)sender;
	- (IBAction)toggleCode:(id)sender;
	
	@end

	@implementation MarkdownInputAccessoryView
	
	@synthesize delegate;
	
	- (IBAction)toggleStrong:(id)sender {
	    UITextRange *selectedText = [delegate selectedTextRange];
	    if (selectedText == nil) {
	        //no selection or insertion point
	        //...
	    }
	    else if (selectedText.empty) {
	        //inserting text at an insertion point
	        [delegate replaceRange:selectedText withText:@"*"];
	        //...
	    }
	    else {
	        //updated a selected range
	        //...
	    }
	}
	
	- (IBAction)toggleEmphasis:(id)sender {
	    //...
	}
	
	- (IBAction)toggleCode:(id)sender {
	    //...
	}
	
	@end

Our controller can then set the delegate property and the accessory view will be able to update the text field.

	//...
	@property (nonatomic, strong) IBOutlet UIView *accessoryView;
	//...
	- (void)viewDidLoad
	{
	    [super viewDidLoad];
	    self.accessoryView.delegate = self.textView;
	    self.textView.inputAccessoryView = self.accessoryView;
	}

## Adding complexity: keyboards for a custom UIView

Adding a custom input view is much the same as adding a custom input accessory view. When we're working with a `UITextField` or `UITextView` we can create the custom view and pass it to the appropriate property's setter.If however we have built a custom `UIView` subclass then we have to do a little more work. 

If it still makes sense for a view controller or other class to provide the view with its input views then we can redeclare `inputView` and `inputAccessoryView` as `readwrite` properties, exposing setters so that the view can be given references to the input views it should use. Alternately we can override the `inputView` and `inputAccessoryView` getter methods to return appropriate views. I tend to prefer the latter option because it allows a view to how its own input controls should be presented but if selecting an appropriate input view depends on factors like the current interface idiom or language then it may make more sense for an external service to provide an input view for the current view.

If we wanted to build a view for displaying a score of sheet music we might build something like the following.

	@class MusicScoreView;
	
	@interface MusicScoreInputView : UIView
	
	@property (nonatomic, weak) IBOutlet MusicScoreView *delegate;
	
	@end
	
	@interface MusicScoreView ()
	
	@property(nonatomic, readwrite, strong) IBOutlet UIView *inputView;
	
	- (void) loadInputView;
	
	@end
	
	@implementation MusicScoreView
	
	@synthesize inputView;
	
	- (id)initWithFrame:(CGRect)frame {
	    self = [super init];
	    if (self) {
	        [self loadInputView];
	    }
	    return self;    
	}
	
	- (id)initWithCoder:(NSCoder *)coder
	{
	    self = [super initWithCoder:coder];
	    if (self) {
	        [self loadInputView];
	    }
	    return self;
	}
	
	- (void)loadInputView {
	    UINib *inputViewNib = [UINib nibWithNibName:@"MusicScoreInputView" bundle:nil];
	    [inputViewNib instantiateWithOwner:self options:nil];
	}
	
	@end

	@interface MusicScoreInputView : UIView
	
	@property (nonatomic, weak) IBOutlet MusicScoreView *delegate;
	
	@end
	
	@implementation MusicScoreInputView
	
	@synthesize delegate;
	
	@end

## Visual styling: reacting to the keyboard

Now that we can display a custom keyboard we still need to make sure to adjust our views when it appears. Since the actual presentation of our input view is handled by UIKit we need to observe and react to the notifications the framework sends to announce changes in the input view's position. Apple provides a set of `NSNotification`s we can observe:

* `UIKeyboardWillShowNotification`
* `UIKeyboardDidShowNotification`
* `UIKeyboardWillHideNotification`
* `UIKeyboardDidHideNotification`

Each of these notifications includes a user info dictionary which describes the frame of the keyboard before and after its transition and the timing of the animation which will be used to show or hide it. When we rotate a device the keyboard may be resized to better support the new orientation. In that case we'll need to update the insets or positions of our other views as well to reflect these new dimensions. Again UIKit provides a set of notifications we can observe to determine the changing bounds of the keyboard and react accordingly.

* `UIKeyboardWillChangeFrameNotification`
* `UIKeyboardDidChangeFrameNotification`

Given these we can respond to the appearance or disappearance of the keyboard as needed.

	- (void)viewWillAppear:(BOOL)animated {
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScrollInsets:) name:UIKeyboardWillShowNotification object:nil];
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateScrollInsets:) name:UIKeyboardWillChangeFrameNotification object:nil];
	    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetScrollInsets:) name:UIKeyboardWillHideNotification object:nil];
	}
	
	- (void)viewDidDisappear:(BOOL)animated {
	    [[NSNotificationCenter defaultCenter] removeObserver:self];
	}

In most cases we will want to respond by adjusting the `contentInset` and `scrollIndicatorInsets` of a `UIScrollView` to add enough padding to the bottom of our scroll view's content view that all of its content can scroll to a position above the top of the keyboard. Alternately we might adjust the frames of some of our views directly but this is less desirable because it might leave a blank region on the screen (rather than showing the scroll view's background color), especially on an iPad where the user can choose to split the keyboard.

To calculate the appropriate insets we need to be aware that the keyboard is presented anchored to the bottom of the window, which is not necessarily flush with the bottom of the current view controller's view (for example we might have a tab bar or tool bar visible). We should only add insets equal to the height of the portion of our view which is being hidden by the keyboard.

	- (void) updateScrollInsets:(NSNotification *)notification {
	    //determine what portion of the view will be hidden by the keyboard
	    CGRect keyboardEndFrameInScreenCoordinates;
	    [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrameInScreenCoordinates];
	    CGRect keyboardEndFrameInWindowCoordinates = [self.view.window convertRect:keyboardEndFrameInScreenCoordinates fromWindow:nil];
	    CGRect keyboardEndFrameInViewCoordinates = [self.view convertRect:keyboardEndFrameInWindowCoordinates fromView:nil];
	    CGRect windowFrameInViewCoords = [self.view convertRect:self.view.window.frame fromView:nil];
	    CGFloat heightBelowViewInWindow = windowFrameInViewCoords.origin.y + windowFrameInViewCoords.size.height - (self.view.frame.origin.y + self.view.frame.size.height);
	    CGFloat heightCoveredByKeyboard = keyboardEndFrameInViewCoordinates.size.height - heightBelowViewInWindow;
	    
	    //build an inset to add padding to the content view equal to the height of the portion of the view hidden by the keyboard
	    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, heightCoveredByKeyboard, 0);
	    [self setInsets:insets givenUserInfo:notification.userInfo];
	}
	
	- (void) resetScrollInsets:(NSNotification *)notification {
	    UIEdgeInsets insets = UIEdgeInsetsMake(0, 0, 0, 0);
	    [self setInsets:insets givenUserInfo:notification.userInfo];
	}
	
	- (void) setInsets:(UIEdgeInsets)insets givenUserInfo:(NSDictionary *)userInfo {
	    //match the keyboard's animation
	    double duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
	    UIViewAnimationCurve animationCurve = [[userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
	    UIViewAnimationOptions animationOptions = animationCurve;
	    [UIView animateWithDuration:duration delay:0 options:animationOptions animations:^{
	        self.textView.contentInset = insets;
	        self.textView.scrollIndicatorInsets = insets;
	    } completion:nil];
	}

## Summary

We've seen how to define custom input and input accessory views to enhance or replace the system keyboard. How to add those input views to existing text fields, text views, and to our own custom view classes. When an input view does appear we can also now appropriately adjust the rest of our content to accommodate it. With these tools we should now be ready to build custom input views tailored to the type of data we need and the context in which it will be gathered.