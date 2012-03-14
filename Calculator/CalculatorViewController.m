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
@property (nonatomic) BOOL userIsEnteringAnExpression;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize history = _history;
@synthesize valuelist = _valuelist;
@synthesize description = _description;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimalPointInNumber = _userHasEnteredDecimalPointInNumber; 
@synthesize userIsEnteringAnExpression = _userIsEnteringAnExpression;

@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

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
    [self.brain pushVarOperand:self.display.text];
    self.history.text = [self.history.text stringByAppendingString:[NSString stringWithFormat:@" %@", self.display.text]]; 
    self.userIsEnteringAnExpression = YES;
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
    self.userHasEnteredDecimalPointInNumber = NO;
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
//            self.display.text = @"0";
            double result = [[self.brain class] runProgram:self.brain.program];
            self.display.text = [NSString stringWithFormat:@"%g", result];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        double result = [self.brain removeTopItemFromProgramStack];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    
}

- (IBAction)test1Pressed:(UIButton *)sender 
{
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                       [NSNumber numberWithInt:2], @"x",
                       [NSNumber numberWithInt:3], @"a",
                       [NSNumber numberWithInt:-1], @"b",
                       nil];
    self.valuelist.text =   [[self.brain class] valuesInputToProgram:self.brain.program usingVariableValues: self.testVariableValues];
    self.description.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];    
}

- (IBAction)test2Pressed:(UIButton *)sender
{  
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                        [NSNumber numberWithInt:-1], @"x",
                        [NSNumber numberWithInt:0], @"a",
                        [NSNumber numberWithInt:1], @"b",
                        nil];
    self.valuelist.text = @"x = -1, a = 0, b = 1";    
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)test3Pressed:(UIButton *)sender
{
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                       [NSNumber numberWithInt:1], @"x",
                       [NSNumber numberWithInt:2], @"a",
                       [NSNumber numberWithInt:2], @"b",
                       nil];
    self.valuelist.text = @"x = 1, a = 2, b = 2";    
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)test4Pressed:(UIButton *)sender
{    
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                        [NSNumber numberWithInt:3], @"x",
                        [NSNumber numberWithInt:4], @"a",
                        [NSNumber numberWithInt:-5], @"b",
                        nil];
    self.valuelist.text = @"x = 3, a = 4, b = -5";    
    double result = [[self.brain class] runProgram:self.brain.program usingVariableValues: self.testVariableValues];  
    self.display.text = [NSString stringWithFormat:@"%g", result];
}



- (void)viewDidUnload {
    [self setHistory:nil];
    [self setValuelist:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}

@end
