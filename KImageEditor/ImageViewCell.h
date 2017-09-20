//
//  ImageViewCell.h
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UICollectionViewCell

/**
 *  Cell Image View reference
 */
@property (weak) IBOutlet UIImageView* feedImage;

/**
 *  Cell Image View reference
 */
@property (weak) IBOutlet UIActivityIndicatorView* indicatorView;

@end
