part of 'locale_bloc.dart';

sealed class LocaleState extends Equatable {
  const LocaleState();
}

final class LocaleInitial extends LocaleState {
  final Locale locale;
  const LocaleInitial(this.locale);

  @override
  List<Object> get props => [locale];
}
