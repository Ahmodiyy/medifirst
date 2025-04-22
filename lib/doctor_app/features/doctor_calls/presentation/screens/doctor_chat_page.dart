import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:medifirst/models/appointment_info.dart';
import 'package:medifirst/core/theming/palette.dart';

import '../../../../../features/auth/controller/auth_controller.dart';
import '../../../../../models/doctor_info.dart';
import 'doctor_video_call_screen.dart';
import 'doctor_voice_call_screen.dart';


class DoctorChatPage extends ConsumerStatefulWidget {
  final AppointmentInfo appt;
  const DoctorChatPage({
    super.key,
    required this.appt,
  });

  @override
  ConsumerState<DoctorChatPage> createState() => _DoctorChatPageState();
}

class _DoctorChatPageState extends ConsumerState<DoctorChatPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _messageController = TextEditingController();
  late DoctorInfo _user;
  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  void _initializeUser() async {
    final doctorInfo = ref.read(doctorProvider);
    _user = doctorInfo!;
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _buildChatMessages(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => Navigator.pop(context),
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: NetworkImage(widget.appt.patientImageURL),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.appt.patientName,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          IconButton(
            icon: Icon(Icons.phone_outlined, color: Palette.mainGreen),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DoctorVoiceCallScreen(
                              appt: widget.appt)));
            },
          ),
          IconButton(
            icon: Icon(Icons.videocam_outlined, color: Palette.mainGreen),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          DoctorVideoCallScreen(
                              appt: widget.appt)));
            },
          ),

        ],
      ),
    );
  }

  Widget _buildChatMessages() {
    return StreamBuilder<QuerySnapshot>(
      stream:  _firestore.collection('messages')
          .doc(widget.appt.aID)
          .collection('chat_messages')
          .orderBy('createdAt', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No messages yet'));
        }

        List<DocumentSnapshot> docs = snapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: docs.length,
          itemBuilder: (context, index) {
            return _buildMessageItem(docs[index]);
          },
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    print('status of this document is : ${doc['status']}');
    bool isMe = data['userId'] == _user?.doctorId;
    Timestamp? timestamp = data['createdAt'] as Timestamp?;
    String time = timestamp != null
        ? DateFormat('HH:mm').format(timestamp.toDate())
        : '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(

        crossAxisAlignment:  isMe ? CrossAxisAlignment.end: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(
              top: 8,
              bottom: 8,
              left: isMe ? 64 : 0,
              right: isMe ? 0 : 64,
            ),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isMe ? Color(0xFF6A9E6C) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (data['text'] != null)
                  Text(
                    data['text'],
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      color: isMe ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                if (data['imageUrl'] != null && data['status'] == 'uploading')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      height: 200,
                      width: 200,
                      color: Palette.whiteColor,
                      child: Center(
                        child: SizedBox(
                          height: 50, // Increase size of the indicator
                          width: 50,
                          child: CircularProgressIndicator(
                            color: Palette.mainGreen,
                            strokeWidth: 5, // Optional: Adjust thickness
                          ),
                        ),
                      ),
                    ),
                  ),
                if (data['imageUrl'] != null && data['status']=='uploaded')
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      data['imageUrl'],
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            color: Palette.whiteColor,
                            width: 200,
                            height: 200,
                            child: Center(
                              child: SizedBox(
                                height: 50,
                                width: 50,
                                child: CircularProgressIndicator(
                                  color: Palette.mainGreen,
                                  strokeWidth: 5,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / (loadingProgress.expectedTotalBytes ?? 1)
                                      : null,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 200,
                            width: 200,
                            color: Palette.whiteColor,
                            child: Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 50,
                            ),
                          ),
                        );
                      },
                    )
                  ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: _showAttachmentOptions,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                color: Palette.mainGreen,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: _sendTextMessage,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo),
                title: Text('Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: source);

    if (image != null) {
      File file = File(image.path);
      await _uploadFile(file, 'images');
    }
  }

  Future<void> _uploadFile(File file, String folder) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('chat-$folder/$fileName');
    String tempImageUrl = "uploading";
   DocumentReference messageDocument = await _sendMessage(imageUrl: tempImageUrl, status: tempImageUrl);
    UploadTask uploadTask = storageRef.putFile(file);
    try {
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      _updateMessageWithImageUrl(messageDocument.id, downloadUrl);
    } catch (e) {
      print("Upload failed: $e");
      //Update message with "failed" status
      _updateMessageWithError(messageDocument.id);
    }
  }

// Function to update the message with the final image URL
  void _updateMessageWithImageUrl(String messageId, String imageUrl) {
    _firestore.collection('messages').doc(widget.appt.aID).collection('chat_messages').doc(messageId).update({
      'imageUrl': imageUrl,
      'status': 'uploaded', // Update status
    });
  }

// Function to mark the message as "failed" in case of upload errors
  void _updateMessageWithError(String messageId) {
    _firestore.collection('messages').doc(widget.appt.aID).collection('chat_messages').doc(messageId).update({
      'status': 'failed',
    });
  }
  void _sendTextMessage() {
    if (_messageController.text.isNotEmpty) {
      _sendMessage(text: _messageController.text);
      _messageController.clear();
    }
  }

  Future<DocumentReference> _sendMessage({String? text, String? imageUrl, String? audioUrl, String? status}) async {
    return await _firestore.collection('messages').doc(widget.appt.aID).collection('chat_messages').add({
      'text': text,
      'imageUrl': imageUrl,
      'audioUrl': audioUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'userId': _user.doctorId,
      'userName': _user.name ?? 'Anonymous',
      'status': status,
    });

  }


  @override
  void dispose() {
    super.dispose();
  }
}
