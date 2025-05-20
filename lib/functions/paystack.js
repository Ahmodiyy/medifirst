//const functions = require("firebase-functions");
//const axios = require("axios");
//
//// Replace with your Paystack secret key
//const PAYSTACK_SECRET_KEY = 'your_paystack_secret_key';
//
//exports.initiatePaystackPayment = functions.https.onCall(async (data, context) => {
//  const { amount, email } = data;
//
//  try {
//    // Initiate payment
//    const response = await axios.post("https://api.paystack.co/transaction/initialize", {
//      amount: amount * 100, // Paystack expects amount in kobo
//      email: email
//    }, {
//      headers: {
//        Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`,
//        "Content-Type": "application/json"
//      }
//    });
//
//    return {
//      success: true,
//      data: response.data.data
//    };
//  } catch (error) {
//    console.error("Error initiating Paystack payment:", error);
//    return {
//      success: false,
//      error: error.message
//    };
//  }
//});
//
//exports.verifyPaystackPayment = functions.https.onCall(async (data, context) => {
//  const { reference } = data;
//
//  try {
//    // Verify payment
//    const response = await axios.get(`https://api.paystack.co/transaction/verify/${reference}`, {
//      headers: {
//        Authorization: `Bearer ${PAYSTACK_SECRET_KEY}`
//      }
//    });
//
//    if (response.data.data.status === "success") {
//      // Payment successful, update your database or perform other actions here
//      return {
//        success: true,
//        data: response.data.data
//      };
//    } else {
//      return {
//        success: false,
//        error: "Payment not successful"
//      };
//    }
//  } catch (error) {
//    console.error("Error verifying Paystack payment:", error);
//    return {
//      success: false,
//      error: error.message
//    };
//  }
//});