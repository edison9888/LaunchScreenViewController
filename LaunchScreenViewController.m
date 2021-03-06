//
//  LaunchScreenViewController.m
//  Xidmet
//
//  Created by Антон Буков on 19.11.14.
//  Copyright (c) 2014 Anton Bukov. All rights reserved.
//

#import "LaunchScreenViewController.h"

@interface LaunchScreenViewController ()

@property (nonatomic, strong) UIImageView *snapshotView;
@property (nonatomic, readonly) NSString *launchScreenName;
@property (nonatomic, readonly) BOOL isStatusBarInitiallyHidden;

@end

@implementation LaunchScreenViewController

- (UIImageView *)snapshotView
{
    if (_snapshotView == nil) {
        UIGraphicsBeginImageContextWithOptions([UIScreen mainScreen].bounds.size, YES, 0.0);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _snapshotView = [[UIImageView alloc] initWithImage:img];
        _snapshotView.frame = [UIScreen mainScreen].bounds;
    }
    return _snapshotView;
}

- (NSString *)launchScreenName
{
    return [[NSBundle mainBundle] infoDictionary][@"UILaunchStoryboardName"];
}

- (BOOL)isStatusBarInitiallyHidden
{
    return [[[NSBundle mainBundle] infoDictionary][@"UIStatusBarHidden"] boolValue];
}

- (BOOL)prefersStatusBarHidden
{
    return self.isStatusBarInitiallyHidden;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *app = [UIApplication sharedApplication];
    
    self.view = [[UINib nibWithNibName:self.launchScreenName bundle:nil] instantiateWithOwner:self options:nil].firstObject;
    self.view.frame = app.keyWindow.bounds;
    [self.view layoutIfNeeded];
    if (self.isStatusBarInitiallyHidden)
        app.keyWindow.windowLevel = UIWindowLevelStatusBar+1;
    [app.keyWindow addSubview:self.snapshotView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.snapshotView removeFromSuperview];
    UIApplication *app = [UIApplication sharedApplication];
    if (self.isStatusBarInitiallyHidden)
        app.keyWindow.windowLevel = UIWindowLevelNormal;
}

@end
