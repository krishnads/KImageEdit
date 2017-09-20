//
//  ImageModel.m
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ImageModel.h"

@implementation ImageModel
@synthesize imageURL, imageId, isSelected;

- (id)init {
    
    self=[super init];
    
    if (self) {
        imageId = imageURL = @"";
        isSelected = NO;
    }
    
    return self;
}


+ (NSArray*)initWithArray:(NSArray *) arrayImages {
    NSMutableArray *newArray = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < [arrayImages count]; i++)
    {
        NSDictionary *dic = [arrayImages objectAtIndex:i];
        
        ImageModel *model=[[ImageModel alloc] init];
        
        if ([dic objectForKey:@"imageURL"] == nil)
            model.imageURL = @"";
        else
            model.imageURL = [dic objectForKey:@"imageURL"];
        
        
        if ([dic objectForKey:@"id"]==nil)
            model.imageId = @"";
        else
            model.imageId= [dic objectForKey:@"id"];
        
        [newArray addObject:model];
    }
    // NSLog(@" model search result %@",newArray);
    return  newArray;
}



@end
