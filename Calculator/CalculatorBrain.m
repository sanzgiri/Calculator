//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program
{
    return [self.programStack copy];
}

+ (NSSet *)variablesUsedInProgram:(id)program
{
    NSSet* operandSet = [NSSet setWithObjects:@"+",@"*",@"-",@"/",@"sin",@"cos",@"log",@"+/-",@"π",@"e", nil];
    NSSet *programSet = [NSSet setWithArray:program];
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    NSEnumerator *enumerator = [programSet objectEnumerator];
    id value;
    
    while ((value = [enumerator nextObject])) 
    {
        if (![operandSet containsObject:value])
        {
            [variableSet addObject:value];
        }
    }
    NSLog(@"variableSet = %@", variableSet);
    return variableSet;
}

+ (NSString *)descriptionOfProgram:(id)program
{
    [[self class] variablesUsedInProgram:program];
    return @"This is a test";
}

- (void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)pushVarOperand:(NSString *)operand
{
    [self.programStack addObject:operand];
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
    NSLog(@"Popping %@", topOfStack);
    if (topOfStack) [stack removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"*"]) {
            result = [self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;        
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"log"]) {
            result = log([self popOperandOffProgramStack:stack]);    
        } else if ([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffProgramStack:stack] * -1;
        } else if ([operation isEqualToString:@"π"]) {
//            NSNumber *pi = [NSNumber numberWithDouble:M_PI];
//            [self.programStack addObject:pi];
            result = M_PI;
        } else if ([operation isEqualToString:@"e"]) {
//            NSNumber *e = [NSNumber numberWithDouble:M_E];
//            [self.programStack addObject:e];
            result = M_E;
        } 
        
    }
    return result;
}

- (void)clearStack
{
    [self.programStack removeAllObjects];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSLog(@"count = %d", [stack count]);
    
    for (int i = 0; i < [stack count]; i++) 
    {
        id object = [stack objectAtIndex:i];
        NSLog(@"%@", object);
        if ([object isKindOfClass:[NSString class]])
        {
            if ([object isEqualToString:@"x"])
            {
                NSNumber* value = [variableValues objectForKey:@"x"];  
                NSLog(@"replace x with %@", value);
                [stack replaceObjectAtIndex:i withObject:value];
            }
            if ([object isEqualToString:@"a"])
            {
                NSNumber* value = [variableValues objectForKey:@"a"];  
                NSLog(@"replace a with %@", value);
                [stack replaceObjectAtIndex:i withObject:value];
            }
            if ([object isEqualToString:@"b"])
            {
                NSNumber* value = [variableValues objectForKey:@"b"];  
                NSLog(@"replace b with %@", value);         
                [stack replaceObjectAtIndex:i withObject:value];
            }    
        }
    }
  //  NSString *varList = @"x = %s, a = %s, b = %s",
  //      [variableValues objectForKey:@"x"], 
  //      [variableValues objectForKey:@"a"], 
  //      [variableValues objectForKey:@"b"]);
    
  //  NSLog(@"%@", [[variableValues objectForKey:@"x"] stringValue]);   
    
  //  NSLog(@"Received Values");
    //return 1;
   return [self popOperandOffProgramStack:stack];
}


@end
