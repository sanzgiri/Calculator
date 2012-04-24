//
//  CalculatorProgramsTableViewController.h
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 4/22/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorProgramsTableViewController;
@protocol CalculatorProgramTableViewControllerDelegate 
@optional
- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender
                                               choseProgram:(id)program;
@end


@interface CalculatorProgramsTableViewController : UITableViewController

@property (nonatomic, strong) NSArray *programs; // of CalculatorBrain programs
@property (nonatomic, weak) id <CalculatorProgramTableViewControllerDelegate> delegate;

@end
