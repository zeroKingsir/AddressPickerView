//
//  AddressPicker.m
//  AddressPickerView
//
//  Created by G.Z on 16/9/11.
//  Copyright © 2016年 G.Z. All rights reserved.
//

#import "AddressPicker.h"

@interface AddressPicker ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIPickerView *pickerView;
@property (nonatomic,strong) NSDictionary *pickerDic;
@property (nonatomic,strong) NSArray *provinceArray;
@property (nonatomic,strong) NSArray *cityArray;
@property (nonatomic,strong) NSArray *townArray;
@property (nonatomic,strong) NSArray *selectedArray;

@end

@implementation AddressPicker
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self getAddressInformation];
        [self setBaseView];
    }
    return self;
}
- (void)getAddressInformation{
  
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"plist"];
    self.pickerDic = [NSDictionary dictionaryWithContentsOfFile:path];
//    self.pickerDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.provinceArray = [self.pickerDic allKeys];
    self.selectedArray = [self.pickerDic objectForKey:[[self.pickerDic allKeys] objectAtIndex:0]];
//    self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:0]];
    if (self.selectedArray.count > 0) {
        
        self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
    }
    if (self.cityArray.count > 0) {
        
        self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
    }
    
    
}
- (void)setBaseView{
    
    CGFloat height = self.frame.size.height;
    CGFloat width = self.frame.size.width;
    UIColor *color = [UIColor colorWithRed:242/255.0 green:243/255.0 blue:249/255.0 alpha:1];
    UIColor *btnColor = [UIColor colorWithRed:65.0/255.0 green:164.0/255.0 blue:249.0/255.0 alpha:1];
    UIView *selectedView = [[UIView alloc] initWithFrame:CGRectMake(0, height-210, width, 30)];
    selectedView.backgroundColor = color;
    
    UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancleBtn setTitle:@"取消" forState:0];
    [cancleBtn setTitleColor:btnColor forState:0];
    cancleBtn.frame = CGRectMake(0, 0, 60, 40);
    [cancleBtn addTarget:selectedView action:@selector(dateCancleAction) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:cancleBtn];
    
    UIButton *ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [ensureBtn setTitle:@"确定" forState:0];
    ensureBtn.frame = CGRectMake(width - 60, 0, 60, 40);
    [ensureBtn addTarget:selectedView action:@selector(dateEnsureAction) forControlEvents:UIControlEventTouchUpInside];
    [selectedView addSubview:ensureBtn];
    
    [self addSubview:selectedView];
    
    self.pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, height - 180, width, 180)];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    self.pickerView.backgroundColor = color;
    [self addSubview:self.pickerView];
    [self.pickerView reloadAllComponents];
    [self updateAddress];

}
- (void)updateAddressAtProvince:(NSString *)province city:(NSString *)city town:(NSString *)town{

    self.province = province;
    self.city = city;
    self.town = town;
    NSInteger currentIndex = 0;
    if (self.province) {
        
        for (NSInteger i = 0; i < self.provinceArray.count; i ++) {
            NSString *city = self.selectedArray[i];
            NSInteger select = 0;
            if ([city isEqualToString:self.province]) {
                select = i;
                [self.pickerView selectRow:i inComponent:0 animated:YES];
            }
        }
        self.cityArray = [self.pickerDic [self.province][0] allKeys];
        for (NSInteger i = 0; i < self.cityArray.count;  i++) {
            NSString *city = self.cityArray[i];
            if ([city isEqualToString:self.city]) {
                [self.pickerView selectRow:i inComponent:1 animated:YES];
            }
            
        }
        self.townArray = self.pickerDic[self.province][0][self.city];
        for (NSInteger i = 0; i < self.townArray.count; i++) {
            NSString *town = self.townArray[i];
            if ([town isEqualToString:self.town]) {
                currentIndex = i;
                break;
            }
        }
        
    }
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:currentIndex inComponent:2 animated:YES];
    [self updateAddress];
}
- (void)dateCancleAction{

    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressCancleAction:)]) {
        
        [self.delegate AddressCancleAction:@""];
    }
}
- (void)dateEnsureAction{

    if (self.delegate && [self.delegate respondsToSelector:@selector(AddressPickerReturnBlockWithProvince:city:town:)]) {
        
        [self.delegate AddressPickerReturnBlockWithProvince:self.province city:self.city town:self.town];
    }
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{

    UILabel *pickerLab = (UILabel *)view;
    if (!pickerLab) {
        pickerLab = [[UILabel alloc] init];
        pickerLab.adjustsFontSizeToFitWidth = YES;
        pickerLab.textAlignment = NSTextAlignmentCenter;
        [pickerLab setBackgroundColor:[UIColor clearColor]];
        [pickerLab setFont:self.font?:[UIFont boldSystemFontOfSize:14]];
    }
    pickerLab.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLab;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{

    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{

    if (component == 0) {
        return self.provinceArray.count;
    }
    else if (component == 1){
    
        return self.cityArray.count;
    }
    else if (component == 2){
    
        return self.townArray.count;
    }
    else{
    
        return 0;
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{

    if (component == 0) {
        return [self.provinceArray objectAtIndex:row];
    } else if (component == 1) {
        return [self.cityArray objectAtIndex:row];
    } else if(component == 2) {
        return [self.townArray objectAtIndex:row];
    }else{
        return 0;
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{

    if (component == 0) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:row]];
        if (self.selectedArray.count > 0) {
            self.cityArray = [[self.selectedArray objectAtIndex:0] allKeys];
        } else {
            self.cityArray = @[];
        }
        if (self.cityArray.count > 0) {
            self.townArray = [[self.selectedArray objectAtIndex:0] objectForKey:[self.cityArray objectAtIndex:0]];
        } else {
            self.townArray = @[];
        }
        [pickerView reloadComponent:1];
        [pickerView selectedRowInComponent:1];
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 1) {
        self.selectedArray = [self.pickerDic objectForKey:[self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]]];
        NSDictionary *dic = self.selectedArray.firstObject;
        NSString *stirng = self.cityArray[row];
        for (NSString *string in dic.allKeys) {
            if ([stirng isEqualToString:string]) {
                self.townArray = dic[string];
            }
        }
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    if (component == 2) {
        [pickerView reloadComponent:2];
        [pickerView selectedRowInComponent:2];
    }
    [self updateAddress];
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{

    return  self.frame.size.width/3;
}
- (void)updateAddress{

    self.province = [self.provinceArray objectAtIndex:[self.pickerView selectedRowInComponent:0]];
    self.city = [self.cityArray objectAtIndex:[self.pickerView selectedRowInComponent:1]];
    self.town = [self.townArray objectAtIndex:[self.pickerView selectedRowInComponent:2]];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
