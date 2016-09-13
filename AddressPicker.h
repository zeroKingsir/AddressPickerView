//
//  AddressPicker.h
//  AddressPickerView
//
//  Created by G.Z on 16/9/11.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddressPickerDelegate <NSObject>
@optional
- (void)AddressPickerReturnBlockWithProvince:(NSString *)province city:(NSString *)city town:(NSString *)town;
- (void)AddressCancleAction:(id)senter;

@end

@interface AddressPicker : UIView
@property (nonatomic,weak) id<AddressPickerDelegate>delegate;
@property (nonatomic,strong) NSString *province;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *town;
//内容字体
@property (nonatomic,strong) UIFont *font;

- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town;


@end
