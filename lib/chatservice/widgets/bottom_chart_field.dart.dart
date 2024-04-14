// ignore_for_file: use_build_context_synchronously

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecomm/chatservice/controller/chat_controller.dart';
import 'package:ecomm/chatservice/widgets/message_reply_preview.dart';
import 'package:ecomm/models/message_enum.dart';
import 'package:ecomm/models/message_reply_provider.dart';
import 'package:ecomm/models/messeger.dart';
import 'package:ecomm/models/user.dart';
import 'package:ecomm/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  final bool isGroupChat;
  const BottomChatField({
    Key? key,
    required this.recieverUserId,
    required this.isGroupChat,
  }) : super(key: key);

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool isShowSendButton = false;
  final TextEditingController _messageController = TextEditingController();
  bool isRecorderInit = false;
  bool isShowEmojiContainer = false;
  bool isRecording = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  addusertomessagers() async {
    var receiversnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.recieverUserId)
        .get();

    var receiverdata = UserModel.fromSnapShot(receiversnap);

    var timeSent = DateTime.now();

    var messagerChatContact = Messager(
      name: receiverdata.username,
      contactId: receiverdata.uid,
      timeSent: timeSent,
      lastMessage: _messageController.text.trim(),
    );

    var sendermessagerDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messagers")
        .doc(widget.recieverUserId)
        .get();

    if (!sendermessagerDoc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("messagers")
          .doc(widget.recieverUserId)
          .set(messagerChatContact.toMap());
    }
    var receivermessagerDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.recieverUserId)
        .collection("messagers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!receivermessagerDoc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.recieverUserId)
          .collection("messagers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(messagerChatContact.toMap());
    }
  }

  addmessenger() async {
// +++++++++++++++++++++++++++++++ sender +++++++++++++++++++++++++++++++++++++++

    var sendersnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    var senderdata = UserModel.fromMap(sendersnap.data()!);

    var timeSent = DateTime.now();

    var senderChatContact = Messager(
      name: senderdata.username,
      contactId: senderdata.uid,
      timeSent: timeSent,
      lastMessage: _messageController.text.trim(),
    );

// +++++++++++++++++++++++++++++++ sender +++++++++++++++++++++++++++++++++++++++

    var receiversnap = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.recieverUserId)
        .get();

    var receiverdata = UserModel.fromMap(receiversnap.data()!);

    var receiverChatContact = Messager(
      name: receiverdata.username,
      contactId: receiverdata.uid,
      timeSent: timeSent,
      lastMessage: _messageController.text.trim(),
    );

    var sendermessagerDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("messagers")
        .doc(widget.recieverUserId)
        .get();

    if (!sendermessagerDoc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("messagers")
          .doc(widget.recieverUserId)
          .set(receiverChatContact.toMap());
    }
    var receivermessagerDoc = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.recieverUserId)
        .collection("messagers")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!receivermessagerDoc.exists) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(widget.recieverUserId)
          .collection("messagers")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set(senderChatContact.toMap());
    }
  }

  void sendTextMessage() async {
    ref.read(chatControllerProvider).sendTextMessage(
          context,
          _messageController.text.trim(),
          widget.recieverUserId,
          widget.isGroupChat,
        );
    setState(() {
      _messageController.text = '';
    });
    // addusertomessagers();
    addmessenger();
  }

  void sendFileMessage(
    File file,
    MessageEnum messageEnum,
  ) {
    ref.read(chatControllerProvider).sendFileMessage(
          context,
          file,
          widget.recieverUserId,
          messageEnum,
          widget.isGroupChat,
        );
  }

  void selectImage() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFileMessage(image, MessageEnum.image);
    }
  }

  void selectVideo() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFileMessage(video, MessageEnum.video);
    }
  }

  void hideEmojiContainer() {
    setState(() {
      isShowEmojiContainer = false;
    });
  }

  void showEmojiContainer() {
    setState(() {
      isShowEmojiContainer = true;
    });
  }

  void showKeyboard() => focusNode.requestFocus();
  void hideKeyboard() => focusNode.unfocus();

  void toggleEmojiKeyboardContainer() {
    if (isShowEmojiContainer) {
      showKeyboard();
      hideEmojiContainer();
    } else {
      hideKeyboard();
      showEmojiContainer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
    isRecorderInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final messageReply = ref.watch(messageReplyProvider);
    final isShowMessageReply = messageReply != null;
    return Column(
      children: [
        isShowMessageReply ? const MessageReplyPreview() : const SizedBox(),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                focusNode: focusNode,
                controller: _messageController,
                onChanged: (val) {
                  if (val.isNotEmpty) {
                    setState(() {
                      isShowSendButton = true;
                    });
                  } else {
                    setState(() {
                      isShowSendButton = false;
                    });
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: toggleEmojiKeyboardContainer,
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          onPressed: selectImage,
                          icon: const Icon(
                            Icons.camera_alt,
                            color: Colors.grey,
                          ),
                        ),
                        IconButton(
                          onPressed: selectVideo,
                          icon: const Icon(
                            Icons.attach_file,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  hintText: 'Type a message!',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(10),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                right: 2,
                left: 2,
              ),
              child: CircleAvatar(
                backgroundColor: const Color(0xFF128C7E),
                radius: 25,
                child: GestureDetector(
                  onTap: sendTextMessage,
                  child: Icon(
                    isShowSendButton
                        ? Icons.send
                        : isRecording
                            ? Icons.close
                            : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        isShowEmojiContainer
            ? SizedBox(
                height: 310,
                child: EmojiPicker(
                  onEmojiSelected: ((category, emoji) {
                    setState(() {
                      _messageController.text =
                          _messageController.text + emoji.emoji;
                    });

                    if (!isShowSendButton) {
                      setState(() {
                        isShowSendButton = true;
                      });
                    }
                  }),
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}
