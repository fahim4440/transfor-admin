part of 'slider_images_bloc.dart';

sealed class SliderImagesState extends Equatable {
  const SliderImagesState();
}

final class SliderImagesInitial extends SliderImagesState {
  @override
  List<Object?> get props => [];
}

final class SliderImagesLoading extends SliderImagesState {
  @override
  List<Object?> get props => [];
}

final class SliderImagesLoaded extends SliderImagesState {
  final List<SliderImage> images;
  const SliderImagesLoaded({required this.images});
  @override
  List<Object?> get props => [images];
}

final class SliderImagesFailure extends SliderImagesState {
  final String message;
  const SliderImagesFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
