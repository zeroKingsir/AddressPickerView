//
//  ViewController.m
//  AddressPickerView
//
//  Created by G.Z on 16/9/11.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "ViewController.h"
#import "AddressPicker.h"
#define kSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<AddressPickerDelegate>
@property (nonatomic,strong) AddressPicker *pickerView;
@property (nonatomic,strong) UIButton *addressBtn;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(20, 100, kSCREEN_WIDTH - 40, 80);
    [button setTitle:@"加载地址" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor cyanColor];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addressBtn = button;
    [self.view addSubview:self.addressBtn];
    [button addTarget:self action:@selector(enterAddress) forControlEvents:UIControlEventTouchUpInside];

}
- (void)enterAddress{

    if (self.pickerView) {
        
        self.pickerView.hidden = NO;
        return;
    }
    self.pickerView = [[AddressPicker alloc] initWithFrame:CGRectMake(0, 0, kSCREEN_WIDTH, kSCREEN_HEIGHT)];
    [self.pickerView updateAddressAtProvince:@"河北省" city:@"石家庄市" town:@"平山县"];
    self.pickerView.delegate = self;
    self.pickerView.font = [UIFont boldSystemFontOfSize:14];
    [self.view addSubview:self.pickerView];
}
- (void)AddressCancleAction:(id)senter{

    self.pickerView.hidden = YES;
}
- (void)AddressPickerReturnBlockWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town{

    self.pickerView.hidden = YES;
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@",province,city,town] forState:UIControlStateNormal];
    NSLog(@"%@  %@  %@",province,city,town);
}
- (void)setPickerView:(AddressPicker *)pickerView{

    if (!_pickerView) {
        
        _pickerView = pickerView;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
