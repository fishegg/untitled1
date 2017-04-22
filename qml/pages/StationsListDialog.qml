import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import untitled1.stationmodel 1.0
import ".."

Dialog {
    id: listdialog
    //showNavigationIndicator: false

    //property string searchString
    property int selected_from_number: -1
    property string selected_from_station_number: "无"
    property string selected_from_station_name: "无"
    property int selected_to_number: -1
    property string selected_to_station_number: "无"
    property string selected_to_station_name: "无"
    property bool auto_accept

    Component.onCompleted: {
        //originalmodel.init()
        listmodel.update()
        searchfield.forceActiveFocus()
        auto_accept = selected_from_number === -1 && selected_to_number === -1
        //searchfield.focus = true
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
                        stationmodel.fulllistdata(i,StationModel.StnNameRole).indexOf(searchfield.text) >= 0 ||
                        stationmodel.fulllistdata(i,StationModel.LineRole).indexOf(searchfield.text) === 0) {
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

    DialogHeader {
        id: dialogheader
        z: 1
        //title: "选择车站"
        spacing: 0
    }

    Item {
        id: banner
        z: 1
        anchors.top: dialogheader.bottom
        width: parent.width
        height: bannercolumn.height
        Rectangle {
            anchors.fill: bannercolumn
            //height: Theme.itemSizeExtraSmall
            color: Theme.rgba(Theme.highlightDimmerColor, 0.8)
        }
        Column {
            id: bannercolumn
            width: parent.width
            Row {
                width: parent.width
                height: Theme.itemSizeExtraSmall
                Label {
                    id: fromlabel
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 2
                    text: "未选择出发站"
                    horizontalAlignment: Text.AlignHCenter
                    truncationMode: TruncationMode.Fade
                }
                Label {
                    id: tolabel
                    anchors.verticalCenter: parent.verticalCenter
                    width: parent.width / 2
                    text: "未选择目的站"
                    horizontalAlignment: Text.AlignHCenter
                    truncationMode: TruncationMode.Fade
                }
            }

            SearchField {
                id: searchfield
                focus: true
                width: parent.width
                //inputMethodHints: Qt.ImhDigitsOnly
                onTextChanged: listmodel.update()
            }
        }
    }

    SilicaFlickable {
        id: flickable
        //anchors.fill: parent
        height: parent.height - dialogheader.height - banner.height
        width: parent.width
        anchors.top: banner.bottom
        contentHeight: column.height
        Column {
            id: column
            width: parent.width

            SilicaListView {
                id: listview
                //anchors.fill: parent
                height: contentHeight
                width: parent.width
                spacing: 0
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
                    id: listitem
                    highlighted: selected_from_number === number || selected_to_number === number

                    Label {
                        id: namelabel
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                        color: listitem.highlighted ?
                                   Theme.highlightColor :
                                   Theme.primaryColor
                        text: selected_from_number === number ?
                                  "出发站 " + station_number + " " + station_name :
                                  (selected_to_number === number ?
                                       "目的站 " + station_number + " " + station_name :
                                       Theme.highlightText(station_number + " " + station_name, searchfield.text, Theme.highlightColor)
                                   )
                    }

                    Component.onCompleted: {
                        if(selected_from_number === number) {
                            selected_from_station_number = station_number
                            selected_from_station_name = station_name
                            namelabel.text = "出发站 " + station_number + " " + station_name
                            highlighted = true
                            fromlabel.text = selected_from_station_number + " " + selected_from_station_name
                        }
                        else if(selected_to_number === number) {
                            selected_to_station_number = station_number
                            selected_to_station_name = station_name
                            namelabel.text = "目的站 " + station_number + " " + station_name
                            highlighted = true
                            tolabel.text = selected_to_station_number + " " + selected_to_station_name
                        }
                    }
                    onReleased: {
                        //console.log("click" + index)
                        if(selected_from_number === number) {
                            selected_from_number = -1
                            selected_from_station_number = "无"
                            selected_from_station_name = "无"
                            namelabel.text = station_number + " " + station_name
                            highlighted = false
                            fromlabel.text = "未选择出发站"
                        }
                        else if(selected_to_number === number) {
                            selected_to_number = -1
                            selected_to_station_number = "无"
                            selected_to_station_name = "无"
                            namelabel.text = station_number + " " + station_name
                            highlighted = false
                            tolabel.text = "未选择目的站"
                        }
                        else if(selected_from_number === -1) {
                            selected_from_number = number
                            selected_from_station_number = station_number
                            selected_from_station_name = station_name
                            namelabel.text = "出发站 " + station_number + " " + station_name
                            highlighted = true
                            fromlabel.text = selected_from_station_number + " " + selected_from_station_name
                            if(auto_accept && selected_to_number !== -1) {
                                listdialog.accept()
                            }
                        }
                        else if(selected_to_number === -1) {
                            selected_to_number = number
                            selected_to_station_number = station_number
                            selected_to_station_name = station_name
                            namelabel.text = "目的站 " + station_number + " " + station_name
                            highlighted = true
                            tolabel.text = selected_to_station_number + " " + selected_to_station_name
                            if(auto_accept && selected_from_number !== -1) {
                                listdialog.accept()
                            }
                        }
                        //listdialog.accept()
                        //searchfield.text = ""
                        searchfield.focus = true
                        searchfield.forceActiveFocus()
                    }
                }
            }
        }

        VerticalScrollDecorator {}

        onFlickStarted: searchfield.focus = false
        onMovementEnded: searchfield.focus = (flickable.contentY === 0)
    }

    canAccept: selected_from_number !== -1 && selected_to_number !== -1
    onAccepted: {
        //selected_station = listmodel.get(selected_index).no_name_string
        //console.log("selected" + selected_number)
    }
}

