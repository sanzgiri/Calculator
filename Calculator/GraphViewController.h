//
//  GraphViewController.h
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SplitViewBarButtonItemPresenter.h"

@interface GraphViewController : UIViewController <SplitViewBarButtonItemPresenter>
@property (nonatomic, strong) id calculatorProgram;
@property (nonatomic) NSArray *graphDataValues;
- (void) setCalculatorProgram:(id)program;
@end
