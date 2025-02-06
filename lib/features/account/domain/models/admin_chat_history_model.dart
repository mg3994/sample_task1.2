// To parse this JSON data, do
//
//     final adminChatHistoryModel = adminChatHistoryModelFromJson(jsonString);

import 'dart:convert';

AdminChatHistoryModel adminChatHistoryModelFromJson(String str) => AdminChatHistoryModel.fromJson(json.decode(str));

class AdminChatHistoryModel {
    bool success;
    AdminChatHistoryData data;

    AdminChatHistoryModel({
        required this.success,
        required this.data,
    });

    factory AdminChatHistoryModel.fromJson(Map<String, dynamic> json) => AdminChatHistoryModel(
        success: json["success"],
        data: AdminChatHistoryData.fromJson(json["data"]),
    );
}

class AdminChatHistoryData {
    List<Conversation> conversation;
    int newChat;
    String conversationId;
    int count;

    AdminChatHistoryData({
        required this.conversation,
        required this.newChat,
        required this.conversationId,
        required this.count,
    });

    factory AdminChatHistoryData.fromJson(Map<String, dynamic> json) => AdminChatHistoryData(
        conversation: List<Conversation>.from(json["conversation"].map((x) => Conversation.fromJson(x))),
        newChat: json["new_chat"]??0,
        conversationId: json["conversation_id"]??'',
        count: json["count"]??0,
    );
}

class Conversation {
    String id;
    String conversationId;
    String senderId;
    int unseenCount;
    String senderType;
    String content;
    String createdAt;
    String updatedAt;
    String userTimezone;

    Conversation({
        required this.id,
        required this.conversationId,
        required this.senderId,
        required this.unseenCount,
        required this.senderType,
        required this.content,
        required this.createdAt,
        required this.updatedAt,
        required this.userTimezone,
    });

    factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
        id: json["id"]??'',
        conversationId: json["conversation_id"]??'',
        senderId: json["sender_id"]??'',
        unseenCount: json["unseen_count"]??0,
        senderType: json["sender_type"]??'',
        content: json["content"]??'',
        createdAt: json["created_at"]??'',
        updatedAt: json["updated_at"]??'',
        userTimezone: json["user_timezone"]??'',
    );
}










// // To parse this JSON data, do
// //
// //     final adminChatHistoryModel = adminChatHistoryModelFromJson(jsonString);

// import 'dart:convert';

// AdminChatHistoryModel adminChatHistoryModelFromJson(String str) => AdminChatHistoryModel.fromJson(json.decode(str));


// class AdminChatHistoryModel {
//     bool success;
//     AdminChatHistoryData data;

//     AdminChatHistoryModel({
//         required this.success,
//         required this.data,
//     });

//     factory AdminChatHistoryModel.fromJson(Map<String, dynamic> json) => AdminChatHistoryModel(
//         success: json["success"],
//         data: AdminChatHistoryData.fromJson(json["data"]),
//     );
// }

// class AdminChatHistoryData {
//     List<AdminChatHistoryDetails> chats;
//     int newChat;
//     String chatId;
//     int count;

//     AdminChatHistoryData({
//         required this.chats,
//         required this.newChat,
//         required this.chatId,
//         required this.count,
//     });

//     factory AdminChatHistoryData.fromJson(Map<String, dynamic> json) => AdminChatHistoryData(
//         chats: List<AdminChatHistoryDetails>.from(json["chats"].map((x) => AdminChatHistoryDetails.fromJson(x))),
//         newChat: json["new_chat"],
//         chatId: json["chat_id"],
//         count: json["count"],
//     );

// }

// class AdminChatHistoryDetails {
//     int id;
//     String chatId;
//     int fromId;
//     int toId;
//     String message;
//     int imageStatus;
//     dynamic imageUrl;
//     int unseenCount;
//     String createdAt;
//     String updatedAt;
//     String userTimezone;

//     AdminChatHistoryDetails({
//         required this.id,
//         required this.chatId,
//         required this.fromId,
//         required this.toId,
//         required this.message,
//         required this.imageStatus,
//         required this.imageUrl,
//         required this.unseenCount,
//         required this.createdAt,
//         required this.updatedAt,
//         required this.userTimezone,
//     });

//     factory AdminChatHistoryDetails.fromJson(Map<String, dynamic> json) => AdminChatHistoryDetails(
//         id: json["id"]??0,
//         chatId: json["chat_id"]??'',
//         fromId: json["from_id"]??0,
//         toId: json["to_id"]??0,
//         message: json["message"]??'',
//         imageStatus: json["image_status"]??0,
//         imageUrl: json["image_url"]??'',
//         unseenCount: json["unseen_count"]??0,
//         createdAt: json["created_at"]??'',
//         updatedAt: json["updated_at"]??'',
//         userTimezone: json["user_timezone"]??'',
//     );
// }
