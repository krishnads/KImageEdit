//
//  DrawImageVC.m
//  KImageEditor
//
//  Created by Krishana on 9/19/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "DrawImageVC.h"
#import "ImageVC.h"

@interface DrawImageVC () {
    CGPoint lastPoint;
    CGFloat opacity;
    CGFloat brush;
    CGFloat red, green, blue;
    UIImage *previousImage;
    UIImage *rawImage;
}

@property (weak, nonatomic) IBOutlet UIImageView *tempImage;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (nonatomic, strong) NSMutableArray *stack;
@property (nonatomic, strong) NSMutableArray *contextArray;

@property (nonatomic, strong) NSMutableArray *pointsArray;
@property (nonatomic, strong) UIColor *selectedColor;

@end

@implementation DrawImageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    brush = 4;
    opacity = 1.0;
    red = 0.5;
    green = blue =  0.4;
    _stack = [NSMutableArray array];
    _contextArray = [NSMutableArray array];
    rawImage = self.selectedImage;
    previousImage = self.selectedImage;
    self.selectedColor = [UIColor redColor];
    self.tempImage.image = self.selectedImage;
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Image Draw";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)btnClicked:(id)sender {
    if (self.contextArray.count == 0) {
        return;
    }
    
    if ([self.undoManager canUndo]) {
        [self.undoManager undo];
    }
}

- (IBAction)redoBtnClicked:(id)sender {

    if ([self.undoManager canRedo]) {
        [self.undoManager redo];
    }
}

- (IBAction)resetAction:(id)sender {
    [self setImage:previousImage fromImage:self.tempImage.image];
}

- (IBAction)saveAction:(id)sender {
    [self performSegueWithIdentifier:@"NAVIGATE_TO_IMAGE" sender:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.view];
    _pointsArray = [NSMutableArray array];
    [_pointsArray addObject:NSStringFromCGPoint(lastPoint)];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.tempImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, brush);
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, lastPoint.x, lastPoint.y);
    CGContextStrokePath(context);
    self.tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [self.tempImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(context, currentPoint.x, currentPoint.y);
    
    //Now set our brush size and opacity and brush stroke color:
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineWidth(context, brush );
    CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), self.selectedColor.CGColor);
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    CGContextStrokePath(context);
    
    self.tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;
    [self.pointsArray addObject:NSStringFromCGPoint(lastPoint)];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //handle single tap, make _pointsArray has two identical points, draw a line between them
    if (_pointsArray.count == 1) {
        [_pointsArray addObject:NSStringFromCGPoint(lastPoint)];
    }
    
    [self.stack addObject:_pointsArray];
    NSLog(@"color -> %@ \nwidth->%f", self.selectedColor.description, brush);
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.selectedColor forKey:@"color"];
    [dic setObject:[NSNumber numberWithFloat:brush] forKey:@"width"];
    [self.contextArray addObject:dic];
    
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(popDrawing)
                                      object: nil];
    
}

- (void)pushDrawing:(NSDictionary *)allDic {
    
    [self.stack addObject: (NSArray *)[allDic objectForKey:@"points"]];
    [self.contextArray addObject:(NSDictionary *)[allDic objectForKey:@"context"]];
    
    [self redrawLastLine:(NSArray *)[allDic objectForKey:@"points"]];
    
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(popDrawing)
                                      object: nil];
}

- (void)popDrawing {
    NSArray *array = [self.stack lastObject];
    [self.stack removeLastObject];
    NSDictionary *contextDic = [_contextArray lastObject];
    
    NSDictionary *allDic = @{
                             @"points" : array,
                             @"context" : contextDic
                             };
    [self.contextArray removeLastObject];
    [self redrawLinePathsInStack];
    [self.undoManager registerUndoWithTarget: self
                                    selector: @selector(pushDrawing:)
                                      object: allDic];
}

- (void)redrawLastLine:(NSArray*)array {
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.tempImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    
    for(int i = 0; i < array.count - 1; i++) {
        NSDictionary *contextDic = [self.contextArray lastObject];
        float lineWidth = [[contextDic objectForKey:@"width"] floatValue];
        UIColor *lineColor = (UIColor *)[contextDic objectForKey:@"color"] ;
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), lineColor.CGColor);
        
        NSString *pointStr = [array objectAtIndex:i];
        NSString *pointStr1 = [array objectAtIndex:i+1];
        
        CGPoint point = CGPointFromString(pointStr);
        CGPoint point1 = CGPointFromString(pointStr1);
        
        CGContextMoveToPoint(context, point.x, point.y);
        CGContextAddLineToPoint(context, point1.x, point1.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
    }
    
    
    self.tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempImage setAlpha:opacity];
    UIGraphicsEndImageContext();
}

- (void)redrawLinePathsInStack {
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [rawImage drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(context, kCGLineCapRound);
    
    CGContextSetBlendMode(context,kCGBlendModeNormal);
    
    int count = 0;
    for (NSArray *array in self.stack) {
        NSDictionary *contextDic = [self.contextArray objectAtIndex:count];
        float lineWidth = [[contextDic objectForKey:@"width"] floatValue];
        UIColor *lineColor = (UIColor *)[contextDic objectForKey:@"color"] ;
        CGContextSetLineWidth(context, lineWidth);
        CGContextSetStrokeColorWithColor(UIGraphicsGetCurrentContext(), lineColor.CGColor);
        
        for(int i = 0; i < array.count - 1; i++) {
            NSString *pointStr = [array objectAtIndex:i];
            NSString *pointStr1 = [array objectAtIndex:i+1];
            
            CGPoint point = CGPointFromString(pointStr);
            CGPoint point1 = CGPointFromString(pointStr1);
            
            CGContextMoveToPoint(context, point.x, point.y);
            CGContextAddLineToPoint(context, point1.x, point1.y);
            CGContextStrokePath(UIGraphicsGetCurrentContext());
        }
        count ++;
    }
    
    self.tempImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempImage setAlpha:opacity];
    UIGraphicsEndImageContext();
}

- (void)setImage:(UIImage*)currentImage fromImage:(UIImage*)preImage {
    // Prepare undo-redo
    [[self.undoManager prepareWithInvocationTarget:self] setImage:preImage fromImage:currentImage];
    //self.mainImage.image = currentImage;
    self.tempImage.image = currentImage;
    //prev = currentImage;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageVC *imgVC = [segue destinationViewController];
    imgVC.image = self.tempImage.image;
}

- (void)viewDidDisappear:(BOOL)animated {
    
}


@end
