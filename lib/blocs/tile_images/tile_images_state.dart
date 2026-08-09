part of 'tile_images_bloc.dart';

sealed class TileImagesState extends Equatable {
  const TileImagesState();
}

final class TileImagesInitial extends TileImagesState {
  @override
  List<Object?> get props => [];
}

final class TileImagesLoading extends TileImagesState {
  @override
  List<Object?> get props => [];
}

final class TileImagesLoaded extends TileImagesState {
  final Map<String, String> tiles;
  const TileImagesLoaded({required this.tiles});
  @override
  List<Object?> get props => [tiles];
}

final class TileImagesFailure extends TileImagesState {
  final String message;
  const TileImagesFailure({required this.message});
  @override
  List<Object?> get props => [message];
}
