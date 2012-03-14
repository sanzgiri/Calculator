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
@property (nonatomic, strong) NSString *descString;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;
@synthesize descString = _descString;

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
    NSSet* operandSet = [NSSet setWithObjects:@"+",@"*",@"-",@"/",@"sqrt",@"sin",@"cos",@"log",@"+/-",@"π",@"e", nil];
    NSSet *programSet = [NSSet setWithArray:program];
    NSMutableSet *variableSet = [[NSMutableSet alloc] init];
    NSEnumerator *enumerator = [programSet objectEnumerator];
    id value;
    
    while (value = [enumerator nextObject]) 
    {
        if (([value isKindOfClass:[NSString class]]) && (![operandSet containsObject:value]))
        {
            [variableSet addObject:value];
        }
    }
    if ([variableSet count] == 0) variableSet = nil;
//    NSLog(@"variableSet = %@", variableSet);
    return variableSet;
}


+ (BOOL) isZeroOperandOperation:(id)operation
{
    NSSet* zeroOperandSet = [NSSet setWithObjects:@"π",@"e",nil];  
    if ([zeroOperandSet containsObject:operation])
        return YES;
    return NO;
}

+ (BOOL) isSingleOperandOperation:(id)operation
{
    NSSet* singleOperandSet = [NSSet setWithObjects:@"sqrt",@"sin",@"cos",@"log",@"+/-",nil];  
    if ([singleOperandSet containsObject:operation])
        return YES;
    return NO;
}

+ (BOOL) isDoubleOperandOperation:(id)operation
{
    NSSet* doubleOperandSet = [NSSet setWithObjects:@"+",@"*",@"-",@"/",nil];  
    if ([doubleOperandSet containsObject:operation])
        return YES;
    return NO;
}

+ (BOOL) isVariable:(id)operation
{
    NSSet* operandSet = [NSSet setWithObjects:@"+",@"*",@"-",@"/",@"sqrt",@"sin",@"cos",@"log",@"+/-",@"π",@"e", nil];      
    if (![operandSet containsObject:operation])
        return YES;
    return NO;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack
{
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    NSString *topString;
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        topString = [topString stringByAppendingString:[topOfStack stringValue]];
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
//        NSString *topString = [topOfStack stringValue];
        if ([self isZeroOperandOperation:topOfStack])
        {
            topString = [topString stringByAppendingString:[topOfStack stringValue]];
        } else if ([self isSingleOperandOperation:topOfStack])
        {
                       
        } else if ([self isDoubleOperandOperation:topOfStack])
        {    
            
        } else if ([self isVariable:topOfStack])
        {
            topString = [topString stringByAppendingString:[topOfStack stringValue]];
        }
    }
    NSLog(@"topstring = %@", topString);
    return topString;
}

+ (NSString *)descriptionOfProgram:(id)program
{    
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
            stack = [program mutableCopy];
    }   
    return [self descriptionOfTopOfStack:stack];    
//    return @"This is a test";
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

- (double)removeTopItemFromProgramStack
{
    id topOfStack = [self.programStack lastObject];
    if (topOfStack) {
        [self.programStack removeLastObject];
        NSLog(@"removed %@ from stack", topOfStack);
        if ([topOfStack isKindOfClass:[NSNumber class]])
        {
            double result = [topOfStack doubleValue];
            return result;
        }
    } else {
        return 0;
    }
    return 0;
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result = 0;
    
    id topOfStack = [stack lastObject];
//    NSLog(@"Popping %@", topOfStack);
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
    
    NSSet *varsUsedSet = [self variablesUsedInProgram:stack];
    NSMutableArray *varsUsedArray = [NSMutableArray arrayWithArray:[varsUsedSet allObjects]];
    
    for (int i = 0; i < [varsUsedArray count]; i++) 
    {
        id var = [varsUsedArray objectAtIndex:i];
        NSNumber* varValue = [variableValues objectForKey:var];  
        if (varValue == nil) varValue = [NSNumber numberWithDouble:0];
        NSLog(@"replace %@ with %@", var, varValue);
        [stack replaceObjectAtIndex:i withObject:varValue];        
                
    }
    
    return [self popOperandOffProgramStack:stack];
}

+ (NSString *) valuesInputToProgram:(id)program usingVariableValues:(NSDictionary *)variableValues
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    NSSet *varsUsedSet = [self variablesUsedInProgram:stack];
    NSMutableArray *varsUsedArray = [NSMutableArray arrayWithArray:[varsUsedSet allObjects]];
    NSString *inputVarsString = [[NSString alloc] init];
    
    for (int i = 0; i < [varsUsedArray count]; i++) 
    {
        id var = [varsUsedArray objectAtIndex:i];
        NSNumber* varValue = [variableValues objectForKey:var];  
        if (varValue == nil) varValue = [NSNumber numberWithDouble:0];
        inputVarsString = [inputVarsString stringByAppendingString:[NSString stringWithFormat:@"%@ = %@ ", var, varValue]];
    }
    return inputVarsString;
}

@end
