# dialog_management

A dialog management for flutter

## Purpose

Sometimes we need to use dialog for showing loading, or showing error, or no connection etc, and we need to manage it
so it won't be stacked till black

## Usage

Initialize on `main()` and configure it
```dart
void main() {
  runApp(MyApp());
  DialogManagement.instance.initialize(DialogConfiguration(
    navigatorKey,
    loadingDialog: DialogView((title, desc, context) async {
      return await showDialog(context: context, builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      });
    }),
    noConnectionDialog: DialogView((title, desc, context) async {
      return await showModalBottomSheet(context: context, builder: (context) {
        return Container(
          height: 200.0,
          padding: EdgeInsets.symmetric(vertical: 30.0),
          child: Column(
            children: [
              Text(title, style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),),
              Text(desc),
              FlatButton(
                child: Text("Show loading dialog"),
                onPressed: () {
                  DialogManagement.instance.showLoadingDialog(title: "Ini loading");
                },
              ),
              FlatButton(
                child: Text("Show No Internet"),
                onPressed: () {
                  DialogManagement.instance.showNoConnectionDialog();
                },
              ),
            ],
          ),
        );
      });
    }),
    onConnectionActive: DialogView((title, desc, context) {
      Fluttertoast.showToast(msg: title);
      return;
    }),
    onLoadingActive: DialogView((title, desc, context) {
      Fluttertoast.showToast(msg: title);
      return;
    })
  ));
}
```

take a note, this initializa need navigatorKey for showing dialog, and for usage is simple enough

```dart
FlatButton(
    child: Text("Show No internet dialog"),
    onPressed: () {
        DialogManagement.instance.showNoConnectionDialog(title: "Nggak ada koneksi", body: "Coba lagi nanti yak");
    },
),
FlatButton(
    child: Text("Show Loading dialog"),
    onPressed: () {
        DialogManagement.instance.showLoadingDialog();
    },
),
FlatButton(
    child: Text("Show Custom dialog"),
    onPressed: () {
    DialogManagement.instance.showCustomDialog(() async {
        await showDialog(context: context, builder: (context) {
            return AlertDialog(
                title: Text("Custom Dialog"),
                content: Text("This is custom dialog"),
            );
        });

        return true;
    });
    },
),
```

we can also listen to it's state with `StreamBuilder`

```dart
StreamBuilder<DialogState>(
    stream: DialogManagement.instance.dialogStateStream,
    builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
            DialogManagement.instance.inputStreamValue();
            return CircularProgressIndicator();
        }

        final DialogState data = snapshot.data;
        return Column(
            children: [
                Text("Custom Dialog = " + data.customDialog.toString()),
                Text("Loading Dialog = " + data.loadingDialog.toString()),
                Text("No Connection Dialog = " + data.noConnection.toString()),
            ],
        );
    },
),
```

Happy Fluttering, @Cybernetics Core
