//
//  Config.h
//  KconfigScrollable
//
//  Created by Krishna on 13/04/16.
//  Copyright © 2016 KT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject


//Collection View Values
#define NUMBER_OF_ITEMS_PER_ROW 4

#define COLLECTION_CELL_LEFT_PADDING 10.0f
#define COLLECTION_CELL_RIGHT_PADDING 10.0f
#define COLLECTION_CELL_INTER_ITEMS_PADDING 5.0f
#define COLLECTION_CELL_MIN_LINE_SPACING 5.0f



#define APPDELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

//device checking macros
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)
#define IS_HEIGHT_GTE_780 ([[UIScreen mainScreen ] bounds].size.height >= 780.0f)

#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@end
