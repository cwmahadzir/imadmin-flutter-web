import 'package:flutter/material.dart';
import 'package:imadmin/api/imadminapi.dart';
import 'package:imadmin/models/shot.dart';

class EditShotDialog extends StatefulWidget {
  List<Shot> popupShots;
  List<Shot> actualShots;
  Function onEditShotUpdated;

  EditShotDialog(this.popupShots, this.onEditShotUpdated,this.actualShots);

   //Future<List<Shot>> listFuture = MonsterAdminApi().getShots();

  @override
  State<StatefulWidget> createState() {
    return EditShotDialogState(actualShots);
  }
}

class EditShotDialogState extends State<EditShotDialog> {



    EditShotDialogState(List<Shot> actualShots){
      Future<List<Shot>> listFuture = MonsterAdminApi().getShots(actualShots);

      listFuture.then((result)=>{
      this.setState((){
        
        widget.popupShots.clear();
        widget.popupShots.addAll(result);
      })
    });
    }

  

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16.0))),
      title: Text('Edit Portfolio'),
      content: getFutureBuilder(context, widget.popupShots, this),
      actions: <Widget>[
       
        FlatButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),

         FlatButton(
          child: Text('Update'),
          onPressed: () {
             Navigator.of(context).pop();
            widget.onEditShotUpdated();
          },
        )       ],
    );
  }


  Container getFutureBuilder(BuildContext context, List<Shot> shots, EditShotDialogState editShotDialogState) {
  if(shots!=null && shots.length>0){
      return Container(
              width: MediaQuery.of(context).size.width - (50),
              child: GridView.builder(
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4),
                itemCount: shots.length,
                itemBuilder: (context, index) {
                  return Column(
                    children: <Widget>[
                      Padding(
                        child: getShotCard(
                             shots[index], index, shots, editShotDialogState),
                        padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                      )
                    ],
                  );
                },
              ));
  }else{
    return Container(
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 8, 0),
                  child: new CircularProgressIndicator()  ,
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: new Text("Loading Shots"),
                )
              ],
            ),
          );
  }

}
}

InkWell getShotCard(
    Shot shot, int index, List<Shot> shots, EditShotDialogState state) {
  return InkWell(
    onTap: () {
      state.setState(() {
       
        //shot.isSelected=!shot.isSelected;
        shots[index].isSelected = !shots[index].isSelected;

      });
    },
    child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Stack(
          children: <Widget>[
            Image.network(
              shot.images.normal,
              fit: BoxFit.fill,
            ),
            getSelectedStateWidget(shots[index].isSelected)
          ],
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 3),
  );
}

Widget getSelectedStateWidget(bool isSelected) {
  if (isSelected) {
    return new RawMaterialButton(
      onPressed: () {},
      child: new Icon(
        Icons.check,
        color: Colors.greenAccent,
        size: 20.0,
      ),
      shape: new CircleBorder(),
      elevation: 1.0,
      fillColor: Colors.white
    );
  } else {
    return Container();
  }
}


