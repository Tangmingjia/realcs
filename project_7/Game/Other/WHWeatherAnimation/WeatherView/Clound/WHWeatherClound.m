//
//  WHWeatherClound.m
//  SiShi
//
//  Created by whbalzac on 13/10/2017.
//  Copyright © 2017 whbalzac. All rights reserved.
//

#import "WHWeatherClound.h"

@interface WHWeatherClound ()
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) UIImageView *birdImage;
//@property (nonatomic, strong) UIImageView *birdRefImage;
@property (nonatomic, strong) UIImageView *cloudImageViewF;
@property (nonatomic, strong) UIImageView *cloudImageViewS;
@end

@implementation WHWeatherClound

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureView];
    }
    return self;
}

-(void)configureView
{
    //鸟 本体
    self.birdImage = [[UIImageView alloc] initWithFrame:CGRectMake(-30, kScreenHeight * 0.13, 69, 52)];
    [self.birdImage setAnimationImages:self.imageArr];
    self.birdImage.animationRepeatCount = 0;
    self.birdImage.animationDuration = 1;
    [self.birdImage startAnimating];
    [self addSubview:self.birdImage];
    [self.birdImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(kScreenWidth+30) duration:10 autoreverses:NO] forKey:nil];
//
//    //鸟 倒影
//    self.birdRefImage = [[UIImageView alloc] initWithFrame:CGRectMake(-30, kScreenHeight * 0.9, 70, 50)];
//    [self addSubview:self.birdRefImage];
//    [self.birdRefImage setAnimationImages:self.imageArr];
//    self.birdRefImage.animationRepeatCount = 0;
//    self.birdRefImage.animationDuration = 1;
//    self.birdRefImage.alpha = 0.4;
//    [self.birdRefImage startAnimating];
//    [self.birdRefImage.layer addAnimation:[self birdFlyAnimationWithToValue:@(kScreenWidth+30) duration:10 autoreverses:NO] forKey:nil];
    
    //云朵效果
    self.cloudImageViewF = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_white_cloud_0.png"]];
    self.cloudImageViewF.frame = CGRectMake(0, 0, 215, 80);
    self.cloudImageViewF.center = CGPointMake(kScreenWidth * 0.25, kScreenHeight*0.1);
    [self.cloudImageViewF.layer addAnimation:[self birdFlyAnimationWithToValue:@(kScreenWidth+30) duration:70 autoreverses:YES] forKey:nil];
    [self addSubview:self.cloudImageViewF];
    
    self.cloudImageViewS = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ele_white_cloud_8.png"]];
    self.cloudImageViewS.frame = CGRectMake(0, 0, 215, 100);
    self.cloudImageViewS.center = CGPointMake(kScreenWidth * 0.05, kScreenHeight*0.1);
    [self.cloudImageViewS.layer addAnimation:[self birdFlyAnimationWithToValue:@(kScreenWidth+30) duration:70 autoreverses:YES] forKey:nil];
    [self addSubview:_cloudImageViewS];
    
    self.layer.speed = 0.0;
}

-(void)startAnimation
{
    [super startAnimation];
    
    self.layer.speed = 1.0;
}

-(void)stopAnimation
{
    [super stopAnimation];
}


#pragma mark -
#pragma mark - Getter
-(NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
        for (int i = 1; i < 9; i++) {
            [_imageArr addObject:[UIImage imageNamed:[NSString stringWithFormat:@"ele_sunnyBird%d.png",i]]];
        }
    }
    return _imageArr;
}

@end
