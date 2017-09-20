//
//  ImageModel.h
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageModel : NSObject

/**
 *  Reference to message quote image
 */
@property (nonatomic, strong)    NSString     *imageURL;

/**
 *  Reference to message quote image
 */
@property (nonatomic, strong)    NSString     *imageId;


@property (nonatomic, assign)    BOOL     isSelected;


/**
 *  Method to generate array of feeds
 *
 *  @param arrayImages array of json data from api
 *
 *  @return Array of feeds containing Modal class objects
 */

+ (NSArray*)initWithArray:(NSArray *)arrayImages;

@end
