class PaginationParams {
  final int page;
  final int size;
  final String? sort;

  const PaginationParams({
    this.page = 0,
    this.size = 20,
    this.sort,
  });
}