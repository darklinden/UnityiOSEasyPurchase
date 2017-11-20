//
//  LYWebAddons_C.h
//  LYWebAddons
//
//  Created by whoami on 9/10/17.
//  Copyright © 2017年 whoami. All rights reserved.
//

#ifndef EasyPurchase_C_h
#define EasyPurchase_C_h

extern "C" {
    
    typedef void(*_EasyPurchase_Callback)(const char *productId, const char *transactionId, const char *receiptData, int error);
    
    void _EasyPurchase_purchaseProductById(const char *productId, int productPaymentType, _EasyPurchase_Callback cb);
    
}

#endif /* LYWebAddons_C_h */
