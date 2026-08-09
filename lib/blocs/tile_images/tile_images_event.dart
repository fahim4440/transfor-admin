part of 'tile_images_bloc.dart';

sealed class TileImagesEvent extends Equatable {
  const TileImagesEvent();
}

final class LoadTileImages extends TileImagesEvent {
  @override
  List<Object?> get props => [];
}

final class UpdateTileImage extends TileImagesEvent {
  final String tileKey;
  final String imageDataBase64;
  const UpdateTileImage({required this.tileKey, required this.imageDataBase64});
  @override
  List<Object?> get props => [tileKey, imageDataBase64];
}
