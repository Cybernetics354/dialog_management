part of dialog_management;

typedef DialogCallback = Future<void> Function(String title, String description, BuildContext context);
typedef DialogCustomCallback = Future<void> Function();

class DialogView {
  DialogCallback showDialogFunc;
  
  DialogView(this.showDialogFunc);
}

class DialogConfiguration {
  GlobalKey<NavigatorState> navigatorKey;
  DialogView noConnectionDialog;
  DialogView loadingDialog;
  DialogView onConnectionActive;
  DialogView onLoadingActive;

  DialogConfiguration(this.navigatorKey, {
    this.noConnectionDialog,
    this.loadingDialog,
    this.onConnectionActive,
    this.onLoadingActive
  });
}

class DialogState {
  bool noConnection;
  bool loadingDialog;
  bool customDialog;

  DialogState({
    this.noConnection = false,
    this.loadingDialog = false,
    this.customDialog = false
  });
}