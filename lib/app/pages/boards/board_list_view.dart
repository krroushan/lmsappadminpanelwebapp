// 🎯 Dart imports:

// 🐦 Flutter imports:
import 'package:flutter/material.dart';

// 📦 Package imports:
import 'package:iconly/iconly.dart';
import 'package:responsive_framework/responsive_framework.dart' as rf;
import 'package:go_router/go_router.dart';

// 🌎 Project imports:
import '../../../../generated/l10n.dart' as l;
import '../../core/theme/_app_colors.dart';
import '../../widgets/widgets.dart';
import '../../core/api_service/board_service.dart';
import '../../models/board/board.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';

class BoardListView extends StatefulWidget {
  const BoardListView({super.key});

  @override
  State<BoardListView> createState() => _BoardListViewState();
}

class _BoardListViewState extends State<BoardListView> {
  List<Board> _boards = [];
  int _totalBoards = 0;

  bool _isLoading = true;
  final BoardService _boardService = BoardService();

  final ScrollController _scrollController = ScrollController();

  String _searchQuery = '';

  String token = '';

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchBoards();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<bool?> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Board'),
          content: const Text('Do you want to delete this board?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // No
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Yes
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteBoard(String boardId, String token) async {
    print('boardId: $boardId');
    // Show confirmation dialog before deleting
    bool? confirmDelete = await _showDeleteConfirmationDialog();
    if (confirmDelete == true) {
      try {

        await _boardService.deleteBoard(boardId, token);
        // Optionally, refresh the class list after deletion
        await _fetchBoards();
        print('Board deleted successfully');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Board deleted successfully', style: TextStyle(color: AcnooAppColors.kWhiteColor),), backgroundColor: AcnooAppColors.kSuccess,),
        );
      } catch (e) {
        // Handle error appropriately
        print('Error deleting board: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete board: $e', style: const TextStyle(color: AcnooAppColors.kWhiteColor),), backgroundColor: AcnooAppColors.kError,),
        );
      }
    }
  }

  // New method to fetch Board data from the API
  Future<void> _fetchBoards() async {
    setState(() {
      _isLoading = true;
    });
    try {
      List<Board> response = await _boardService.fetchAllBoards(token); // Fetch the response
      setState(() {
        _boards = response;
        _totalBoards = response.length;
        _isLoading = false;
      });
      
      print("aboard: ${_boards.length}");
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
      throw Exception('Failed to load boards: $e');
    }
  }

  ///_____________________________________________________________________Search_query_________________________
  void _setSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 480,
          value: _SizeInfo(
            alertFontSize: 12,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 481,
          end: 576,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
        const rf.Condition.between(
          start: 577,
          end: 992,
          value: _SizeInfo(
            alertFontSize: 14,
            padding: EdgeInsets.all(16),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    TextTheme textTheme = Theme.of(context).textTheme;
    final theme = Theme.of(context);

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: ShadowContainer(
          showHeader: false,
          contentPadding: EdgeInsets.zero,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final isMobile = constraints.maxWidth < 481;
                final isTablet =
                    constraints.maxWidth < 992 && constraints.maxWidth >= 481;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //______________________________________________________________________Header__________________
                    isMobile
                        ? Padding(
                            padding: _sizeInfo.padding,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    addUserButton(textTheme),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                searchFormField(textTheme: textTheme),
                              ],
                            ),
                          )
                        : Padding(
                            padding: _sizeInfo.padding,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: searchFormField(textTheme: textTheme),
                                ),
                                Spacer(flex: isTablet || isMobile ? 1 : 2),
                                addUserButton(textTheme),
                              ],
                            ),
                          ),

                    //______________________________________________________________________Data_table__________________
                    Padding(
                      padding: _sizeInfo.padding,
                      child: _isLoading 
                        ? const Center(child: CircularProgressIndicator())
                        : _boards.isEmpty
                          ? Center(
                              child: Text(
                                'No boards found',
                                style: textTheme.titleMedium?.copyWith(color: AcnooAppColors.kDark3),
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 3,
                              ),
                              itemCount: _boards.length,
                              itemBuilder: (context, index) {
                                final board = _boards[index];
                                return BoardCard(
                                  board: board,
                                  onEdit: () => context.go('/dashboard/boards/edit-board/${board.id}'),
                                  onDelete: () => _deleteBoard(board.id, token),
                                );
                              },
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton addUserButton(TextTheme textTheme) {
    final lang = l.S.of(context);
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
      ),
      onPressed: () {
        setState(() {
          //_showFormDialog(context);
          context.go('/dashboard/boards/add-board');
        });
      },
      label: Text(
          'Add New Board',
        style: textTheme.bodySmall?.copyWith(
          color: AcnooAppColors.kWhiteColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconAlignment: IconAlignment.start,
      icon: const Icon(
        Icons.add_circle_outline_outlined,
        color: AcnooAppColors.kWhiteColor,
        size: 20.0,
      ),
    );
  }


  ///_______________________________________________________________Search_Field___________________________________
  TextFormField searchFormField({required TextTheme textTheme}) {
    final lang = l.S.of(context);
    return TextFormField(
      decoration: InputDecoration(
        isDense: true,
        // hintText: 'Search...',
        hintText: '${lang.search}...',
        hintStyle: textTheme.bodySmall,
        suffixIcon: Container(
          margin: const EdgeInsets.all(4.0),
          decoration: BoxDecoration(
            color: AcnooAppColors.kPrimary700,
            borderRadius: BorderRadius.circular(6.0),
          ),
          child:
              const Icon(IconlyLight.search, color: AcnooAppColors.kWhiteColor),
        ),
      ),
      onChanged: (value) {
        _setSearchQuery(value);
      },
    );
  }
}

class _SizeInfo {
  final double? alertFontSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.alertFontSize = 18,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}

class BoardCard extends StatelessWidget {
  final Board board;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const BoardCard({
    super.key,
    required this.board,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AcnooAppColors.kWhiteColor,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                'https://api.ramaanya.com/uploads/boards/${board.boardImage}',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    color: AcnooAppColors.kPrimary100,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(Icons.image_not_supported, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    board.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    board.description ?? 'No description',
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AcnooAppColors.kInfo),
                  onPressed: onEdit,
                  tooltip: 'Edit Board',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AcnooAppColors.kError),
                  onPressed: onDelete,
                  tooltip: 'Delete Board',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
