//
//  GraphView.h
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxesDrawer.h"

@class GraphView;

@protocol GraphViewDataSource
- (double)graphDataForGraphView:(GraphView *)sender forX:(double)xval;
@end

@interface GraphView : UIView

@property (nonatomic) CGFloat scale;

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@end
