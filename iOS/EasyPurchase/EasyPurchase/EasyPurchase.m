//
//  EasyPurchase.m
//  EasyPurchase
//
//  Created by darklinden on 14-9-15.
//  Copyright (c) 2014年 darklinden. All rights reserved.
//

#import "EasyPurchase.h"
#import "EPProductInfo.h"
#import "EPPurchaseObserver.h"

@implementation EasyPurchase

//request products informations
+ (void)requestProductsByIds:(NSArray *)productIds completion:(EPProductInfoCompletionHandle)completionHandle
{
    [EPProductInfo requestProductsByIds:productIds completion:completionHandle];
}

//single purchase
+ (void)purchase:(SKProduct *)product type:(SKProductPaymentType)type completion:(EPPurchaseCompletionHandle)completionHandle
{
    [EPPurchaseObserver purchase:product type:type
                      completion:^(NSString *productId, NSString *transactionId, NSString *receiptData, EPError error) {
        if (EPErrorSuccess != error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(productId, nil, nil, error);
                }
            });
        }
        else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(productId, transactionId, receiptData, error);
                }
            });
        }
    }];
}

//single purchase
+ (void)purchaseProductById:(NSString *)productId type:(SKProductPaymentType)type completion:(EPPurchaseCompletionHandle)completionHandle
{
    //get product by id
    [EPProductInfo requestProductsByIds:@[productId] completion:^(NSArray *requestProductIds, NSArray *responseProducts) {
        
        SKProduct *product = nil;
        for (SKProduct *p in responseProducts) {
            if ([p.productIdentifier isEqualToString:productId]) {
                product = p;
                break;
            }
        }
        
        if (!product) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionHandle) {
                    completionHandle(productId, nil, nil, EPErrorGetProductFailed);
                }
            });
        }
        else {
            [self purchase:product type:type completion:completionHandle];
        }
    }];
}

+ (NSString *)base64EncodedStringFrom:(NSData *)data
{
    static const char encodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    if ([data length] == 0)
        return @"";
    
    char *characters = malloc((([data length] + 2) / 3) * 4);
    if (characters == NULL)
        return nil;
    NSUInteger length = 0;
    
    NSUInteger i = 0;
    while (i < [data length])
    {
        char buffer[3] = {0,0,0};
        short bufferLength = 0;
        while (bufferLength < 3 && i < [data length])
            buffer[bufferLength++] = ((char *)[data bytes])[i++];
        
        //  Encode the bytes in the buffer to four characters, including padding "=" characters if necessary.
        characters[length++] = encodingTable[(buffer[0] & 0xFC) >> 2];
        characters[length++] = encodingTable[((buffer[0] & 0x03) << 4) | ((buffer[1] & 0xF0) >> 4)];
        if (bufferLength > 1)
            characters[length++] = encodingTable[((buffer[1] & 0x0F) << 2) | ((buffer[2] & 0xC0) >> 6)];
        else characters[length++] = '=';
        if (bufferLength > 2)
            characters[length++] = encodingTable[buffer[2] & 0x3F];
        else characters[length++] = '=';
    }
    
    return [[NSString alloc] initWithBytesNoCopy:characters length:length encoding:NSASCIIStringEncoding freeWhenDone:YES];
}

@end
