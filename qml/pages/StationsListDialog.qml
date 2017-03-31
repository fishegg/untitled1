import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import untitled1.stationmodel 1.0
import ".."

Dialog {
    id: listdialog
    property string searchString
    property int selected_index
    property int selected_number
    property string selected_station

    Component.onCompleted: {
        //originalmodel.init()
        listmodel.update()
    }

    /*ListModel {
        id: originalmodel
        function init() {
            clear();
            for(var i=0; i<db.getlistsize(); i++) {
                append({"no_name_string": db.getlistelement(i).toString()});
            }
        }
    }*/

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: ListModel {
            id: listmodel

            function update() {
                console.log("count"+stationmodel.rowCount())
                clear()
                for (var i=0; i<stationmodel.rowCount(); i++) {
                    if (listview.headerItem.text == "" ||
                            stationmodel.data(i,StationModel.StnNumRole).indexOf(listview.headerItem.text) >= 0 ||
                            stationmodel.data(i,StationModel.StnNameRole).indexOf(listview.headerItem.text) >= 0// ||
                            /*stationmodel.data(i,StationModel.LineRole).indexOf(listview.headerItem.text >= 0)*/) {
                        //console.log(stationmodel.data(i,StationModel.station_name))
                        if(stationmodel.data(i,StationModel.StnNameRole) !== "无") {
                            append({"number": stationmodel.data(i,StationModel.NumRole),
                                       "station_name": stationmodel.data(i,StationModel.StnNameRole),
                                       "station_number": stationmodel.data(i,StationModel.StnNumRole),
                                       "line_name": stationmodel.data(i,StationModel.LineRole)})
                        }
                    }
                }
            }
        }

        header: SearchField {
            id: searchField
            width: parent.width - Theme.paddingLarge
            onTextChanged: listmodel.update()
        }

        section.property: "line_name"
        section.delegate: SectionHeader {
            text: section
        }

        delegate: BackgroundItem {
            Label {
                id: item
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                text: station_number + " " + station_name
            }
            onClicked: {
                console.log("click" + index)
                selected_index = index
                selected_number = number
                selected_station = station_name
                listdialog.accept()
            }
        }
    }

    onAccepted: {
        //selected_station = listmodel.get(selected_index).no_name_string
        console.log("selected" + selected_station)
    }
}

