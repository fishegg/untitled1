import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import untitled1.stationmodel 1.0
import ".."

Dialog {
    id: listdialog
    showNavigationIndicator: false
    canAccept: selected_number !== -1

    //property string searchString
    property int selected_number: -1
    property string selected_station_number
    property string selected_station_name

    Component.onCompleted: {
        //originalmodel.init()
        listmodel.update()
        searchfield.forceActiveFocus()
        searchfield.focus = true
    }

    ListModel {
        id: listmodel

        function update() {
            //console.log("count"+stationmodel.rowCount())
            listview.model = undefined
            clear()
            for (var i=0; i<stationmodel.fulllistrowcount(); i++) {
                if (searchfield.text === "" ||
                        stationmodel.fulllistdata(i,StationModel.StnNumRole).toLowerCase().indexOf(searchfield.text.toLowerCase()) === 0 ||
                        //stationmodel.fulllistdata(i,StationModel.StnNumRole).toLowerCase().indexOf(searchfield.text.toLowerCase()) > 0 ||
                        stationmodel.fulllistdata(i,StationModel.StnNameRole).indexOf(searchfield.text) >= 0) {
                    //console.log(stationmodel.data(i,StationModel.station_name))
                    /*if(stationmodel.data(i,StationModel.StnNameRole) !== "无") {

                    }*/
                    append({"number": stationmodel.fulllistdata(i,StationModel.NumRole),
                               "station_name": stationmodel.fulllistdata(i,StationModel.StnNameRole),
                               "station_number": stationmodel.fulllistdata(i,StationModel.StnNumRole),
                               "line_name": stationmodel.fulllistdata(i,StationModel.LineRole)
                           })
                }
            }
            listview.model = listmodel
        }
    }

    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            PageHeader {
                title: "选择车站"
            }

            SearchField {
                id: searchfield
                focus: true
                width: parent.width - Theme.paddingLarge
                onTextChanged: listmodel.update()
            }
            SilicaListView {
                id: listview
                //anchors.fill: parent
                height: contentHeight
                width: parent.width
                /*add: Transition {
                    NumberAnimation {
                        properties: "x"
                        from: listdialog.width
                        duration: 100
                    }a
                }*/
                model: undefined

                /*header: SearchField {
                    id: searchField
                    width: parent.width - Theme.paddingLarge
                    onTextChanged: listmodel.update()
                }*/

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
                        selected_number = number
                        selected_station_number = station_number
                        selected_station_name = station_name
                        listdialog.accept()
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        onFlickStarted: searchfield.focus = false
    }

    onAccepted: {
        //selected_station = listmodel.get(selected_index).no_name_string
        console.log("selected" + selected_number)
    }
}

