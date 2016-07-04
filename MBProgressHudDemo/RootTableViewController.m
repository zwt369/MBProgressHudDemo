//
//  RootTableViewController.m
//  MBProgressHudDemo
//
//  Created by Tony Zhang on 16/7/4.
//  Copyright © 2016年 Tony Zhang. All rights reserved.
//

#import "RootTableViewController.h"



@interface Example : NSObject

/** title */
@property(nonatomic,strong)NSString *title;

/** 点击事件 */
@property(nonatomic,assign)SEL seletor;

@end

@implementation Example

+(instancetype)exampleWithTitle:(NSString *)title Action:(SEL)action{

    Example *example = [[Example alloc]init];
    example.title = title;
    example.seletor = action;
    return example;
}

@end

@interface RootTableViewController ()

/** dataArray */
@property(nonatomic,strong)NSArray<NSArray <Example *>*> *dataArray;


@end


@implementation RootTableViewController

-(void)viewDidLoad{

    [super viewDidLoad ];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//    NSLog(@"%@", languages);
    self.dataArray = @[@[[Example exampleWithTitle:@"自定义默认mode" Action:@selector(indeterminateExample)],[Example exampleWithTitle:@"带标题" Action:@selector(labelExample)],[Example exampleWithTitle:@"详情标题" Action:@selector(detailsLabelExample)]],@[[Example exampleWithTitle:@"圆形/条形进度条" Action:@selector(determinateExample)]],@[[Example exampleWithTitle:@"仅文字" Action:@selector(textExample)],[Example exampleWithTitle:@"自定义mode" Action:@selector(customViewExample)],[Example exampleWithTitle:@"带有取消按钮的mode" Action:@selector(cancelationExample)],[Example exampleWithTitle:@"混合模式" Action:@selector(modeSwitchingExample)]]];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    Example *example = self.dataArray[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MBExampleCell" forIndexPath:indexPath];
    cell.textLabel.text = example.title;
    cell.textLabel.textColor = self.view.tintColor;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.selectedBackgroundView = [UIView new];
    cell.selectedBackgroundView.backgroundColor = [cell.textLabel.textColor colorWithAlphaComponent:0.1f];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.dataArray[section].count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Example *example = self.dataArray[indexPath.section][indexPath.row];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:example.seletor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    });
}

- (void)indeterminateExample {
    // Show the HUD on the root view (self.view is a scrollable table view and thus not suitable,
    // as the HUD would move with the content as we scroll).
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [hud changeDefaultColor];
    // Fire off an asynchronous task, giving UIKit the opportunity to redraw wit the HUD added to the
    // view hierarchy.
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        
        // Do something useful in the background
        [self doSomeWork];
        
        // IMPORTANT - Dispatch back to the main thread. Always access UI
        // classes (including MBProgressHUD) on the main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)labelExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
    hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    // You can also adjust other label properties if needed.
    [hud changeDefaultColor];
    hud.labelFont = [UIFont italicSystemFontOfSize:16.f];
   
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)detailsLabelExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the label text.
     hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    // Set the details label text. Let's make it multiline this time.
    hud.detailsLabelText = NSLocalizedString(@"HUD title", nil);
    [hud changeDefaultColor];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)windowExample {
    // Covers the entire screen. Similar to using the root view controller view.
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view.window animated:YES];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        [self doSomeWork];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)determinateExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    //条形进度条
//    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
   //扇形进度条
//    hud.mode = MBProgressHUDModeDeterminate;
    //圆环进度条
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    [hud changeDefaultColor];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)customViewExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    // Set the custom view mode to show any view.
    hud.mode = MBProgressHUDModeCustomView;
    // Set an image view with a checkmark.
    UIImage *image = [UIImage imageNamed:@"Checkmark"];
    hud.customView = [[UIImageView alloc] initWithImage:image];
    [hud changeDefaultColor];
    // Looks a bit nicer if we make it square.
    hud.square = YES;
    // Optional label text.
   hud.labelText = NSLocalizedString(@"HUD done title", nil);
   [hud hide:YES afterDelay:3.f];
}

- (void)textExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the annular determinate mode to show task progress.
    hud.mode = MBProgressHUDModeText;
    hud.labelText = NSLocalizedString(@"HUD message title", nil);
    [hud changeDefaultColor];
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    [hud hide:YES afterDelay:3.f];
}

- (void)cancelationExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the determinate mode to show task progress.
    hud.mode = MBProgressHUDModeCustomView;
    hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    // Configure the button.
    [hud changeDefaultColor];
//    [hud.button setTitle:NSLocalizedString(@"Cancel", @"HUD cancel button title") forState:UIControlStateNormal];
//    [hud.button addTarget:self action:@selector(cancelWork:) forControlEvents:UIControlEventTouchUpInside];
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}

- (void)modeSwitchingExample {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set some text to show the initial status.
    hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    // Will look best, if we set a minimum size.
    hud.minSize = CGSizeMake(150.f, 100.f);
    [hud changeDefaultColor];
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), ^{
        // Do something useful in the background and update the HUD periodically.
        [self doSomeWorkWithMixedProgress];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
        });
    });
}


#pragma mark - Tasks

- (void)doSomeWork {
    // Simulate by just waiting.
    sleep(3.);
}

- (void)doSomeWorkWithProgress {
//    self.canceled = NO;
    // This just increases the progress indicator in a loop.
    float progress = 0.0f;
    while (progress < 1.0f) {
//        if (self.canceled) break;
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            // Instead we could have also passed a reference to the HUD
            // to the HUD to myProgressTask as a method parameter.
            [MBProgressHUD HUDForView:self.navigationController.view].progress = progress;
        });
        usleep(50000);
    }
}

- (void)doSomeWorkWithMixedProgress {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:self.navigationController.view];
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeAnnularDeterminate;
        hud.labelText = NSLocalizedString(@"HUD loading title", nil);
    });
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        dispatch_async(dispatch_get_main_queue(), ^{
            hud.progress = progress;
        });
        usleep(50000);
    }
    // Back to indeterminate mode
    dispatch_async(dispatch_get_main_queue(), ^{
        hud.mode = MBProgressHUDModeIndeterminate;
        hud.labelText = NSLocalizedString(@"HUD cleanining up title", nil);
    });
    sleep(2);
    dispatch_sync(dispatch_get_main_queue(), ^{
        UIImage *image = [UIImage imageNamed:@"Checkmark"];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        hud.customView = imageView;
        hud.mode = MBProgressHUDModeCustomView;
        hud.labelText = NSLocalizedString(@"HUD done title", nil);
    });
    sleep(2);
}


@end
