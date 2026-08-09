import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/models/slider_image.dart';
import 'package:transfor_admin_dashboard/services/slider_image_services.dart';

part 'slider_images_event.dart';
part 'slider_images_state.dart';

class SliderImagesBloc extends Bloc<SliderImagesEvent, SliderImagesState> {
  final SliderImageServices _services = SliderImageServices();

  SliderImagesBloc() : super(SliderImagesInitial()) {
    on<LoadSliderImages>(_onLoad);
    on<UploadSliderImage>(_onUpload);
    on<DeleteSliderImage>(_onDelete);
  }

  Future<void> _onLoad(LoadSliderImages event, Emitter<SliderImagesState> emit) async {
    emit(SliderImagesLoading());
    try {
      final images = await _services.getSliderImages();
      emit(SliderImagesLoaded(images: images));
    } catch (e) {
      emit(SliderImagesFailure(message: e.toString()));
    }
  }

  Future<void> _onUpload(UploadSliderImage event, Emitter<SliderImagesState> emit) async {
    emit(SliderImagesLoading());
    try {
      await _services.uploadSliderImage(
        imageName: event.imageName,
        imageDataBase64: event.imageDataBase64,
      );
      final images = await _services.getSliderImages();
      emit(SliderImagesLoaded(images: images));
    } catch (e) {
      emit(SliderImagesFailure(message: e.toString()));
    }
  }

  Future<void> _onDelete(DeleteSliderImage event, Emitter<SliderImagesState> emit) async {
    emit(SliderImagesLoading());
    try {
      await _services.deleteSliderImage(event.id);
      final images = await _services.getSliderImages();
      emit(SliderImagesLoaded(images: images));
    } catch (e) {
      emit(SliderImagesFailure(message: e.toString()));
    }
  }
}
