import 'package:flutter/material.dart';

// Differentiates between a user message and an AI message
enum ChatMessageType { user, ai }

class ChatMessageModel {
  final String id;
  final String text;
  final ChatMessageType type;
  // This will hold our special chart widget
  final Widget? customContent; 

  ChatMessageModel({
    required this.id,
    required this.text,
    required this.type,
    this.customContent,
  });
}