import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transfor_admin_dashboard/services/tile_image_services.dart';

part 'tile_images_event.dart';
part 'tile_images_state.dart';

class TileImagesBloc extends Bloc<TileImagesEvent, TileImagesState> {
  final TileImageServices _services = TileImageServices();

  TileImagesBloc() : super(TileImagesInitial()) {
    on<LoadTileImages>(_onLoad);
    on<UpdateTileImage>(_onUpdate);
  }

  Future<void> _onLoad(LoadTileImages event, Emitter<TileImagesState> emit) async {
    emit(TileImagesLoading());
    try {
      final tiles = await _services.getTileImages();
      emit(TileImagesLoaded(tiles: tiles));
    } catch (e) {
      emit(TileImagesFailure(message: e.toString()));
    }
  }

  Future<void> _onUpdate(UpdateTileImage event, Emitter<TileImagesState> emit) async {
    emit(TileImagesLoading());
    try {
      await _services.updateTileImage(
        tileKey: event.tileKey,
        imageDataBase64: event.imageDataBase64,
      );
      final tiles = await _services.getTileImages();
      emit(TileImagesLoaded(tiles: tiles));
    } catch (e) {
      emit(TileImagesFailure(message: e.toString()));
    }
  }
}
