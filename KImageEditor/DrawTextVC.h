//
//  DrawTextVC.h
//  KImageEditor
//
//  Created by Krishana on 9/19/17.
//  Copyright © 2017 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawTextVC : UIViewController

@property (strong, nonatomic) UIImage *selectedImage;

@property (weak, nonatomic) IBOutlet UIImageView *imageViewSelectedImage;

@property (weak, nonatomic) IBOutlet UITextView *textFieldText;


@end
