//
//  DZViewController.m
//  InjectionIIISupport
//
//  Created by zengjing on 11/11/2023.
//  Copyright (c) 2023 zengjing. All rights reserved.
//

#import "DZViewController.h"
#import <Masonry/Masonry.h>

@interface DZViewController ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation DZViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.textLabel];
    self.textLabel.text = @"Hello InjectionIII";
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.view).offset(10);
        make.trailing.equalTo(self.view).offset(-10);
        make.top.equalTo(self.view).offset(10);
        make.bottom.equalTo(self.view).offset(-10);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UILabel *)textLabel {
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:16.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.textColor = [UIColor blueColor];
    }
    return _textLabel;
}

@end
