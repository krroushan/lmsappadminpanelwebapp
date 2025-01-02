// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;

// 🌎 Project imports:
import '../../../generated/l10n.dart' as l;
import '../../core/theme/theme.dart';
import '../../models/_chat_model.dart';
import '../../widgets/widgets.dart';

part 'components/_user_list.dart';
part 'components/_chat_screen.dart';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> with TickerProviderStateMixin {
  final List<UserModel> users = MaanDemoGig.usersList;
  late List<UserModel> filteredUsers;
  late TextEditingController searchController;
  String? selectedUser;
  final ScrollController scrollController = ScrollController();
  late final messageEditingController = TextEditingController();
  late FocusNode msgFocus;
  List<ChatModel> messages = DemoChat.chatList;
  late final _tabController = TabController(length: 3, vsync: this);

  @override
  void initState() {
    super.initState();
    filteredUsers = users;
    searchController = TextEditingController()..addListener(filterUsers);
    msgFocus = FocusNode()
      ..addListener(() {
        if (msgFocus.hasFocus) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      });
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        filterUsersByTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    msgFocus.dispose();
    messageEditingController.dispose();
    scrollController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void filterUsers() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredUsers = users.where((user) {
        return user.influencerName.toLowerCase().contains(query);
      }).toList();
    });
  }

  void filterUsersByTab(int tabIndex) {
    setState(() {
      if (tabIndex == 0) {
        filteredUsers = users.where((user) => !user.isGroup).toList();
      } else if (tabIndex == 1) {
        filteredUsers = users.where((user) => user.isGroup).toList();
      } else {
        filteredUsers = users;
      }
    });
  }

  void sendMsg() {
    if (messageEditingController.text.isNotEmpty) {
      setState(() {
        messages.add(ChatModel(
            text: messageEditingController.text,
            date: DateTime.now(),
            isSentByMe: true));
        messageEditingController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final sizeInfo = _getSizeInfo(context);
    final isMobileOrTablet = _isMobileOrTablet(context);

    return Padding(
      padding: sizeInfo.padding / 1.5,
      child: isMobileOrTablet
          ? _buildMobileView(sizeInfo)
          : _buildDesktopView(sizeInfo),
    );
  }

  Widget _buildMobileView(_SizeInfo sizeInfo) {
    return Scaffold(
      body: UserList(
        filteredUsers: filteredUsers,
        selectedUser: selectedUser,
        searchController: searchController,
        onUserTap: (user) {
          setState(() {
            selectedUser = user.influencerName;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatScreen(receiver: user),
            ),
          );
        },
        tabController: _tabController,
      ),
    );
  }

  Widget _buildDesktopView(_SizeInfo sizeInfo) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildTabBarAndUserList()),
        SizedBox(width: sizeInfo.innerSpacing / 1.5),
        Expanded(flex: 12, child: _buildChatScreen()),
      ],
    );
  }

  Widget _buildTabBarAndUserList() {
    return UserList(
      filteredUsers: filteredUsers,
      selectedUser: selectedUser,
      searchController: searchController,
      onUserTap: (user) {
        setState(() {
          selectedUser = user.influencerName;
        });
      },
      tabController: _tabController,
    );
  }

  Widget _buildChatScreen() {
    final lang = l.S.of(context);
    if (selectedUser == null ||
        !filteredUsers.any((user) => user.influencerName == selectedUser)) {
      //  return const Center(child: Text('Select a user to start chatting'));
      return Center(child: Text(lang.selectAUserToStartChatting));
    }
    return ShadowContainer(
      contentPadding: EdgeInsets.zero,
      showHeader: false,
      child: ChatScreen(
          receiver: filteredUsers
              .firstWhere((user) => user.influencerName == selectedUser)),
    );
  }

  bool _isMobileOrTablet(BuildContext context) {
    return rf.ResponsiveValue<bool>(
      context,
      conditionalValues: const [
        rf.Condition.between(start: 0, end: 1023, value: true)
      ],
      defaultValue: false,
    ).value;
  }

  _SizeInfo _getSizeInfo(BuildContext context) {
    return rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
            start: 0,
            end: 599,
            value: _SizeInfo(
                alertFontSize: 12,
                padding: EdgeInsets.all(16),
                innerSpacing: 16)),
        const rf.Condition.between(
            start: 600,
            end: 1023,
            value: _SizeInfo(
                alertFontSize: 16,
                padding: EdgeInsets.all(20),
                innerSpacing: 20)),
        const rf.Condition.between(
            start: 1024,
            end: 9999,
            value: _SizeInfo(
                alertFontSize: 18,
                padding: EdgeInsets.all(24),
                innerSpacing: 24)),
      ],
      defaultValue: const _SizeInfo(),
    ).value;
  }
}

class _SizeInfo {
  final double alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;

  const _SizeInfo({
    this.alertFontSize = 16,
    this.padding = EdgeInsets.zero,
    this.innerSpacing = 8.0,
  });
}
