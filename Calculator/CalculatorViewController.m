//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 2/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"
#import "GraphViewController.h"

@interface CalculatorViewController()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic) BOOL userHasEnteredDecimalPointInNumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize description = _description;
@synthesize display = _display;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize userHasEnteredDecimalPointInNumber = _userHasEnteredDecimalPointInNumber; 
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"program = %@", self.brain.program);
    if ([segue.identifier isEqualToString:@"Graph"]) {
       [segue.destinationViewController setCalculatorProgram:self.brain.program];
     }
}

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
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.userHasEnteredDecimalPointInNumber = NO;
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
    
#if 0
    NSString *sdt = [[self.brain class] descriptionOfProgram:self.brain.program];
    if ([self.description.text length] != 0) {
        self.description.text = [sdt stringByAppendingFormat:@", %@", self.description.text];
    }
    else {
        self.description.text = sdt; 
    }
#endif
    
    self.description.text = [[self.brain class] descriptionOfProgram:self.brain.program];
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
    self.description.text = @"";
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
            double result = [[self.brain class] runProgram:self.brain.program];
            self.display.text = [NSString stringWithFormat:@"%g", result];
            self.userIsInTheMiddleOfEnteringANumber = NO;
        }
    } else {
        double result = [self.brain removeTopItemFromProgramStack];
        self.display.text = [NSString stringWithFormat:@"%g", result];
    }
    
}

- (IBAction)testPressed:(UIButton *)sender 
{
    self.description.text = [[self.brain class] descriptionOfProgram:self.brain.program];
    for (int i = 0; i < 20; i++)
    {
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys: 
                                   [NSNumber numberWithInt:i], @"x",
                                   nil];
        double result = [[self.brain class] runProgram:self.brain.program usingVariableValues:self.testVariableValues];
        NSLog(@"x = %d, y = %g", i, result);
    }
}

- (void)viewDidUnload {
    [self setDescription:nil];
    [super viewDidUnload];
}

@end
