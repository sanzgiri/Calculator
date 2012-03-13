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
@property (nonatomic, strong) NSDictionary *testValues;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize valuelist = _valuelist;
@synthesize description = _description;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimalPointInNumber = _userHasEnteredDecimalPointInNumber; 
@synthesize brain = _brain;
@synthesize testValues = _testValues;

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

- (IBAction)variablePressed:(id)sender 
{
    NSString *var = [sender currentTitle];
    self.display.text = var;    
    [self.brain pushNumOperand:[self.display.text doubleValue]];
    self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@" %@", self.display.text]]; 
}

- (IBAction)enterPressed {
    [self.brain pushNumOperand:[self.display.text doubleValue]];
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

- (IBAction)test1Pressed:(UIButton *)sender 
{
    self.testValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                       [NSNumber numberWithInt:2], @"x",
                       [NSNumber numberWithInt:0], @"a",
                       [NSNumber numberWithInt:-1], @"b",
                       nil];
    self.valuelist.text = @"x = 2, a = 0, b = -1";    
    [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testValues];
    
}

- (IBAction)test2Pressed:(UIButton *)sender
{  
    self.testValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                        [NSNumber numberWithInt:-1], @"x",
                        [NSNumber numberWithInt:0], @"a",
                        [NSNumber numberWithInt:1], @"b",
                        nil];
    self.valuelist.text = @"x = -1, a = 0, b = 1";    
    [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testValues];    
}

- (IBAction)test3Pressed:(UIButton *)sender
{
    self.testValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                       [NSNumber numberWithInt:1], @"x",
                       [NSNumber numberWithInt:2], @"a",
                       [NSNumber numberWithInt:2], @"b",
                       nil];
    self.valuelist.text = @"x = 1, a = 2, b = 2";    
    [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testValues];
}

- (IBAction)test4Pressed:(UIButton *)sender
{    
    self.testValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                        [NSNumber numberWithInt:3], @"x",
                        [NSNumber numberWithInt:4], @"a",
                        [NSNumber numberWithInt:-5], @"b",
                        nil];
    self.valuelist.text = @"x = 3, a = 4, b = -5";    
    [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testValues];    
}



- (void)viewDidUnload {
    [self setHistory:nil];
    [self setValuelist:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}

@end
