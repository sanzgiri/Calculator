//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 2/21/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void) pushOperand:(double)operand;
- (void) pushVarOperand:(NSString *)operand;
- (void) pushOperand:(double)operand;
- (double) removeTopItemFromProgramStack;
- (double) performOperation:(NSString *)operation;
- (void) clearStack;

@property (nonatomic, readonly) id program;

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (NSString *)valuesInputToProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariableValues:(NSDictionary *)testValues;
+ (BOOL) isZeroOperandOperation:(id)operation;
+ (BOOL) isSingleOperandOperation:(id)operation;
+ (BOOL) isDoubleOperandOperation:(id)operation;
+ (BOOL) isVariable:(id)operation;
@end
