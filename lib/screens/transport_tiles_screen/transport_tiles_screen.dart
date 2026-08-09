import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/tile_images/tile_images_bloc.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

class TransportTilesScreen extends StatefulWidget {
  const TransportTilesScreen({super.key});

  @override
  State<TransportTilesScreen> createState() => _TransportTilesScreenState();
}

class _TransportTilesScreenState extends State<TransportTilesScreen> {
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png', 'svg'];

  static const List<Map<String, String>> _tiles = [
    {'key': 'dry_transport',          'label': 'Dry Transportation'},
    {'key': 'refrigerated_transport', 'label': 'Refrigerated Transportation'},
  ];

  @override
  void initState() {
    super.initState();
    context.read<TileImagesBloc>().add(LoadTileImages());
  }

  void _showError(String message) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.error,
      title: AppStrings.fetchError.translate(context),
      desc: message,
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  Future<void> _pickAndUpload(String tileKey) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext  = file.extension?.toLowerCase() ?? '';

    if (!_allowedExtensions.contains(ext)) {
      if (!mounted) return;
      AwesomeDialog(
        context: context,
        dialogType: DialogType.warning,
        title: AppStrings.invalidFileType.translate(context),
        desc: AppStrings.invalidFileTypeDesc.translate(context),
        btnOkOnPress: () {},
        width: 400,
      ).show();
      return;
    }

    final bytes = file.bytes;
    if (bytes == null) return;

    if (mounted) {
      context.read<TileImagesBloc>().add(UpdateTileImage(
            tileKey: tileKey,
            imageDataBase64: base64Encode(bytes),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TileImagesBloc, TileImagesState>(
      listener: (context, state) {
        if (state is TileImagesFailure) _showError(state.message);
      },
      builder: (context, state) {
        final tiles = state is TileImagesLoaded ? state.tiles : <String, String>{};
        final isLoading = state is TileImagesLoading;

        return Padding(
          padding: const EdgeInsets.all(AppDimensions.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.transportTiles.translate(context),
                style: AppTextStyles.heading,
              ),
              const SizedBox(height: AppDimensions.normalSpacing),
              if (isLoading)
                const Expanded(child: Center(child: CircularProgressIndicator()))
              else
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.4,
                    children: _tiles
                        .map((t) => _TileCard(
                              label: t['label']!,
                              tileKey: t['key']!,
                              imageData: tiles[t['key']],
                              onReplace: () => _pickAndUpload(t['key']!),
                            ))
                        .toList(),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TileCard extends StatelessWidget {
  final String label;
  final String tileKey;
  final String? imageData;
  final VoidCallback onReplace;

  const _TileCard({
    required this.label,
    required this.tileKey,
    required this.imageData,
    required this.onReplace,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    if (imageData != null) {
      try {
        bytes = base64Decode(imageData!);
      } catch (_) {}
    }

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (bytes != null)
            Image.memory(bytes, fit: BoxFit.cover)
          else
            Container(
              color: Colors.grey.shade200,
              child: const Center(child: Icon(Icons.image, size: 48, color: Colors.grey)),
            ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      textStyle: const TextStyle(fontSize: 12),
                    ),
                    onPressed: onReplace,
                    icon: const Icon(Icons.upload, size: 14),
                    label: Text(AppStrings.replace.translate(context)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
