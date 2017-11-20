//
//  EasyPurchase.h
//  EasyPurchase
//
//  Created by darklinden on 14-9-15.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#if COCOS2D_DEBUG

#define IAP_OBSERVER_LOG( ... )             NSLog(@"IAP_OBSERVER: %@", [NSString stringWithFormat:__VA_ARGS__])
#define IAP_PRODUCT_LOG( ... )              NSLog(@"IAP_PRODUCT:%@", [NSString stringWithFormat:__VA_ARGS__])
#define IAP_CHECK_LOG( ... )                NSLog(@"IAP_CHECK: %@", [NSString stringWithFormat:__VA_ARGS__])
#define IAP_CONTROLLER_LOG( ... )           NSLog(@"IAP_CONTROLLER: %@", [NSString stringWithFormat:__VA_ARGS__])

#else

#define IAP_OBSERVER_LOG( ... )             do {} while (0)
#define IAP_PRODUCT_LOG( ... )              do {} while (0)
#define IAP_CHECK_LOG( ... )                do {} while (0)
#define IAP_CONTROLLER_LOG( ... )           do {} while (0)

#endif

#define EPErrorMsg \
@{ \
@(EPErrorSuccess) : @"支付成功", \
@(EPErrorGetProductFailed) : @"获取产品ID失败，请检查网络后再试", \
@(EPErrorCancelled) : @"用户取消支付", \
@(EPErrorClientInvalid) : @"客户端已被禁止支付，请检查隐私权限后再试", \
@(EPErrorPaymentInvalid) : @"该产品暂时无法支付", \
@(EPErrorPaymentNotAllowed) : @"客户端已被禁止支付，请检查隐私权限后再试", \
@(EPErrorProductNotAvailable) : @"该产品暂时无法支付", \
@(EPErrorCloudServicePermissionDenied) : @"云服务器权限被禁用", \
@(EPErrorCloudServiceNetworkConnectionFailed) : @"网络异常", \
@(EPErrorUnknown) : @"未知错误", \
@(EPErrorRestoreError) : @"恢复购买失败", \
@(EPErrorRestoreGetEmptyArray) : @"恢复购买返回结果为空", \
@(EPErrorQueueDeadLock) : @"已有支付卡在列表，如此错误重复出现，请重启设备后再试", \
@(EPErrorTransactionDeferred) : @"支付处理中，请等待苹果服务器处理，如有问题请联系客服处理", \
}

//if IAP_Check_DeadLock is setted to TRUE, the purchase will return an "EPErrorQueueDeadLock" error if there's any unfinished payment in queue
//for Non-Consumable purchase it recommended to restart the device, but I have no idea for consumable purchase.
//It is not a good idea to stop purchase in this case
//TODO: an solution for deadlock payment in queue
#define IAP_Check_DeadLock FALSE

//if IAP_Check_TransactionDeferred is setted to TRUE, the purchase will return an "EPErrorTransactionDeferred" error if an Non-Consumable purchase suffered the SKPaymentTransactionStateDeferred state
#define IAP_Check_TransactionDeferred FALSE

typedef enum : NSUInteger {
    //success
    EPErrorSuccess = 0,
    
    //get product error
    EPErrorGetProductFailed = 1,
    
    //purchase error
    EPErrorCancelled = 2,
    EPErrorClientInvalid = 3,
    EPErrorPaymentInvalid = 4,
    EPErrorPaymentNotAllowed = 5,
    EPErrorProductNotAvailable = 6,
    
    EPErrorCloudServicePermissionDenied = 7,
    EPErrorCloudServiceNetworkConnectionFailed = 8,
    
    EPErrorUnknown = 9,
    
    //restore error
    EPErrorRestoreError = 10,
    EPErrorRestoreGetEmptyArray = 11,
    
    //other definition
    EPErrorQueueDeadLock = 12,
    EPErrorTransactionDeferred = 13
} EPError;

typedef enum : NSUInteger {
    SKProductPaymentTypeNonConsumable = 0,
    SKProductPaymentTypeConsumable = 1
} SKProductPaymentType;

typedef void(^EPProductInfoCompletionHandle)(NSArray *requestProductIds, NSArray *responseProducts);

typedef void(^EPPurchaseCompletionHandle)(NSString *productId, NSString *transactionId, NSString* receiptData, EPError error);

typedef void(^EPRestoreCompletionHandle)(NSArray *restoredProducts, EPError error);

typedef void(^EPReceiptCheckerCompletionHandle)(NSArray *passedProducts, EPError error);

typedef void(^EPConsumableReceiptCheckerCompletionHandle)(NSString *productId, NSString *transactionId, EPError error);

@interface EasyPurchase : NSObject

#pragma mark - product info

//request products informations
+ (void)requestProductsByIds:(NSArray *)productIds completion:(EPProductInfoCompletionHandle)completionHandle;

//single purchase
+ (void)purchase:(SKProduct *)product
            type:(SKProductPaymentType)type
      completion:(EPPurchaseCompletionHandle)completionHandle;

+ (void)purchaseProductById:(NSString *)productId
                       type:(SKProductPaymentType)type
                 completion:(EPPurchaseCompletionHandle)completionHandle;

+ (NSString *)base64EncodedStringFrom:(NSData *)data;
@end

