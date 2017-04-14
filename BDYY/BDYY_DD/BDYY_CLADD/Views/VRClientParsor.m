//
//  VRClientParsor.m
//  VRClientDemo
//
//  Created by baidu on 15/11/24.
//
//

#define RESULT_KEY                          @"result"
#define ERR_NO_KEY                          @"err_no"
#define ERROR_KEY                           @"error"
#define CORPUS_NO_KEY                   @"corpus_no"

#define CONTENT_KEY			             @"content"
#define ITEM_KEY                               @"item"
#define UNCERTAIN_ITEM_KEY                     @"uncertain_item"
#define JSONRES_KEY                         @"json_res"
#define JSONRES_DATA_KEY                         @"data"
#define JSONRES_DATA_RAW_KEY                         @"raw_text"
#define JSONRES_DATA_PARSED_KEY                         @"parsed_text"
#define JSONRES_DATA_RESULTS_KEY                         @"results"
#define JSONRES_DATA_COMMAND_KEY                         @"command"
#define RES_TYPE_KEY                        @"res_type"
#define IDX_KEY                                  @"idx"

// 输入模式下使用
#define SN_KEY                                  @"sn"
#define IDXS_KEY                               @"idxs"
#define NO_DATA_ERROR_KEY                   @"result"

#import "VRClientParsor.h"

@implementation VRClientParsor

- (id)init
{
    self = [super init];
    if (self)
    {
    }
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

+ (VRClientParsor *)sharedInstance
{
    static VRClientParsor *_sharedInstance = nil;
    if (_sharedInstance == nil)
    {
        _sharedInstance = [[VRClientParsor alloc] init];
    }
    
    return _sharedInstance;
}

#pragma mark - parse methods
- (VRResultData *)parseOriginJsonData:(NSData *)aData
{
    VRResultData *audioResultData = [[VRResultData alloc] init];
    
    if (aData && [aData length])
    {
        NSError *jsonError = nil;
        NSDictionary *tmpAllDic = [NSJSONSerialization JSONObjectWithData:aData
                                                                  options:0
                                                                    error:&jsonError];
        
        if (tmpAllDic && !jsonError)
        {
            // 解析result部分
            id tmpElement = [tmpAllDic objectForKey:RESULT_KEY];
            if (tmpElement && [tmpElement isKindOfClass:[NSDictionary class]])
            {
                audioResultData.status = [[tmpElement objectForKey:ERR_NO_KEY] intValue];
                audioResultData.message = [tmpElement objectForKey:ERROR_KEY];
                audioResultData.corpus_no = [[tmpElement objectForKey:CORPUS_NO_KEY] stringValue];
                audioResultData.globalKey = [tmpElement objectForKey:SN_KEY];
                audioResultData.resType = [[tmpElement objectForKey:RES_TYPE_KEY] intValue];
                audioResultData.idx = [[tmpElement objectForKey:IDX_KEY] intValue];
                
                if (audioResultData.status == 0)
                {
                    tmpElement = [tmpAllDic objectForKey:CONTENT_KEY];
                    if (tmpElement && [tmpElement isKindOfClass:[NSDictionary class]])
                    {
                        id tmpItem = [tmpElement objectForKey:ITEM_KEY];
                        if (tmpItem && [tmpItem isKindOfClass:[NSArray class]])
                        {
                            audioResultData.audioResultData = tmpItem;
                        }
                        
                        tmpItem = [tmpElement objectForKey:UNCERTAIN_ITEM_KEY];
                        if (tmpItem && [tmpItem isKindOfClass:[NSArray class]])
                        {
                            audioResultData.audioResultUncertainData = tmpItem;
                        }
                    }
                }
            }
        }
    }
    
    return [audioResultData autorelease];
}

@end

@interface VRResultData ()

@end

@implementation VRResultData
@synthesize audioResultData = _audioResultData;
@synthesize audioResultUncertainData = _audioResultUncertainData;
@synthesize message = _message;
@synthesize status;
@synthesize corpus_no = _corpus_no;
@synthesize idx;
@synthesize globalKey = _globalKey;
@synthesize resType;
@synthesize commandData = _commandData;
-(void)dealloc
{
    [_commandData release];
    [_audioResultData release];
    [_audioResultUncertainData release];
    [_message release];
    [_corpus_no release];
    [_globalKey release];
    [super dealloc];
}
@end
