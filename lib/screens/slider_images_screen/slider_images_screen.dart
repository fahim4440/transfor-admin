import 'dart:convert';
import 'dart:typed_data';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transfor_admin_dashboard/blocs/slider_images/slider_images_bloc.dart';
import 'package:transfor_admin_dashboard/models/slider_image.dart';
import 'package:transfor_admin_dashboard/utilities/app_strings.dart';
import 'package:transfor_admin_dashboard/utilities/colors.dart';
import 'package:transfor_admin_dashboard/utilities/dimensions.dart';
import 'package:transfor_admin_dashboard/utilities/text_styles.dart';

class SliderImagesScreen extends StatefulWidget {
  const SliderImagesScreen({super.key});

  @override
  State<SliderImagesScreen> createState() => _SliderImagesScreenState();
}

class _SliderImagesScreenState extends State<SliderImagesScreen> {
  static const List<String> _allowedExtensions = ['jpg', 'jpeg', 'png'];

  @override
  void initState() {
    super.initState();
    context.read<SliderImagesBloc>().add(LoadSliderImages());
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

  void _showInvalidFileTypeError() {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: AppStrings.invalidFileType.translate(context),
      desc: AppStrings.invalidFileTypeDesc.translate(context),
      btnOkOnPress: () {},
      width: 400,
    ).show();
  }

  Future<void> _pickAndUpload() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: true,
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final ext = file.extension?.toLowerCase() ?? '';

    if (!_allowedExtensions.contains(ext)) {
      _showInvalidFileTypeError();
      return;
    }

    final bytes = file.bytes;
    if (bytes == null) return;

    final base64Data = base64Encode(bytes);
    if (mounted) {
      context.read<SliderImagesBloc>().add(UploadSliderImage(
            imageName: file.name,
            imageDataBase64: base64Data,
          ));
    }
  }

  void _confirmDelete(SliderImage image) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      title: AppStrings.confirm.translate(context),
      desc: '${AppStrings.deleteImageConfirm.translate(context)} "${image.imageName}"?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        context.read<SliderImagesBloc>().add(DeleteSliderImage(id: image.id));
      },
      width: 400,
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SliderImagesBloc, SliderImagesState>(
      listener: (context, state) {
        if (state is SliderImagesFailure) {
          _showError(state.message);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(AppDimensions.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.sliderImages.translate(context),
                    style: AppTextStyles.heading,
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: state is SliderImagesLoading ? null : _pickAndUpload,
                    icon: const Icon(Icons.upload),
                    label: Text(AppStrings.uploadImage.translate(context)),
                  ),
                ],
              ),
              const SizedBox(height: AppDimensions.normalSpacing),
              Expanded(child: _buildBody(state)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(SliderImagesState state) {
    if (state is SliderImagesLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state is SliderImagesLoaded) {
      if (state.images.isEmpty) {
        return Center(
          child: Text(
            AppStrings.noImages.translate(context),
            style: AppTextStyles.drawerBody,
          ),
        );
      }
      return GridView.builder(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 280,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: state.images.length,
        itemBuilder: (context, index) => _ImageCard(
          image: state.images[index],
          onDelete: () => _confirmDelete(state.images[index]),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ImageCard extends StatelessWidget {
  final SliderImage image;
  final VoidCallback onDelete;

  const _ImageCard({required this.image, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Uint8List? bytes;
    try {
      bytes = base64Decode(image.imageData);
    } catch (_) {}

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (bytes != null)
            Image.memory(bytes, fit: BoxFit.cover)
          else
            const Center(child: Icon(Icons.broken_image, size: 48)),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.black54,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      image.imageName,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: onDelete,
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
