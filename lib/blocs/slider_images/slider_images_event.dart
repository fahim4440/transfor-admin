part of 'slider_images_bloc.dart';

sealed class SliderImagesEvent extends Equatable {
  const SliderImagesEvent();
}

final class LoadSliderImages extends SliderImagesEvent {
  @override
  List<Object?> get props => [];
}

final class UploadSliderImage extends SliderImagesEvent {
  final String imageName;
  final String imageDataBase64;
  const UploadSliderImage({required this.imageName, required this.imageDataBase64});
  @override
  List<Object?> get props => [imageName, imageDataBase64];
}

final class DeleteSliderImage extends SliderImagesEvent {
  final String id;
  const DeleteSliderImage({required this.id});
  @override
  List<Object?> get props => [id];
}
