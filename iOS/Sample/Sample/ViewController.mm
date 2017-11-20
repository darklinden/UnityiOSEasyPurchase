//
//  ViewController.m
//  Sample
//
//  Created by whoami on 9/10/17.
//  Copyright © 2017年 whoami. All rights reserved.
//

#import "ViewController.h"
#import "EasyPurchase_C.h"

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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

extern "C" {
    void wtf(const char *productId, const char *transactionId, const char *receiptData, int error) {
        
    }
}

- (IBAction)btnClicked:(id)sender {
    _EasyPurchase_purchaseProductById("123", SKProductPaymentTypeConsumable, wtf);
}

@end
