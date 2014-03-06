//
//  DPZEditPrinterViewController.m
//  Little Image Printer
//
//  Created by David Wilkinson on 03/03/2013.
//  Copyright (c) 2013 David Wilkinson. All rights reserved.
//

#import "DPZEditPrinterViewController.h"

#import "DPZPrinterManager.h"
#import "DPZPrinter.h"

#import "UIColor+DPZColors.h"
#import "DPZPrintCodeViewController.h"
#import "UIView+DPZFirstResponder.h"

@interface DPZEditPrinterViewController () <UITextFieldDelegate>

@property (nonatomic, strong) DPZPrinter *printer;

@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UITextField *code;

@property (nonatomic, weak) IBOutlet UIView *containerView;
@property (nonatomic, weak) IBOutlet UIButton *printerCodeButton;

@property (nonatomic, strong) UIBarButtonItem *saveButton;
@property (nonatomic, assign) BOOL keyboardIsShowing;

- (IBAction)textChanged:(id)sender;
- (IBAction)findPrinterCode:(id)sender;

@end

@implementation DPZEditPrinterViewController

- (id)initWithPrinter:(DPZPrinter *)printerOrNil
{
    if (self = [super initWithNibName:@"DPZEditPrinterViewController" bundle:nil])
    {
        _printer = printerOrNil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = self.saveButton;
    
    [self.printerCodeButton setTitleColor:[UIColor dpz_tintColor] forState:UIControlStateNormal];
    
    if (self.printer) {
        self.name.text = self.printer.name;
        self.code.text = self.printer.code;
        self.title = @"Edit Printer";
    } else {
        self.title = @"Add Printer";
    }
    
    [self refreshControls];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)refreshControls
{
    self.saveButton.enabled = self.name.text.length != 0 && self.code.text.length != 0;
}

- (void)textChanged:(id)sender
{
    [self refreshControls];
}

- (void)save
{
    DPZPrinterManager *pm = [DPZPrinterManager sharedPrinterManager];
    
    if (!self.printer) {
        self.printer = [pm createPrinter];
    }
    
    self.printer.name = self.name.text;
    self.printer.code = self.code.text;
    
    [pm saveContext];
    
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)findPrinterCode:(id)sender
{
    DPZPrintCodeViewController *vc = [[DPZPrintCodeViewController alloc] initWithNibName:@"DPZPrintCodeViewController" bundle:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.name) {
        [self.code becomeFirstResponder];
        return NO;
    }
    if (textField == self.code) {
        [self.code resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark Keyboard

// Called when the UIKeyboardWillShowNotification is sent.
- (void)keyboardWillShow:(NSNotification*)notification
{
    if (!self.keyboardIsShowing)
    {
        self.keyboardIsShowing = YES;
        
        NSDictionary* info = [notification userInfo];
        CGSize kbSize = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
        CGRect f = self.containerView.frame;
        f.origin.y = f.origin.y - kbSize.height;
        NSTimeInterval duration = [self keyboardAnimationDurationForNotification:notification];
        [UIView animateWithDuration:duration animations:^{
            self.containerView.frame = f;
        }];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillHide:(NSNotification*)notification
{
    self.keyboardIsShowing = NO;
    
    NSDictionary* info = [notification userInfo];
    CGSize kbSize = [info[UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    CGRect f = self.containerView.frame;
    f.origin.y = f.origin.y + kbSize.height;
    NSTimeInterval duration = [self keyboardAnimationDurationForNotification:notification];
    [UIView animateWithDuration:duration animations:^{
        self.containerView.frame = f;
    }];
}

- (NSTimeInterval)keyboardAnimationDurationForNotification:(NSNotification*)notification
{
    NSDictionary* info = [notification userInfo];
    NSValue* value = info[UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    return duration;
}

// Hide the keyboard when the user taps outside of the controls
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view dpz_findAndResignFirstResponder];
}

@end
