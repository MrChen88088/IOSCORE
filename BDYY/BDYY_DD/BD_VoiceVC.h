//
//  ViewController.h
//  BDYY_DD
//
//  Created by MrChen on 17/3/29.
//  Copyright © 2017年 CHENLEIJING. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BDRecognizerViewController.h"
#import "BDRecognizerViewDelegate.h"
#import "BDVRFileRecognizer.h"
#import "BDVRDataUploader.h"

@interface BD_VoiceVC : UIViewController<BDRecognizerViewDelegate, MVoiceRecognitionClientDelegate, BDVRDataUploaderDelegate>
@property (nonatomic, retain) BDRecognizerViewController *recognizerViewController;
 

@property (weak, nonatomic) IBOutlet UITextView *textView;


-(void)initWithBDYYUI;

- (void)logOutToContinusManualResut:(NSString *)aResult;
- (void)logOutToManualResut:(NSString *)aResult;
- (void)logOutToLogView:(NSString *)aLog;
@end

