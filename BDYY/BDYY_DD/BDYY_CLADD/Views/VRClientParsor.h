//
//  VRClientParsor.h
//  VRClientDemo
//
//  Created by baidu on 15/11/24.
//
//

#import <Foundation/Foundation.h>

@class VRResultData;

@interface VRClientParsor : NSObject

// 类方法
+ (VRClientParsor *)sharedInstance;

// 解析数据，必须采用utf-8编码
- (VRResultData *)parseOriginJsonData:(NSData *)aData;

@end // BDVRDataParser

@interface VRResultData : NSObject
{
    NSMutableArray *_audioResultData;	// 对应返回结果中的item列表
    NSMutableArray *_audioResultUncertainData; // 对应返回结果中的uncertain列表
    NSString *_message;				// 对应error属性
    NSInteger status;				// 对应err_no属性
    NSString *corpus_no;
    NSInteger idx;             // 对应idx属性
    NSString *_globalKey; // 对应sn属性
    NSInteger resType;  // 对应res_type属性
    id _commandData; // 对应的指令数据
}

// 属性
@property (nonatomic, retain) NSMutableArray *audioResultData;
@property (nonatomic, retain) NSMutableArray *audioResultUncertainData;
@property (nonatomic, retain) NSString *message;
@property (nonatomic) NSInteger status;
@property (nonatomic, retain) NSString *corpus_no;
@property (nonatomic) NSInteger idx;
@property (nonatomic, retain) NSString *globalKey;
@property (nonatomic) NSInteger resType;
@property (nonatomic, retain) id commandData;

@end