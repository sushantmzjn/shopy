class ProductState {

  final bool isError;
  final String errMessage;
  final bool isSuccess;
  final bool isLoad;

  ProductState({
    required this.errMessage,
    required this.isError,
    required this.isLoad,
    required this.isSuccess
  });


  ProductState copyWith({
    bool? isError,
    String? errMessage,
    bool? isSuccess,
    bool? isLoad
  }) {
    return ProductState(
        errMessage: errMessage ?? this.errMessage,
        isError: isError ?? this.isError,
        isLoad: isLoad ?? this.isLoad,
        isSuccess: isSuccess ?? this.isSuccess
    );
  }
}