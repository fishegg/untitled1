import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import ".."

Dialog {
    id: listdialog
    property string searchString
    property int selected_index
    property string selected_station

    Component.onCompleted: {
        originalmodel.init()
        listmodel.update()
    }

    ListModel {
        id: originalmodel
        function init() {
            clear();
            for(var i=0; i<db.getlistsize(); i++) {
                append({"no_name_string": db.getlistelement(i).toString()});
            }
        }
    }

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: ListModel {
            id: listmodel

            function update() {
                clear()
                for (var i=0; i<originalmodel.count; i++) {
                    if (listview.headerItem.text == "" ||
                            originalmodel.get(i).no_name_string.indexOf(listview.headerItem.text) >= 0) {
                        console.log(originalmodel.get(i).no_name_string)
                        append({"no_name_string": originalmodel.get(i).no_name_string})
                    }
                }
            }
        }

        header: SearchField {
            id: searchField
            width: parent.width
            onTextChanged: listmodel.update()
        }

        /*section.property: "line"
        section.delegate: SectionHeader {
            text: section
        }*/

        delegate: BackgroundItem {
            Label {
                id: item
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                text: no_name_string
            }
            onClicked: {
                console.log("click" + index)
                selected_index = index
                listdialog.accept()
            }
        }
    }

    DatabaseConnector {
        id: db
    }

    onAccepted: {
        selected_station = listmodel.get(selected_index).no_name_string
        console.log("selected" + selected_station)
    }
}

