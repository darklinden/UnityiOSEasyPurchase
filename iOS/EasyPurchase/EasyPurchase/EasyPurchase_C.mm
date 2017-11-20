//
// Copyright (c) 2016 eppz! mobile, Gergely Borbás (SP)
//
// http://www.twitter.com/_eppz
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
// INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
// PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
// CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
// OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "EasyPurchase_C.h"
#import "EasyPurchase.h"
#import "UnityString.h"

extern "C" {
    
    void _EasyPurchase_purchaseProductById(const char *productId_, int productPaymentType_, _EasyPurchase_Callback cb_)
    {
        NSString* productId = NSStringFromUnityString(productId_);
        SKProductPaymentType productPaymentType = (SKProductPaymentType)productPaymentType_;
        
        [EasyPurchase purchaseProductById:productId type:productPaymentType completion:^(NSString *productId, NSString *transactionId, NSString *receiptData, EPError error) {
            if (cb_) {
                cb_(UnityStringFromNSString(productId),
                    UnityStringFromNSString(transactionId),
                    UnityStringFromNSString(receiptData),
                    (int)error);
            }
        }];
    }
    
}
