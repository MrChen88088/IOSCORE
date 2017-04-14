//
//  ViewController.m
//  BDYY_DD
//
//  Created by MrChen on 17/3/29.
//  Copyright © 2017年 CHENLEIJING. All rights reserved.
//

#import "BD_VoiceVC.h"
#import "BDVoiceRecognitionClient.h"
#import "BDVRSConfig.h" 
#import "BDVRLogger.h"
#warning 请修改为您在百度开发者平台申请的API_KEY和SECRET_KEY
#define API_KEY @"8MAxI5o7VjKSZOKeBzS4XtxO" // 请修改为您在百度开发者平台申请的API_KEY
#define SECRET_KEY @"Ge5GXVdGQpaxOmLzc8fOM8309ATCz9Ha" // 请修改您在百度开发者平台申请的SECRET_KEY


#define FitScreenWidth  ([UIScreen mainScreen].bounds.size.width-302.0)/2.0
#define FitScreenHeight  ([UIScreen mainScreen].bounds.size.height-352.0)/2.0
@interface BD_VoiceVC ()

@end

@implementation BD_VoiceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [BDVRLogger setLogLevel:BDVR_LOG_DEBUG];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 300, 200, 40)];
    [button setBackgroundColor:[UIColor redColor]];
    [button addTarget:self action:@selector(BDYY_DD_Click:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)BDYY_DD_Click:(UIButton *)sender {
    [self initWithBDYYUI];
}


-(void)initWithBDYYUI{
    
    
    
    NSLog(@"%f",FitScreenWidth);
    
    // 创建识别控件
    BDRecognizerViewController *tmpRecognizerViewController = [[BDRecognizerViewController alloc] initWithOrigin:CGPointMake(FitScreenWidth, FitScreenHeight) withTheme:[BDVRSConfig sharedInstance].theme];
    NSLog(@"%f",tmpRecognizerViewController.view.frame.size.width);
    // 全屏UI
    if ([[BDVRSConfig sharedInstance].theme.name isEqualToString:@"全屏亮蓝"]) {
        tmpRecognizerViewController.enableFullScreenMode = YES;
    }
    
    tmpRecognizerViewController.delegate = self;
    self.recognizerViewController = tmpRecognizerViewController;
    
    // 设置识别参数
    BDRecognizerViewParamsObject *paramsObject = [[BDRecognizerViewParamsObject alloc] init];
    
    // 开发者信息，必须修改API_KEY和SECRET_KEY为在百度开发者平台申请得到的值，否则示例不能工作
    paramsObject.apiKey = API_KEY;
    paramsObject.secretKey = SECRET_KEY;
    
    // 设置是否需要语义理解，只在搜索模式有效
    paramsObject.isNeedNLU = [BDVRSConfig sharedInstance].isNeedNLU;
    
    // 设置识别语言
    paramsObject.language = [BDVRSConfig sharedInstance].recognitionLanguage;
    
    // 设置识别模式，分为搜索和输入
    paramsObject.recogPropList = @[[BDVRSConfig sharedInstance].recognitionProperty];
    
    // 设置城市ID，当识别属性包含EVoiceRecognitionPropertyMap时有效
    paramsObject.cityID = 1;
    
    // 开启联系人识别
    //    paramsObject.enableContacts = YES;
    
    // 设置显示效果，是否开启连续上屏
    if ([BDVRSConfig sharedInstance].resultContinuousShow)
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeContinuousShow;
    }
    else
    {
        paramsObject.resultShowMode = BDRecognizerResultShowModeWholeShow;
    }
    
    // 设置提示音开关，是否打开，默认打开
    if ([BDVRSConfig sharedInstance].uiHintMusicSwitch)
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordPlay;
    }
    else
    {
        paramsObject.recordPlayTones = EBDRecognizerPlayTonesRecordForbidden;
    }
    
    //Test uncertain:
    [[BDVoiceRecognitionClient sharedInstance] setProductId:@"790"];
    paramsObject.isNeedOriginJsonResult = YES;
    
    paramsObject.isShowTipAfterSilence = NO;
    paramsObject.isShowHelpButtonWhenSilence = NO;
    paramsObject.tipsTitle = @"可以使用如下指令记账";
    paramsObject.tipsList = [NSArray arrayWithObjects:@"我要记账", @"买苹果花了十块钱", @"买牛奶五块钱", @"第四行滚动后可见", @"第五行是最后一行", nil];
    
    [_recognizerViewController startWithParams:paramsObject];

}



- (void)onEndWithViews:(BDRecognizerViewController *)aBDRecognizerView withResults:(NSArray *)aResults
{
    _textView.text = nil;
    
    if ([[BDVoiceRecognitionClient sharedInstance] getRecognitionProperty] != EVoiceRecognitionPropertyInput)
    {
        // 搜索模式下的结果为数组，示例为
        // ["公园", "公元"]
        NSMutableArray *audioResultData = (NSMutableArray *)aResults;
        NSMutableString *tmpString = [[NSMutableString alloc] initWithString:@""];
        
        for (int i=0; i < [audioResultData count]; i++)
        {
            [tmpString appendFormat:@"%@\r\n",[audioResultData objectAtIndex:i]];
        }
        
        _textView.text = [_textView.text stringByAppendingString:tmpString];
        _textView.text = [_textView.text stringByAppendingString:@"\n"];
         
    }
    else
    {
        // 输入模式下的结果为带置信度的结果，示例如下：
        //  [
        //      [
        //         {
        //             "百度" = "0.6055192947387695";
        //         },
        //         {
        //             "摆渡" = "0.3625582158565521";
        //         },
        //      ]
        //      [
        //         {
        //             "一下" = "0.7665404081344604";
        //         }
        //      ],
        //   ]
        NSString *tmpString = [[BDVRSConfig sharedInstance] composeInputModeResult:aResults];
        
        _textView.text = [_textView.text stringByAppendingString:tmpString];
        _textView.text = [_textView.text stringByAppendingString:@"\n"];
    }
}

- (void)logOutToContinusManualResut:(NSString *)aResult
{
    _textView.text = aResult;
}

- (void)logOutToLogView:(NSString *)aLog
{
    NSString *tmpString = _textView.text;
    
    if (tmpString == nil || [tmpString isEqualToString:@""])
    {
        _textView.text = aLog;
    }
    else
    {
        _textView.text = [_textView.text stringByAppendingFormat:@"\r\n%@", aLog];
    }
}
@end
