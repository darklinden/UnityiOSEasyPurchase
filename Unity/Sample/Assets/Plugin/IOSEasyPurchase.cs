using System;
using System.Collections;
using System.Runtime.InteropServices;
using UnityEngine;
using AOT;

public class IOSEasyPurchase
{
	public enum EPError : int
	{
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
	}

	public enum SKProductPaymentType : int
	{
		SKProductPaymentTypeNonConsumable = 0,
		SKProductPaymentTypeConsumable = 1
	}

	delegate void _EasyPurchase_Callback (string productId, string transactionId, string receiptData, int error);

	[DllImport ("__Internal")]
	static extern void _EasyPurchase_purchaseProductById (string productId, int productPaymentType, _EasyPurchase_Callback cb);

	static System.Action<string, string, string, EPError> _purchaseCallback = null;

	[MonoPInvokeCallback (typeof(_EasyPurchase_Callback))]
	static void PurchaseCallback (string productId, string transactionId, string receiptData, int error)
	{
		Debug.Log ("productId: " + productId);
		Debug.Log ("transactionId: " + transactionId);
		Debug.Log ("receiptData: " + receiptData);
		Debug.Log ("error: " + (EPError)error);

		if (_purchaseCallback != null) {
			_purchaseCallback (productId, transactionId, receiptData, (EPError)error);
		}
	}

	public static void purchase (string productId_, SKProductPaymentType productPaymentType_, System.Action<string, string, string, EPError> cb)
	{
		_purchaseCallback = cb;
		_EasyPurchase_purchaseProductById (productId_, (int)productPaymentType_, PurchaseCallback);
	}

	public static string errMsg (EPError e)
	{
		string ret = "";
		switch (e) {
		case IOSEasyPurchase.EPError.EPErrorSuccess:
			ret = "支付成功";
			break;
		case IOSEasyPurchase.EPError.EPErrorGetProductFailed: 
			ret = "获取产品ID失败，请检查网络后再试";
			break;
		case IOSEasyPurchase.EPError.EPErrorCancelled: 
			ret = "用户取消支付";
			break;
		case IOSEasyPurchase.EPError.EPErrorClientInvalid: 
			ret = "客户端已被禁止支付，请检查隐私权限后再试";
			break;
		case IOSEasyPurchase.EPError.EPErrorPaymentInvalid:
			ret = "该产品暂时无法支付";
			break;
		case IOSEasyPurchase.EPError.EPErrorPaymentNotAllowed:
			ret = "客户端已被禁止支付，请检查隐私权限后再试";
			break;
		case IOSEasyPurchase.EPError.EPErrorProductNotAvailable:
			ret = "该产品暂时无法支付";
			break;
		case IOSEasyPurchase.EPError.EPErrorCloudServicePermissionDenied:
			ret = "云服务器权限被禁用";
			break;
		case IOSEasyPurchase.EPError.EPErrorCloudServiceNetworkConnectionFailed:
			ret = "网络异常";
			break;
		case IOSEasyPurchase.EPError.EPErrorUnknown:
			ret = "未知错误";
			break;
		case IOSEasyPurchase.EPError.EPErrorRestoreError:
			ret = "恢复购买失败";
			break;
		case IOSEasyPurchase.EPError.EPErrorRestoreGetEmptyArray:
			ret = "恢复购买返回结果为空";
			break;
		case IOSEasyPurchase.EPError.EPErrorQueueDeadLock:
			ret = "已有支付卡在列表，如此错误重复出现，请重启设备后再试";
			break;
		case IOSEasyPurchase.EPError.EPErrorTransactionDeferred:
			ret = "支付处理中，请等待苹果服务器处理，如有问题请联系客服处理";
			break;
		}
		return ret;
	}
}