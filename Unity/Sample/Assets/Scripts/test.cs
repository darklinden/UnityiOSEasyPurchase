using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class test : MonoBehaviour
{

	// Use this for initialization
	void Start ()
	{
		
	}
	
	// Update is called once per frame
	void Update ()
	{
		
	}

	public void ZZTest ()
	{
		IOSEasyPurchase.purchase ("123456", IOSEasyPurchase.SKProductPaymentType.SKProductPaymentTypeConsumable, 
			(string productId, string transactionId, string receiptData, IOSEasyPurchase.EPError error) => {
				Debug.Log (IOSEasyPurchase.errMsg (error));
			});
	}
}
