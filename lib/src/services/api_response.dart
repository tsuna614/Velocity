class ApiResponse<T> {
  final T? data;
  final String? errorMessage;

  ApiResponse({
    this.data,
    this.errorMessage,
  });
}
