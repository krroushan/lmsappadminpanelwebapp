import 'package:flutter/material.dart';
// 📦 Package imports:
import 'package:responsive_framework/responsive_framework.dart' as rf;
// 🌎 Project imports:
import '../../widgets/widgets.dart';
import '../../providers/_auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:logger/logger.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../core/api_service/study_material_service.dart';

class SMPDFViewer extends StatefulWidget {
  final String smId;
  const SMPDFViewer({super.key, required this.smId});

  @override
  State<SMPDFViewer> createState() => _SMPDFViewerState();
}

class _SMPDFViewerState extends State<SMPDFViewer> {
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
    _fetchStudyMaterial();
    logger.d('smId: ${widget.smId}');
  }

  Future<void> _fetchStudyMaterial() async {
    final studyMaterialService = StudyMaterialService();
    final studyMaterial = await studyMaterialService.fetchStudyMaterialById(widget.smId, token);
    setState(() {
      pdfUrl = 'https://api.ramaanya.com/uploads/study-materials/pdfs/${studyMaterial.fileUrl}';
      isLoading = false;
    });
    logger.d('studyMaterial: ${studyMaterial.fileUrl}');
    logger.d('https://api.ramaanya.com/uploads/study-materials/pdfs/$pdfUrl');
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
