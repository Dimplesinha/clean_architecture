part of 'cms_type_cubit.dart';

sealed class CmsTypeState extends Equatable {
  const CmsTypeState();
}

final class CmsTypeLoadedState extends CmsTypeState {
  final CMSTypeModel? cmsTypeModel;
  final bool isLoading;

  const CmsTypeLoadedState({
    this.cmsTypeModel,
    this.isLoading = false,
  });

  @override
  List<Object?> get props => [
    cmsTypeModel,
        isLoading,
      ];

  CmsTypeLoadedState copyWith({
    CMSTypeModel? cmsTypeModel,
    bool? isLoading,
  }) {
    return CmsTypeLoadedState(
      cmsTypeModel: cmsTypeModel ?? this.cmsTypeModel,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
