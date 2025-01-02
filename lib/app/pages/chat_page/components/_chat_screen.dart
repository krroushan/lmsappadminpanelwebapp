part of '../chat_view.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    super.key,
    required this.receiver,
  });

  final UserModel receiver;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageEditingController =
      TextEditingController();

  List<ChatModel> messages = DemoChat.chatList;
//---------For sending text msg----------//
  void sendMsg() {
    if (messageEditingController.text.isNotEmpty) {
      setState(
        () {
          messages.add(ChatModel(
              text: messageEditingController.text,
              date: DateTime.now(),
              isSentByMe: true));
          messageEditingController.clear();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        chatHeader(),
        _buildMessageList(),
        _buildInputField(),
      ],
    );
  }

  ///__________________________________________________________chat_screen_header____________________________________
  Widget chatHeader() {
    // List<ChatModel> messages = DemoChat.chatList;
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12.0),
          topRight: Radius.circular(12.0),
        ),
        color: _theme.colorScheme.primaryContainer,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withOpacity(0.08),
            blurRadius: 24.0,
            spreadRadius: 0.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        visualDensity: VisualDensity.standard,
        contentPadding: EdgeInsets.zero,
        horizontalTitleGap: 8.0,
        dense: true,
        leading: _userProfileImage(),
        title: Text(
          widget.receiver.influencerName,
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Text(
          lang.active,
          // 'Active',
          style: textTheme.bodySmall,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        trailing: _popUpMenu(),
      ),
    );
  }

  ///__________________________________________________________User_Img____________________________________
  Widget _userProfileImage() {
    return SizedBox(
      height: 40,
      width: 40,
      child: AvatarWidget(
          fit: BoxFit.cover,
          isActive: true,
          imagePath: widget.receiver.influencerImage),
    );
  }

  ///__________________________________________________________Popup_Menu__________________________________
  Widget _popUpMenu() {
    final lang = l.S.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    return PopupMenuButton(
      icon: const Icon(Icons.more_horiz_outlined),
      offset: const Offset(-10, 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      itemBuilder: (context) => [
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              const Icon(IconlyLight.add_user),
              const SizedBox(width: 10.0),
              Text(
                lang.createNewGroup,
                //'Create New Group',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Icon(MdiIcons.trashCanOutline),
              const SizedBox(width: 10.0),
              Text(
                lang.deleteConversation,
                // 'Delete Conversation  ',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          onTap: () {},
          child: Row(
            children: [
              Icon(MdiIcons.accountCancelOutline),
              const SizedBox(width: 10.0),
              Text(
                lang.blockReport,
                //'Block & Report',
                style: textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///__________________________________________________________Msg_List____________________________________
  Widget _buildMessageList() {
    final ScrollController customScrollController = ScrollController();
    List<ChatModel> messages = DemoChat.chatList;
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        controller: customScrollController,
        itemCount: messages.length,
        itemBuilder: (context, index) {
          ChatModel data = messages[index];

          DateTime prev = index != messages.length - 1
              ? messages[index + 1].date
              : messages[index].date;
          DateTime presn = messages[index].date;

          bool showTime = presn.difference(prev).inMinutes != 0 ||
              index == messages.length - 1;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: data.isSentByMe
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: data.isSentByMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  if (data.text != null)
                    _buildMessageBubble(data, showTime)
                  else
                    _bupImageBubble(data),
                  if (showTime)
                    _chatTimestamp(data)
                  else
                    const SizedBox(height: 16),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  ///__________________________________________________________MessageBubble_______________________________
  Widget _buildMessageBubble(ChatModel data, bool showTime) {
    final _theme = Theme.of(context);
    TextTheme textTheme = Theme.of(context).textTheme;
    bool isDark = Theme.of(context).colorScheme.brightness == Brightness.dark;
    return Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: data.isSentByMe
            ? _theme.colorScheme.surface
            : AcnooAppColors.kPrimary600,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: data.isSentByMe
              ? const Radius.circular(20)
              : const Radius.circular(0),
          bottomRight: data.isSentByMe
              ? const Radius.circular(0)
              : const Radius.circular(20),
        ),
      ),
      child: Text(
        data.text!,
        softWrap: true,
        overflow: TextOverflow.visible,
        style: textTheme.bodyMedium?.copyWith(
          color: data.isSentByMe
              ? isDark
                  ? AcnooAppColors.kNeutral200
                  : AcnooAppColors.kNeutral700
              : Colors.white,
        ),
      ),
    );
  }

  ///__________________________________________________________upload_img_icon_____________________________
  Widget _bupImageBubble(ChatModel data) {
    return Container(
      height: 92,
      width: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: FileImage(data.file!),
        ),
      ),
    );
  }

  ///___________________________________________________________chatTime_stamp_____________________________
  Widget _chatTimestamp(ChatModel data) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 16),
      child: Text(
        DateFormat('hh:mm a').format(data.date),
        style: textTheme.bodySmall,
      ),
    );
  }

  ///___________________________________________________________input_fields_______________________________
  Widget _buildInputField() {
    final _theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: _theme.colorScheme.primaryContainer,
        border: Border(
          top: BorderSide(
            color: _theme.colorScheme.outline,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSendButton(),
          _buildTextInput(),
        ],
      ),
    );
  }

  ///____________________________________________________________SendButton________________________________
  Widget _buildSendButton() {
    return IconButton(
      padding: EdgeInsets.zero,
      onPressed: sendMsg,
      icon: Container(
        padding: const EdgeInsets.all(12.0),
        margin: const EdgeInsets.all(13.0),
        decoration: BoxDecoration(
          color: AcnooAppColors.kPrimary200.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Transform.rotate(
          angle: 130 * (3.1415926535897932 / 180),
          child: const Icon(
            Icons.link,
            color: AcnooAppColors.kPrimary600,
          ),
        ),
      ),
    );
  }

  ///____________________________________________________________TextField______________________________
  Widget _buildTextInput() {
    final lang = l.S.of(context);
    final _borderType = OutlineInputBorder(
      borderRadius: BorderRadius.circular(8.0),
      borderSide: BorderSide.none,
    );
    TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      child: TextFormField(
        controller: messageEditingController,
        textAlignVertical: TextAlignVertical.center,
        onFieldSubmitted: (value) => sendMsg(),
        decoration: InputDecoration(
          suffixIcon: Padding(
            padding: const EdgeInsets.all(5.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              ),
              onPressed: sendMsg,
              label: Text(
                lang.submit,
                //'Submit',
                style: textTheme.bodyLarge?.copyWith(
                  color: AcnooAppColors.kWhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              iconAlignment: IconAlignment.end,
              icon: const Icon(
                IconlyLight.send,
                color: AcnooAppColors.kWhiteColor,
                size: 20.0,
              ),
            ),
          ),
          //hintText: 'Type here...',
          hintText: '${lang.typeHere}...',
          hintStyle: const TextStyle(color: Colors.grey),
          filled: true,
          enabledBorder: _borderType,
          focusedBorder: _borderType,
          errorBorder: _borderType,
          focusedErrorBorder: _borderType,
        ),
      ),
    );
  }
}
