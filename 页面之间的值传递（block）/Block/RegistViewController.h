//
//  RegistViewController.h
//  Block
//
//  Created by tens04 on 16/8/23.
//  Copyright © 2016年 fuxinto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UserInfoBlock)(NSString *userName, NSString *password);

@interface RegistViewController : UIViewController

@property (nonatomic, copy) UserInfoBlock userBlock;

@end
