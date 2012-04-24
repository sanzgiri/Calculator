//
//  GraphViewController.m
//  Calculator
//
//  Created by Ashutosh Sanzgiri on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GraphViewController.h"
#import "GraphView.h"
#import "CalculatorBrain.h"
#import "CalculatorProgramsTableViewController.h"

//@interface GraphViewController () <CalculatorProgramTableViewControllerDelegate> // <GraphViewDataSource>
@interface GraphViewController () <GraphViewDataSource>

@property (nonatomic, weak) IBOutlet GraphView *graphView;
@property (nonatomic, weak) IBOutlet UIToolbar *toolbar;        // to put splitViewBarButtonitem in
@end

@implementation GraphViewController

#define FAVORITES_KEY @"GraphViewController.Favorites"
@synthesize graphDataValues = _graphDataValues;
@synthesize graphView = _graphView;
@synthesize splitViewBarButtonItem = _splitViewBarButtonItem;   // implementation of SplitViewBarButtonItemPresenter protocol
@synthesize toolbar = _toolbar;                  
@synthesize calculatorProgram = _calculatorProgram;

- (IBAction)addToFavorites:(id)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *favorites = [[defaults objectForKey:FAVORITES_KEY] mutableCopy];
    if (!favorites) favorites = [NSMutableArray array];
    [favorites addObject:self.calculatorProgram];
    [defaults setObject:favorites forKey:FAVORITES_KEY];
    [defaults synchronize];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Favorite Graphs"]) {
        NSArray *programs = [[NSUserDefaults standardUserDefaults] objectForKey:FAVORITES_KEY];
        [segue.destinationViewController setPrograms:programs];
        [segue.destinationViewController setDelegate:self];
    }
}

- (void)calculatorProgramsTableViewController:(CalculatorProgramsTableViewController *)sender choseProgram:(id)program
{ 
    self.calculatorProgram = program;
}
    
#if 0
- (void)handleSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
    if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
    if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
    self.toolbar.items = toolbarItems;
    _splitViewBarButtonItem = splitViewBarButtonItem;
}
#endif

- (void)setSplitViewBarButtonItem:(UIBarButtonItem *)splitViewBarButtonItem
{
    if (splitViewBarButtonItem != _splitViewBarButtonItem) {
        NSMutableArray *toolbarItems = [self.toolbar.items mutableCopy];
        if (_splitViewBarButtonItem) [toolbarItems removeObject:_splitViewBarButtonItem];
        if (splitViewBarButtonItem) [toolbarItems insertObject:splitViewBarButtonItem atIndex:0];
        self.toolbar.items = toolbarItems;
        _splitViewBarButtonItem = splitViewBarButtonItem;
    }
}

- (void)setGraphDataValues:(NSArray *)graphDataValues
{
    _graphDataValues = graphDataValues;
    [self.graphView setNeedsDisplay]; // any time our Model changes, redraw our View
}

- (void)setCalculatorProgram:(id)calculatorProgram
{
    _calculatorProgram = calculatorProgram;
    [self.graphView setNeedsDisplay];
}

- (void)setGraphView:(GraphView *)graphView
{
    _graphView = graphView;
    // enable pinch gestures in the FaceView using its pinch: handler
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    // recognize a pan gesture and modify our Model
  //  [self.graphView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)]];
    self.graphView.dataSource = self;
}

#if 0
- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        CGPoint translation = [gesture translationInView:self.graphView];
 //       self.happiness -= translation.y / 2; // will update graphView via setXXX:
        [gesture setTranslation:CGPointZero inView:self.graphView];
    }
}
#endif

- (double)graphDataForGraphView:(GraphView *)sender forX:(double)xval
{
    NSLog(@"xval = %g", xval);
    NSLog(@"program = %@", _calculatorProgram);
    NSDictionary *xvalDict = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithDouble:xval], @"x", nil];
    double yval = [CalculatorBrain runProgram:self.calculatorProgram usingVariableValues:xvalDict]; 
    return yval;
}

#if 0
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}
#endif

@end
