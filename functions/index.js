/* eslint-disable indent */
const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addChatMessage = functions.firestore
    .document("/privateChats/{privateChatId}/messages/{messageId}")
    .onCreate(async (snapshot, context) => {
        const privateChatId = context.params.privateChatId;
        const chatRef = admin.firestore().collectionGroup("privateChats")
            .document(privateChatId);
        const messageData = snapshot.data();
        const chatDoc = await chatRef.get();
        const chatData = chatDoc.data();

        if (chatDoc.exists) {
            const readStatus = chatData.readStatus;
            for (const userId in readStatus) {
                // eslint-disable-next-line no-prototype-builtins
                if (readStatus.hasOwnProperty(userId) &&
                    userId !== messageData.senderId) {
                    readStatus[userId] = false;
                }
            }
            chatRef.update({
                recentMessage: messageData.text,
                recentSender: messageData.senderId,
                recentTimestamp: messageData.timestamp,
                readStatus: readStatus,
            });
        }
    });

exports.onUpdateUser = functions.firestore.document("/users/{userId}").
    onUpdate(async (snapshot, context) => {
        const userId = context.params.userId;
        const upatedUserData = snapshot.after.data();
        const userRoomsRef = admin.firestore().collection("rooms").
            where("memberIds", "array-contains", userId);
        const userRoomsSnapshot = await userRoomsRef.get();

        userRoomsSnapshot.forEach(async (doc) => {
            console.log(doc.id);
            const roomRef = admin.firestore().collection("rooms").doc(doc.id);
            const roomDoc = await roomRef.get();
            if (roomDoc.exists) {
                const memberInfo = roomDoc.data().memberInfo;
                memberInfo[userId]["name"] = upatedUserData.name;
                memberInfo[userId]["imageUrl"] = upatedUserData.profileImageUrl;
                roomRef.update({
                    memberInfo: memberInfo,
                });
            }
        });
    },
    );


// exports.onLikeMessage = functions.firestore
//     .document("/privateChats/{privateChatId}/messages/{messageId}")
//     .onUpdate(async (snapshot, context) => {
//         const privateChatId = context.params.privateChatId;
//         const messageId = context.params.messageId;
//         const messageRef = admin.firestore().collectionGroup("privateChats")
//             .document(privateChatId).collectionGroup("messages").
//             document(messageId);
//         const messageDoc = await messageRef.get();
//         const messageData = messageDoc.data();

//         if (messageDoc.exists) {
//             const isLiked = messageData.isLiked;
//             messageRef.update({
//                 isLiked: isLiked,
//             });
//         }
//     });
