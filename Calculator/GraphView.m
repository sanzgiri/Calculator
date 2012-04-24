//
//  GraphView.m
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

@synthesize dataSource = _dataSource;
@synthesize scale = _scale;

#define DEFAULT_SCALE 0.90

- (CGFloat)scale
{
    if (!_scale) {
        return DEFAULT_SCALE; // don't allow zero scale
    } else {
        return _scale;
    }
}

- (void)setScale:(CGFloat)scale
{
    if (scale != _scale) {
        _scale = scale;
        [self setNeedsDisplay]; // any time our scale changes, call for redraw
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.scale *= gesture.scale; // adjust our scale
        gesture.scale = 1;           // reset gestures scale to 1 (so future changes are incremental, not cumulative)
    }
}

- (void)setup
{
    self.contentMode = UIViewContentModeRedraw; // if our bounds changes, redraw ourselves
}

- (void)awakeFromNib
{
    [self setup]; // get initialized when we come out of a storyboard
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup]; // get initialized if someone uses alloc/initWithFrame: to create us
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    UIGraphicsPushContext(context);  
        
    CGPoint midPoint; // center of our bounds in our coordinate system
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGContextSetLineWidth(context, 1.0);
    [[UIColor blueColor] setStroke];
    
//    AxesDrawer *myAxes = [[AxesDrawer alloc] init];
//    [[myAxes class] drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale]; 
        
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale];  
    
    [[UIColor redColor] setStroke];
    for (int i = 0; i < 4000; i+=100)
    {
        CGFloat x = self.bounds.origin.x + 0.1*i;
        double yval = [self.dataSource graphDataForGraphView:self forX:(double)x];
        NSLog(@"xval = %g, yval = %g", x, yval);
        CGFloat y = (CGFloat) yval;
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, self.bounds.origin.x, self.bounds.origin.y);
        CGContextAddLineToPoint(context, x, y);
        CGContextStrokePath(context);        
    }

    
    UIGraphicsPopContext();
}

@end
