// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 🌎 Project imports:
import '../../../../../generated/l10n.dart' as l;
import '../../../../core/helpers/fuctions/helper_functions.dart';
import '../../../../core/static/static.dart';
import '../../../../widgets/widgets.dart';
import '../components/_components.dart';
import '../services/_services.dart';

class AIChatDetailsView extends StatefulWidget {
  const AIChatDetailsView({super.key});

  @override
  State<AIChatDetailsView> createState() => _AIChatDetailsViewState();
}

class _AIChatDetailsViewState extends State<AIChatDetailsView> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final chatBotImage =
      'assets/images/static_images/avatars/placeholder_avatar/placeholder_avatar_06.png';

  List<MapEntry<String, bool>> messages = [];

  late final _messageEditingController = TextEditingController();
  void handleSendingMessage() {
    final _message = _messageEditingController.text;
    if (_message.isEmpty) return;
    setState(() => messages.add(MapEntry(_message, true)));
    _messageEditingController.clear();
  }

  @override
  void initState() {
    super.initState();
    messages = _mockChatData.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = l.S.of(context);
    final _theme = Theme.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _isDesktop = _mqSize.width >= 1240;
    final _isTablet = _mqSize.width >= 768 && !_isDesktop;
    final _isMobile = _mqSize.width < 768;

    const _messageFieldBorder = OutlineInputBorder(
      borderSide: BorderSide.none,
    );

    return Scaffold(
      key: scaffoldKey,
      appBar: _buildTopbar(
        context,
        showMobileDesign: _isMobile || _isTablet,
      ),
      drawer: _isMobile || _isTablet
          ? AiChatSidebar(page: AIChatPageListener.page)
          : null,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                final _message = messages.reversed.toList()[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 16),
                  child: ChatBubble(
                    isSendByMe: _message.value,
                    message: _message.key,
                    userImagePath: chatBotImage,
                  ),
                );
              },
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          //   child: TextField(
          //     controller: _messageEditingController,
          //     onSubmitted: (_) => handleSendingMessage(),
          //     decoration: InputDecoration(
          //       enabledBorder: _messageFieldBorder,
          //       focusedBorder: _messageFieldBorder,
          //       contentPadding: EdgeInsets.zero,
          //       prefixIcon: IconButton(
          //         onPressed: () {},
          //         icon: const AnimageWidget(
          //           imagePath: AcnooSVGIcons.galleryIcon,
          //         ),
          //         visualDensity: const VisualDensity(
          //           horizontal: -4,
          //           vertical: -4,
          //         ),
          //       ),
          //       hintText: 'Type a message or upload an image..',
          //       suffixIcon: Container(
          //         margin: const EdgeInsets.symmetric(vertical: 8),
          //         child: ElevatedButton.icon(
          //           onPressed: handleSendingMessage,
          //           label: const Text('Send'),
          //           style: ElevatedButton.styleFrom(
          //             padding: const EdgeInsets.symmetric(
          //               horizontal: 12,
          //               vertical: 8,
          //             ),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(4),
          //             ),
          //           ),
          //           icon: const Icon(Icons.arrow_forward_rounded),
          //           iconAlignment: IconAlignment.end,
          //         ),
          //       ),
          //     ),
          //   ),
          // )
          Container(
            decoration: BoxDecoration(
                border:
                    Border(top: BorderSide(color: _theme.colorScheme.outline))),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _messageEditingController,
              onSubmitted: (_) => handleSendingMessage(),
              decoration: InputDecoration(
                enabledBorder: _messageFieldBorder,
                focusedBorder: _messageFieldBorder,
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                prefixIcon: IconButton(
                  highlightColor: Colors.transparent,
                  onPressed: () {},
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: _theme.colorScheme.tertiaryContainer),
                    child: const AnimageWidget(
                      imagePath: AcnooSVGIcons.galleryIcon,
                    ),
                  ),
                  visualDensity: const VisualDensity(
                    horizontal: -4,
                    vertical: -4,
                  ),
                ),
                //hintText: 'Type a message or upload an image...',
                hintText: '${lang.typeAMessageOrUploadAnImage}...',
                suffixIcon: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton.icon(
                    onPressed: handleSendingMessage,
                    // label: const Text('Send'),
                    label: Text(lang.send),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_forward_rounded),
                    iconAlignment: IconAlignment.end,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  PreferredSizeWidget _buildTopbar(
    BuildContext context, {
    bool showMobileDesign = false,
  }) {
    final lang = l.S.of(context);
    final _mqSize = MediaQuery.sizeOf(context);
    final _theme = Theme.of(context);

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (showMobileDesign) ...[
            const SizedBox(width: 8),
            Align(
              alignment: Alignment.bottomCenter,
              child: IconButton(
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
                icon: Tooltip(
                  // message: 'Open Navigation menu',
                  message: lang.openNavigationMenu,
                  waitDuration: const Duration(milliseconds: 350),
                  child: const Icon(Icons.menu),
                ),
                visualDensity: const VisualDensity(horizontal: -4),
              ),
            ),
          ],
          Expanded(
            child: ListTile(
              leading: AvatarWidget(imagePath: chatBotImage),
              //title: const Text('Ai Chatbot'),
              title: Text(lang.aiChatbot),
              titleTextStyle: _theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              //subtitle: const Text('Default Bot'),
              subtitle: Text(lang.defaultBot),
              subtitleTextStyle: _theme.textTheme.bodyMedium?.copyWith(
                color: _theme.colorScheme.onTertiary,
              ),
            ),
          ),
          if (_mqSize.width < 576)
            PopupMenuButton(
              itemBuilder: (context) => {
                "Export Excel": AcnooSVGIcons.excelIcon,
                "Export CSV": AcnooSVGIcons.csvIcon,
                "Export PDF": AcnooSVGIcons.pdfIcon,
                "Print": AcnooSVGIcons.printIcon,
                "Copy": AcnooSVGIcons.copyIcon,
              }
                  .entries
                  .map(
                    (item) => PopupMenuItem(
                      value: item.key,
                      child: Row(
                        children: [
                          AnimageWidget(imagePath: item.value),
                          const SizedBox(width: 8),
                          Flexible(child: Text(item.key)),
                        ],
                      ),
                    ),
                  )
                  .toList(),
              iconColor: _theme.colorScheme.onTertiary,
              color: _theme.colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            )
          else ...const [
            FileExportButton.excel(),
            FileExportButton.csv(),
            FileExportButton.print(),
            FileExportButton.pdf(),
            FileExportButton.copy(),
            SizedBox(width: 16),
          ]
        ],
      ),
    );
  }
}

final _mockChatData = {
  "Hi! I am Sarman Yellow, and I'm Time Management Consultant. I can assist you with improving your time management skills or addressing any time management challenges you may be facing":
      false,
  "Hello, how can I assist you today?": true,
  '''
"Feeling classy and sassy with my new [product] - it's like turning my everyday into a red carpet affair! 💃✨ #GlamGoddess #OnFleek"
"Stop right there, fashion police! You can't catch me when I'm rocking my badass [product]. It's a crime to look this good! 😎🚔 #FashionCriminal #KillerStyle"
"Just call me the queen of comfort because these cozy [product] have taken over my life! Seriously, I may never wear real pants again. 🙌👑 #LivingInLuxury #ComfyQueen"
"Mirror, mirror on the wall, who's the trendiest of them all? This [product] has got me feeling like a fashionista unicorn - unique and fabulous! 🦄🔥 #UnicornVibes #FashionistaOnFleek"
"Who needs a fairy godmother when I have my [product] to turn me into a total Cinderella? Now all I need is Prince Charming and a pumpkin carriage! 🎃💫 #CinderellaVibes #DreamsDoComeTrue"
''': false,
  "Thanks": true,
  "Welcome": false,
};
