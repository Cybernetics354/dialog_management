part of dialog_management;

class DialogManagement {
  final _stateStreamController = new StreamController<DialogState>.broadcast();
  Stream<DialogState> get dialogStateStream => _stateStreamController.stream;
  StreamSink<DialogState> get _inStream => _stateStreamController.sink;

  inputStreamValue() {
    _inStream.add(_dialogState);
  }

  static DialogState _dialogState = new DialogState();
  DialogConfiguration _configuration;

  static bool get noConnectionState => _dialogState.noConnection;
  static bool get loadingState => _dialogState.loadingDialog;
  static bool get customState => _dialogState.customDialog;

  static final DialogManagement _singleton = DialogManagement._();
  DialogManagement._();

  static DialogManagement get instance => _singleton;

  initialize(DialogConfiguration configuration) {
    _configuration = configuration;
  }

  _switchingNoConnection(Function callback) async {
    inputStreamValue();
    _dialogState.noConnection = true;
    await callback();
    _dialogState.noConnection = false;
    inputStreamValue();
  }

  _switchingLoadingConnection(Function callback) async {
    inputStreamValue();
    _dialogState.loadingDialog = true;
    await callback();
    _dialogState.loadingDialog = false;
    inputStreamValue();
  }

  _switchingCustomDialog(Function callback) async {
    inputStreamValue();
    _dialogState.customDialog = true;
    await callback();
    _dialogState.customDialog = false;
    inputStreamValue();
  }

  showNoConnectionDialog({String title = "Tidak ada koneksi internet", String body = "Coba periksa lagi koneksi internet anda"}) async {
    if(_configuration != null && _configuration.noConnectionDialog != null && _dialogState.noConnection == false) {
      _switchingNoConnection(() => _configuration.noConnectionDialog.showDialogFunc(title, body, _configuration.navigatorKey.currentState.overlay.context));
    }
  }

  showLoadingDialog({String title = "Loading", String body = "Mohon tunggu sebentar"}) {
    if(_configuration != null && _configuration.loadingDialog != null && _dialogState.loadingDialog == false && _dialogState.noConnection == false) {
      _switchingLoadingConnection(() => _configuration.loadingDialog.showDialogFunc(title, body, _configuration.navigatorKey.currentState.overlay.context));
    } else if(_dialogState.noConnection == true) {
      _configuration.onConnectionActive.showDialogFunc(title, body, _configuration.navigatorKey.currentState.overlay.context);
    }
  }

  showCustomDialog(DialogCustomCallback dialog) {
    _switchingCustomDialog(() => dialog());
  }

  closeNoConnection() {
    if(_dialogState.noConnection == true && _configuration != null) {
      _configuration.navigatorKey.currentState.pop();
    }
  }

  closeLoading() {
    if(_dialogState.loadingDialog == true && _configuration != null) {
      _configuration.navigatorKey.currentState.pop();
    }
  }

  closeAll() {
    closeLoading();
    closeNoConnection();
  }

  void dispose() {
    _stateStreamController?.close();
  }
}

