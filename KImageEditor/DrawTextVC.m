//
//  DrawTextVC.m
//  KImageEditor
//
//  Created by Krishana on 9/19/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "DrawTextVC.h"
#import "ImageVC.h"
#import "IQLabelView.h"


@interface DrawTextVC () <UITextViewDelegate, UIGestureRecognizerDelegate, IQLabelViewDelegate> {
    float firstX;
    float firstY;
    UILabel *labelText;
    NSMutableSet *_activeRecognizers;
    IQLabelView *currentlyEditingLabel;
    NSMutableArray *labels;
}

@property (nonatomic, strong) NSArray *colors;

@end

@implementation DrawTextVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageViewSelectedImage.image = self.selectedImage;
    
    self.colors = [NSArray arrayWithObjects:[UIColor whiteColor], [UIColor redColor], [UIColor blueColor], nil];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchOutside:)]];
    [self addLabel];
}

- (void)addLabel {
    [currentlyEditingLabel hideEditingHandles];
    CGRect labelFrame = CGRectMake(CGRectGetMidX(self.imageViewSelectedImage.frame) - arc4random() % 20,
                                   20,
                                   60, 50);
    
    IQLabelView *labelView = [[IQLabelView alloc] initWithFrame:labelFrame];
    [labelView setDelegate:self];
    [labelView setShowsContentShadow:NO];
    [labelView setEnableMoveRestriction:YES];
    [labelView setFontName:@"Baskerville-BoldItalic"];
    [labelView setFontSize:21.0];
    [labelView setTextColor:[UIColor blackColor]];
    
    [self.imageViewSelectedImage addSubview:labelView];
    [self.imageViewSelectedImage setUserInteractionEnabled:YES];
    
    if (arc4random() % 2 == 0) {
        [labelView setAttributedPlaceholder:[[NSAttributedString alloc]
                                             initWithString:@"Placeholder"
                                             attributes:@{ NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:0.75] }]];
    }
    currentlyEditingLabel = labelView;
    [labels addObject:labelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCaptureImageClicked:(id)sender {
    [currentlyEditingLabel hideEditingHandles];
    UIImage *image = [self visibleImage];
    [self performSegueWithIdentifier:@"NAVIGATE_TO_IMAGE" sender:image];
}


- (void)changeColor {
    [currentlyEditingLabel setTextColor:[self.colors objectAtIndex:arc4random() % 3]];
}

- (UIImage *)visibleImage {
    UIGraphicsBeginImageContextWithOptions(self.imageViewSelectedImage.bounds.size, YES, [UIScreen mainScreen].scale);
    CGContextTranslateCTM(UIGraphicsGetCurrentContext(), CGRectGetMinX(self.imageViewSelectedImage.frame), -CGRectGetMinY(self.imageViewSelectedImage.frame));
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *visibleViewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return visibleViewImage;
}

#pragma mark - Gesture

- (void)touchOutside:(UITapGestureRecognizer *)touchGesture {
    [currentlyEditingLabel hideEditingHandles];
}

#pragma mark - IQLabelDelegate

- (void)labelViewDidClose:(IQLabelView *)label {
    // some actions after delete label
    [labels removeObject:label];
}

- (void)labelViewDidBeginEditing:(IQLabelView *)label {
    // move or rotate begin
}

- (void)labelViewDidShowEditingHandles:(IQLabelView *)label {
    // showing border and control buttons
    currentlyEditingLabel = label;
}

- (void)labelViewDidHideEditingHandles:(IQLabelView *)label {
    // hiding border and control buttons
    currentlyEditingLabel = nil;
}

- (void)labelViewDidStartEditing:(IQLabelView *)label {
    // tap in text field and keyboard showing
    currentlyEditingLabel = label;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageVC *imgVC = [segue destinationViewController];
    imgVC.image = (UIImage *) sender;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
