//
//  BNSubmitSinglePaymentVC.m
//  Copyright (c) 2016 Bambora ( http://bambora.com/ )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BNSubmitSinglePaymentCardVC.h"
#import "BNBaseTextField.h"
#import "BNCreditCardNumberTextField.h"
#import "BNCreditCardExpiryTextField.h"
#import "UIView+BNUtils.h"
#import "UIColor+BNColors.h"
#import "UITextField+BNCreditCard.h"
#import "BNLoaderButton.h"
#import "BNSwitchButton.h"

NSInteger const SinglePaymentTextFieldHeight = 50;
NSInteger const SinglePaymentButtonHeight = 50;
NSInteger const SinglePaymentPadding = 15;
NSInteger const SinglePaymentTitleHeight = 30;
NSInteger const SinglePaymentSaveCardLabelWidth = 75;

@interface BNSubmitSinglePaymentCardVC ()

@property (nonatomic, strong) UIScrollView *formScrollView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *saveCardLabel;


@property (nonatomic, strong) BNCreditCardHolderTextField *cardHolderTextField;
@property (nonatomic, strong) BNCreditCardNumberTextField *cardNumberTextField;
@property (nonatomic, strong) BNCreditCardExpiryTextField *cardExpiryTextField;
@property (nonatomic, strong) BNBaseTextField *cardCVCTextField;

@property (nonatomic, strong) BNSwitchButton *switchSaveCardButton;
@property (nonatomic, strong) BNLoaderButton *submitButton;



@end

@implementation BNSubmitSinglePaymentCardVC




- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupCreditCardForm];
    [self.cardHolderTextField becomeFirstResponder];
}

- (BOOL) IsViewValid {
 
    if(_paymentParams &&
       _paymentParams.amount &&
       _paymentParams.amount>0)
    {
        return true;
    }
    return false;
}

- (void)viewWillAppear:(BOOL)animated {
    if([self IsViewValid])
    {
        [super viewWillAppear:animated];
        [self layoutCreditCardForm];
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [UIView setAnimationsEnabled:NO];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [UIView setAnimationsEnabled:YES];
        [self layoutCreditCardForm];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
    }];
    
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
}

- (void)layoutCreditCardForm {
    CGRect viewRect = self.view.bounds;
    
    self.formScrollView.frame = viewRect;
    
    self.titleLabel.frame = CGRectMake(SinglePaymentPadding,
                                       SinglePaymentPadding*2,
                                       CGRectGetWidth(viewRect)-2*SinglePaymentPadding,
                                       SinglePaymentTitleHeight);
    
    NSInteger inputWidth = floorf(CGRectGetWidth(viewRect)-2*SinglePaymentPadding);
    inputWidth -= inputWidth % 2;
    
    self.cardHolderTextField.frame = CGRectMake(SinglePaymentPadding,
                                                CGRectGetMaxY(self.titleLabel.frame),
                                                inputWidth,
                                                SinglePaymentTextFieldHeight);
    
    self.cardNumberTextField.frame = CGRectMake(SinglePaymentPadding,
                                                CGRectGetMaxY(self.cardHolderTextField.frame)-1,
                                                inputWidth,
                                                SinglePaymentTextFieldHeight);
    
    self.cardExpiryTextField.frame = CGRectMake(SinglePaymentPadding,
                                                CGRectGetMaxY(self.cardNumberTextField.frame)-1,
                                                ceilf((inputWidth)/2.f),
                                                SinglePaymentTextFieldHeight);
    
    self.cardCVCTextField.frame = CGRectMake(CGRectGetMaxX(self.cardExpiryTextField.frame)-1,
                                             CGRectGetMaxY(self.cardNumberTextField.frame)-1,
                                             ceilf((inputWidth)/2.f)+1,
                                             SinglePaymentTextFieldHeight);
    
    self.saveCardLabel.frame = CGRectMake(SinglePaymentPadding,
                                       CGRectGetMaxY(self.cardExpiryTextField.frame)+6,
                                       SinglePaymentSaveCardLabelWidth,
                                       SinglePaymentTitleHeight);
    
    self.switchSaveCardButton.frame = CGRectMake(CGRectGetMaxX(self.saveCardLabel.frame)+1,
                                             CGRectGetMaxY(self.cardExpiryTextField.frame)+6,
                                             0, 0);
    
    self.submitButton.frame = CGRectMake(0,
                                         CGRectGetHeight(self.formScrollView.frame)-SinglePaymentButtonHeight,
                                         CGRectGetWidth(viewRect),
                                         SinglePaymentButtonHeight);
}

- (void)setupCreditCardForm {
    self.formScrollView = [UIScrollView new];
    self.formScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:self.formScrollView];
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.text = NSLocalizedString(@"ENTER CARD DETAILS", @"Card details");
    self.titleLabel.textColor = [UIColor BNTextColor];
    self.titleLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
    [self.formScrollView addSubview:self.titleLabel];
    
    self.cardHolderTextField = [[BNCreditCardHolderTextField alloc] init];
    self.cardHolderTextField.placeholder = NSLocalizedString(@"Card Holder Name", @"Placeholder");
    // .* = .{0,} = match any char zero or more times
    self.cardHolderTextField.inputRegex = @".{0,}";
    self.cardHolderTextField.validRegex = @".{0,}";
    
    [self.cardHolderTextField applyAlphaNumericalStyle];
    [self.cardHolderTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardHolderTextField];
    
    
    self.cardNumberTextField = [[BNCreditCardNumberTextField alloc] init];
    self.cardNumberTextField.placeholder = NSLocalizedString(@"5555 5555 5555 5555", @"Placeholder");
    [self.cardNumberTextField applyStyle];
    [self.cardNumberTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardNumberTextField];
    
    self.cardExpiryTextField = [[BNCreditCardExpiryTextField alloc] init];
    self.cardExpiryTextField.placeholder = NSLocalizedString(@"MM/YY", @"Placeholder");
    [self.cardExpiryTextField applyStyle];
    [self.cardExpiryTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardExpiryTextField];
    
    self.cardCVCTextField = [[BNBaseTextField alloc] init];
    self.cardCVCTextField.placeholder = NSLocalizedString(@"000(0)", @"Placeholder");
    self.cardCVCTextField.inputRegex = @"^[0-9]{0,4}$";
    self.cardCVCTextField.validRegex = @"^[0-9]{3,4}$";
    [self.cardCVCTextField applyStyle];
    [self.cardCVCTextField addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.cardCVCTextField];
    
    
    
    self.saveCardLabel = [[UILabel alloc] init];
    self.saveCardLabel.text = NSLocalizedString(@"SAVE CARD", @"Save card");
    self.saveCardLabel.textColor = [UIColor BNTextColor];
    self.saveCardLabel.font = [UIFont systemFontOfSize:12.f weight:UIFontWeightMedium];
    [self.formScrollView addSubview:self.saveCardLabel];
    
    
    self.switchSaveCardButton = [[BNSwitchButton alloc] init];
    [self.switchSaveCardButton addTarget:self action:@selector(validateFields) forControlEvents:UIControlEventEditingChanged];
    [self.formScrollView addSubview:self.switchSaveCardButton];
    
    self.submitButton = [BNLoaderButton new];
    [self.submitButton setBackgroundColor:[UIColor BNPurpleColor]];
    [self.submitButton setTitle:NSLocalizedString(@"Pay", @"") forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitButton addTarget:self
                          action:@selector(submitSinglePaymentCardInformation:)
                forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.enabled = NO;
    self.submitButton.alpha = .5f;
    [self.formScrollView addSubview:self.submitButton];
}

- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*)message {
    
    NSString *closeButtonTitle = NSLocalizedString(@"OK", nil);
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message
                                                       delegate:nil
                                              cancelButtonTitle:closeButtonTitle
                                              otherButtonTitles:nil];
    [alertView show];
}

- (void)submitSinglePaymentCardInformation:(UIButton *)sender {
    BNCreditCard *creditCard = [BNCreditCard new];
    creditCard.holderName = [self.cardHolderTextField getCardHolderName];
    creditCard.cardNumber = [self.cardNumberTextField.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    creditCard.expMonth = [self.cardExpiryTextField getExpiryMonth];
    creditCard.expYear = [self.cardExpiryTextField getExpiryYear];
    creditCard.cvv = self.cardCVCTextField.text;
    
    BOOL isSaveCard = self.switchSaveCardButton.isOn? true: false;
    [self.paymentParams SetCreditCardJsonData:creditCard isTokenRequired:isSaveCard];
    [self.submitButton setLoading:YES];
    [[BNPaymentHandler sharedInstance] submitSinglePaymentCard :self.paymentParams
                                              requirePaymentValidation:self.isRequirePaymentAuthorization
                                              requireSaveCard:isSaveCard
                                              completion: ^(NSDictionary<NSString*, NSString*> * response,BNAuthorizedCreditCard *authorizedCreditCard, BNPaymentResult result,NSError *error){
        if(self.completionBlock && result) {
            self.completionBlock(response, authorizedCreditCard, result, error);
        }
        else {
            NSString *title = NSLocalizedString(@"Payment failed", nil);
            NSString *detail = [BNHTTPResponseSerializer extractErrorDetail:error];
            NSString *m = [NSString stringWithFormat:@"%@\nPlease try again", detail];
            NSString *message = NSLocalizedString(m, nil);
            [self showAlertViewWithTitle:title message:message];
        }
        [self.submitButton setLoading:NO];
    }];
}

#pragma mark - Handle keyboard events

- (void)onKeyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        CGSize kbSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [self animateKeyboardVisible:NO kbSize:kbSize duration:animationDuration];
    }
}

- (void)onKeyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = notification.userInfo;
    if (userInfo) {
        CGSize kbSize = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        CGFloat animationDuration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        [self animateKeyboardVisible:YES kbSize:kbSize duration:animationDuration];
    }
}

- (void)animateKeyboardVisible:(BOOL)visible kbSize:(CGSize)kbSize duration:(CGFloat)duration {
    
    CGFloat kbHeight = kbSize.height;
    CGFloat viewHeight = CGRectGetHeight(self.view.frame);
    CGFloat height = visible ? viewHeight-kbHeight + SinglePaymentButtonHeight : viewHeight;
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        int a = height-SinglePaymentButtonHeight;
        int b = CGRectGetMaxY(self.cardCVCTextField.frame)+SinglePaymentPadding;
        [self.submitButton setYoffset:MAX(a,b)];
        [self.formScrollView setHeight:height];
    } completion:^(BOOL finished) {
        [self.formScrollView setContentSize:CGSizeMake(CGRectGetWidth(self.view.frame), CGRectGetMaxY(self.submitButton.frame))];
    }];
}

- (void)validateFields {
    BOOL validCardNumber = [self.cardNumberTextField validCardNumber];
    BOOL validExpiry = [self.cardExpiryTextField validExpiryDate];
    
    BOOL validCVC = YES; // By default it is optional
    if ([self.cardCVCTextField.text length] != 0){
        validCVC = [self.cardCVCTextField validCVC];
    }
    
    // TODO Improve card holder validation
    
    // Now CVC is optional
    if(validCardNumber && validExpiry && validCVC) {
        self.submitButton.enabled = YES;
        self.submitButton.alpha = 1.f;
    }else {
        self.submitButton.enabled = NO;
        self.submitButton.alpha = 0.5f;
    }
}

@end