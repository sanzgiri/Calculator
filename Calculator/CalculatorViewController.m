//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDecimalPointInNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimalPointInNumber = _userHasEnteredDecimalPointInNumber; 
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender
{
    NSString *digit = [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDecimalPointInNumber = NO;
    if (!self.userIsInTheMiddleOfEnteringANumber)
    {
        self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@" %@", self.display.text]]; 
    }
}


- (IBAction)operationPressed:(UIButton *)sender 
{
    NSString *operation = [sender currentTitle];
    
    if (self.userIsInTheMiddleOfEnteringANumber) 
    {
        if ([operation isEqualToString:@"+/-"])
        {
            [self enterPressed];
            self.userIsInTheMiddleOfEnteringANumber = YES;
        } else {
            [self enterPressed];            
        }
    }
  
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    self.history.text = [self.history.text stringByReplacingOccurrencesOfString:@"= " withString:@""];
    self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@" %@ = ", operation]];
}


- (IBAction)dotPressed:(UIButton *)sender 
{
    NSString *dot = [sender currentTitle];
    if (self.userHasEnteredDecimalPointInNumber == NO)
    {
       if (self.userIsInTheMiddleOfEnteringANumber == YES) 
       {
           self.display.text = [self.display.text stringByAppendingString:dot];
           self.userHasEnteredDecimalPointInNumber = YES;
       } else {
           dot = [NSString stringWithFormat:@"0%@", dot];
           self.display.text = dot;
           self.userHasEnteredDecimalPointInNumber = YES;           
           self.userIsInTheMiddleOfEnteringANumber = YES;
       }
    }
}

- (IBAction)clearPressed:(UIButton *)sender {
    [self.brain clearStack];
    self.display.text = @"0";
    self.history.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)deletePressed:(UIButton *)sender 
{
    if (self.userIsInTheMiddleOfEnteringANumber)
    {
        int len = [self.display.text length];
        if (len > 1)
        {
            self.display.text = [self.display.text substringToIndex:len-1];
        } else {
            self.display.text = @"0";
        }
        
    }
    
}

- (void)viewDidUnload {
    [self setHistory:nil];
    [super viewDidUnload];
}
@end
