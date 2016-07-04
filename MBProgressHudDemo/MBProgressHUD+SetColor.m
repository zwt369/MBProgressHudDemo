//
//  MBProgressHUD+SetColor.m
//  MBProgressHudDemo
//
//  Created by Tony Zhang on 16/7/4.
//  Copyright © 2016年 Tony Zhang. All rights reserved.
//

#import "MBProgressHUD+SetColor.h"

#define Color(R,G,B)  [UIColor colorWithRed:R/256.0 green:G/256.0 blue:B/256.0 alpha:1]

@implementation MBProgressHUD (SetColor)

-(void)changeDefaultColor{

    self.color = Color(234, 234, 234);
    self.activityIndicatorColor = Color(100, 100, 100);
    self.labelColor = [UIColor blackColor];
    self.detailsLabelColor = [UIColor blackColor];
}

@end
