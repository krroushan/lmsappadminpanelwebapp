import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/api_service/syllabus_service.dart';

class ViewPDFSyllabus extends StatefulWidget {
  final String syllabusId;
  const ViewPDFSyllabus({super.key, required this.syllabusId});

  @override
  State<ViewPDFSyllabus> createState() => _ViewPDFSyllabusState();
}

class _ViewPDFSyllabusState extends State<ViewPDFSyllabus> {
  var logger = Logger();
  String token = '';
  String pdfUrl = '';
  final _pdfViewerController = PdfViewerController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.checkAuthentication();
    token = authProvider.getToken;
    _fetchSyllabus();
    logger.d('syllabusId: ${widget.syllabusId}');
  }

  Future<void> _fetchSyllabus() async {
    final syllabusService = SyllabusService();
    final syllabus = await syllabusService.fetchSyllabusById(widget.syllabusId, token);
    setState(() {
      pdfUrl = 'https://api.ramaanya.com/uploads/syllabuses/${syllabus.fileUrl}';
      isLoading = false;
    });
    logger.d('syllabus: ${syllabus.fileUrl}');
    logger.d('https://api.ramaanya.com/uploads/syllabuses/$pdfUrl');
  }

  @override
  Widget build(BuildContext context) {
    const _lg = 6;
    const _md = 6;

    final _sizeInfo = rf.ResponsiveValue<_SizeInfo>(
      context,
      conditionalValues: [
        const rf.Condition.between(
          start: 0,
          end: 992,
          value: _SizeInfo(
            fonstSize: 12,
            padding: EdgeInsets.all(0),
            innerSpacing: 16,
          ),
        ),
      ],
      defaultValue: const _SizeInfo(),
    ).value;

    return Scaffold(
      body: Padding(
        padding: _sizeInfo.padding,
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : ShadowContainer(
                headerText: 'Pdf Viewer',
                child: SfPdfViewer.network(
                  pdfUrl,
                  controller: _pdfViewerController,
                  onDocumentLoaded: (details) {
                    logger.d('https://api.ramaanya.com/uploads/study-materials/pdfs/$pdfUrl');
                  },
                ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class _SizeInfo {
  final double? fonstSize;
  final EdgeInsetsGeometry padding;
  final double innerSpacing;
  const _SizeInfo({
    this.fonstSize,
    this.padding = const EdgeInsets.all(24),
    this.innerSpacing = 24,
  });
}
