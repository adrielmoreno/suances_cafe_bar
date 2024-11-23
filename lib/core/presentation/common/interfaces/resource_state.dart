enum Status {
  LOADING,
  COMPLETED,
}

class ResourceState {
  Status state;
  dynamic data;

  ResourceState(this.state, this.data);

  ResourceState.loading() : state = Status.LOADING;
  ResourceState.completed(this.data) : state = Status.COMPLETED;
}
