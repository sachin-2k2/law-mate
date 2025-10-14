import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class PdfViewerPage extends StatefulWidget {
  final String fileUrl;
  const PdfViewerPage({super.key, required this.fileUrl});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  PdfControllerPinch? _pdfController;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final filePath = '${tempDir.path}/${widget.fileUrl.split('/').last}';
      final file = File(filePath);

      if (!await file.exists()) {
        final response = await Dio().get(
          widget.fileUrl,
          options: Options(responseType: ResponseType.bytes),
        );
        await file.writeAsBytes(response.data);
      }

      setState(() {
        _pdfController = PdfControllerPinch(
          document: PdfDocument.openFile(file.path), // Pass Future<PdfDocument>
        );
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error opening PDF: $e');
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Case File'),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pdfController != null
              ? PdfViewPinch(controller: _pdfController!)
              : const Center(
                  child: Text('Failed to load PDF', style: TextStyle(color: Colors.red)),
                ),
    );
  }
}
