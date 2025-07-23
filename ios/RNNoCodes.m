#import "RNNoCodes.h"

static NSString *const kNoCodesEventName = @"NoCodesEvent";

static NSString *const kScreenShownEventName = @"nocodes_screen_shown";
static NSString *const kFinishedEventName = @"nocodes_finished";
static NSString *const kActionStartedEventName = @"nocodes_action_started";
static NSString *const kActionFailedEventName = @"nocodes_action_failed";
static NSString *const kActionFinishedEventName = @"nocodes_action_finished";
static NSString *const kScreenFailedToLoadEventName = @"nocodes_screen_failed_to_load";

@interface RNNoCodes ()

@property (nonatomic, strong) NoCodesSandwich *noCodesSandwich;

@end

@implementation RNNoCodes

RCT_EXPORT_MODULE()

- (instancetype)init {
    self = [super init];
    if (self) {
        _noCodesSandwich = [[NoCodesSandwich alloc] initWithNoCodesEventListener:self];
    }
    return self;
}

- (NSArray<NSString *> *)supportedEvents {
    return @[kNoCodesEventName, kScreenShownEventName, kFinishedEventName, kActionStartedEventName, kActionFailedEventName, kActionFinishedEventName, kScreenFailedToLoadEventName];
}

RCT_EXPORT_METHOD(initialize:(NSString *)projectKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    [self.noCodesSandwich initializeWithProjectKey:projectKey];
}

RCT_EXPORT_METHOD(setScreenPresentationConfig:(NSDictionary *)configData
                  contextKey:(NSString *)contextKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.noCodesSandwich setScreenPresentationConfig:configData forContextKey:contextKey];
    });
}

RCT_EXPORT_METHOD(showScreen:(NSString *)contextKey
                  resolver:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.noCodesSandwich showScreen:contextKey];
    });
}

RCT_EXPORT_METHOD(close:(RCTPromiseResolveBlock)resolve
                  rejecter:(RCTPromiseRejectBlock)reject) {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.noCodesSandwich close];
    });
}

+ (BOOL)requiresMainQueueSetup {
    return NO;
}

- (void)noCodesDidTriggerWithEvent:(NSString * _Nonnull)event payload:(NSDictionary<NSString *,id> * _Nullable)payload {
    NSMutableDictionary *eventData = [NSMutableDictionary dictionary];
    eventData[@"event"] = event;
    if (payload) {
        eventData[@"payload"] = payload;
    }
    
    [self sendEventWithName:kNoCodesEventName body:eventData];
}

@end
