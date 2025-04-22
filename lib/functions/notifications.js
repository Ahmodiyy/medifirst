const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendCallNotification = functions.firestore
    .document("calls/{callId}")
    .onCreate(async (snapshot, context) => {
        const callData = snapshot.data();
        const calleeId = callData.callee;

        // Get the callee's FCM token
        const calleeDoc = await admin.firestore().collection('users').doc(calleeId).get();
        const fcmToken = calleeDoc.data().fcmToken;

        if (fcmToken) {
            const message = {
                token: fcmToken,
                data: {
                    type: 'call',
                    callId: context.params.callId,
                    caller: callData.caller,
                },
                android: {
                    priority: 'high',
                },
                apns: {
                    payload: {
                        aps: {
                            contentAvailable: true,
                        },
                    },
                },
            };

            try {
                await admin.messaging().send(message);
                console.log('Call notification sent successfully');
            } catch (error) {
                console.error('Error sending call notification:', error);
            }
        }
    });

exports.sendVideoCallNotification = functions.firestore
    .document("video_calls/{callId}")
    .onCreate(async (snapshot, context) => {
        const callData = snapshot.data();
        const calleeId = callData.callee;

        // Get the callee's FCM token
        const calleeDoc = await admin.firestore().collection("users").doc(calleeId).get();
        const fcmToken = calleeDoc.data().fcmToken;

        if (fcmToken) {
            const message = {
                token: fcmToken,
                data: {
                    type: "video_call",
                    callId: context.params.callId,
                    caller: callData.caller,
                    callerName: callData.callerName, // Include caller's name if available
                },
                android: {
                    priority: "high",
                },
                apns: {
                    payload: {
                        aps: {
                            contentAvailable: true,
                        },
                    },
                },
            };

            try {
                await admin.messaging().send(message);
                console.log("Video call notification sent successfully");
            } catch (error) {
                console.error("Error sending video call notification:", error);
            }
        }
    });