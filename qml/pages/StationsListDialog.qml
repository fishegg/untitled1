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
    property int selected_from_index: -1
    property string selected_from_station_number
    property string selected_from_station_name
    property int selected_to_number: -1
    property int selected_to_index: -1
    property string selected_to_station_number
    property string selected_to_station_name
    property bool auto_accept

    function setfromstation() {
        selected_from_number = -1
        //selected_to_number = t
        selected_from_index = -1
        selected_from_station_name = ""
        selected_from_station_number = ""
    }

    function settostation() {
        selected_to_number = -1
        selected_to_index = -1
        selected_to_station_name = ""
        selected_to_station_number = ""
    }

    Component.onCompleted: {
        //originalmodel.init()
        listmodel.update()
        linemodel.update()
        searchfield.forceActiveFocus()
        searchfield.focus = true
        auto_accept = selected_from_number === -1 && selected_to_number === -1
        //searchfield.focus = true
        //console.log("from number" + selected_from_number)
        //console.log("to number" + selected_to_number)
    }

    ListModel {
        id: listmodel

        function update() {
            //console.log("count"+stationmodel.rowCount())
            listview.model = undefined
            clear()
            for (var i=0; i<stationmodel.fulllistrowcount(); i++) {
                if (searchfield.text === "" ||
                        //stationmodel.fulllistdata(i,StationModel.StnNumRole).toLowerCase().indexOf(searchfield.text.toLowerCase()) === 0 ||
                        stationmodel.fulllistdata(i,StationModel.StnNumRole).toLowerCase().indexOf(searchfield.text.toLowerCase()) >= 0 ||
                        stationmodel.fulllistdata(i,StationModel.StnNameRole).indexOf(searchfield.text) >= 0 ||
                        stationmodel.fulllistdata(i,StationModel.LineRole).indexOf(searchfield.text) === 0) {
                    append({"number": stationmodel.fulllistdata(i,StationModel.NumRole),
                               "station_name": stationmodel.fulllistdata(i,StationModel.StnNameRole),
                               "station_number": stationmodel.fulllistdata(i,StationModel.StnNumRole),
                               "line_name": stationmodel.fulllistdata(i,StationModel.LineRole),
                               "line_colour": stationmodel.fulllistdata(i,StationModel.LineColourRole)
                           })
                }
            }
            listview.model = listmodel
        }
    }

    ListModel {
        id: linemodel

        function update() {
            clear()
            var last_append_line_name = ""
            for (var i=0; i<stationmodel.fulllistrowcount(); i++) {
                if (last_append_line_name !== stationmodel.fulllistdata(i,StationModel.LineRole)) {
                    append({"line_name": stationmodel.fulllistdata(i,StationModel.LineRole),
                               "line_colour": stationmodel.fulllistdata(i,StationModel.LineColourRole)
                           })
                    last_append_line_name = stationmodel.fulllistdata(i,StationModel.LineRole)
                }
            }
        }
    }

    /*DialogHeader {
        id: dialogheader
        z: 1
        //title: "选择车站"
        spacing: 0
    }*/

    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            DialogHeader {
                id: dialogheader
                z: 1
                //title: "选择车站"
                spacing: 0
            }
            Item {
                id: banner
                z: 1
                //anchors.top: dialogheader.bottom
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
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        //height: Theme.itemSizeExtraSmall
                        //spacing: Theme.paddingMedium
                        BackgroundItem {
                            id: fromlabel
                            enabled: selected_from_number !== -1
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width / 2
                            height: Theme.itemSizeExtraSmall
                            Label {
                                anchors {
                                    //horizontalCenter: parent.horizontalCenter
                                    //horizontalCenterOffset: Theme.paddingSmall - Theme.iconSizeMedium / 2
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: Theme.paddingMedium
                                }
                                width: parent.width - Theme.iconSizeMedium - Theme.paddingMedium
                                text: selected_from_number === -1 ?
                                          qsTr("未选择出发站") :
                                          selected_from_station_number + " " + selected_from_station_name
                                truncationMode: TruncationMode.Fade
                            }
                            Image {
                                visible: selected_from_number !== -1
                                anchors {
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                }
                                source: "image://theme/icon-m-reset"
                            }
                            onClicked: {
                                //console.log("from index" + selected_from_index)
                                searchfield.text = ""
                                listview.positionViewAtIndex(selected_from_index, ListView.Center)
                                setfromstation()
                            }
                        }
                        BackgroundItem {
                            id: tolabel
                            enabled: selected_to_number !== -1
                            anchors.verticalCenter: parent.verticalCenter
                            width: parent.width / 2
                            height: Theme.itemSizeExtraSmall
                            Label {
                                anchors {
                                    verticalCenter: parent.verticalCenter
                                    left: parent.left
                                    leftMargin: Theme.paddingMedium
                                }
                                width: parent.width - Theme.iconSizeMedium - Theme.paddingMedium
                                text: selected_to_number === -1 ?
                                          qsTr("未选择目的站") :
                                          selected_to_station_number + " " + selected_to_station_name
                                truncationMode: TruncationMode.Fade
                            }
                            Image {
                                visible: selected_to_number !== -1
                                anchors {
                                    right: parent.right
                                    verticalCenter: parent.verticalCenter
                                }
                                source: "image://theme/icon-m-reset"
                            }
                            onClicked: {
                                //console.log("to index" + selected_to_index)
                                searchfield.text = ""
                                listview.positionViewAtIndex(selected_to_index, ListView.Center)
                                settostation()
                            }
                        }
                    }

                    SearchField {
                        id: searchfield
                        //focus: true
                        width: parent.width
                        //inputMethodHints: Qt.ImhDigitsOnly
                        onTextChanged: listmodel.update()
                    }

                    GridView {
                        id: gridview
                        visible: searchfield.text === ""
                        //anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: contentItem.height > cellHeight * 2.3 ?
                                    cellHeight * 2.3 :
                                    contentItem.height
                        cellWidth: width / 5
                        cellHeight: Theme.itemSizeSmall
                        boundsBehavior: Flickable.StopAtBounds
                        clip: height === contentItem.height ?
                                  false :
                                  true
                        model: linemodel
                        delegate: Item {
                            height: gridview.cellHeight
                            width: gridview.cellWidth
                            //height: gridicon.height + Theme.paddingLarge
                            //width: gridicon.width + Theme.paddingLarge
                            Rectangle {
                                id: gridicon
                                anchors {
                                    centerIn: parent
                                }
                                width: gridlinelabel.width + Theme.paddingSmall * 2//Theme.paddingMedium
                                height: gridlinelabel.height + Theme.paddingSmall * 2//namelabel.height
                                radius: height / 7
                                color: Theme.rgba(line_colour, 0.7)
                                border.color: Theme.rgba("white", 0.7)
                                Label {
                                    id: gridlinelabel
                                    anchors.centerIn: parent
                                    text: line_name
                                    font.pixelSize: Theme.fontSizeSmall
                                }
                            }
                            MouseArea {
                                anchors.fill: parent
                                onClicked: searchfield.text = line_name
                            }
                            Component.onCompleted: {
                                if(gridicon.width > gridview.cellWidth) {
                                    gridview.cellWidth = gridview.width / Math.floor(gridview.width / gridicon.width)
                                }
                            }
                        }
                        VerticalScrollDecorator {}
                    }
                }
            }

            /*SilicaFlickable {
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
                        model: undefined

                        section.property: "line_name"
                        section.delegate: SectionHeader {
                            text: section
                        }

                        delegate: BackgroundItem {
                            id: listitem
                            //highlighted: selected_from_number === number || selected_to_number === number

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
                                    selected_from_index = index
                                    selected_from_station_name = station_name
                                    namelabel.text = "出发站 " + station_number + " " + station_name
                                    highlighted = true
                                    fromlabel.text = selected_from_station_number + " " + selected_from_station_name
                                }
                                else if(selected_to_number === number) {
                                    selected_to_station_number = station_number
                                    selected_to_index = index
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
                                    selected_from_index = -1
                                    selected_from_station_number = "无"
                                    selected_from_station_name = "无"
                                    namelabel.text = station_number + " " + station_name
                                    highlighted = false
                                    fromlabel.text = "未选择出发站"
                                }
                                else if(selected_to_number === number) {
                                    selected_to_number = -1
                                    selected_to_index = -1
                                    selected_to_station_number = "无"
                                    selected_to_station_name = "无"
                                    namelabel.text = station_number + " " + station_name
                                    highlighted = false
                                    tolabel.text = "未选择目的站"
                                }
                                else if(selected_from_number === -1) {
                                    selected_from_number = number
                                    selected_from_index = index
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
                                    selected_to_index = index
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
            }*/

            ListView {
                id: listview
                //height: parent.height - dialogheader.height - banner.height - gridview.height
                height: //gridview.visible ?
                            //root.height - dialogheader.height - banner.height - gridview.height :
                            root.height - dialogheader.height - banner.height
                width: parent.width
                //anchors.top: gridview.bottom
                model: undefined
                clip: true

                //section.property: "line_name"
                //section.delegate: SectionHeader {
                //    text: section
                //}

                delegate: BackgroundItem {
                    id: listitem
                    //highlighted: selected_from_number === number || selected_to_number === number

                    /*function delegateinit() {
                        if(selected_from_number === number) {
                            //selected_from_station_number = station_number
                            //selected_from_index = index
                            //selected_from_station_name = station_name
                            //namelabel.text = "出发站 " + station_number + " " + station_name
                            //selectedindicator.visible = true
                        }
                        else if(selected_to_number === number) {
                            //selected_to_station_number = station_number
                            //selected_to_index = index
                            //selected_to_station_name = station_name
                            //namelabel.text = "目的站 " + station_number + " " + station_name
                            //selectedindicator.visible = true
                        }
                    }*/

                    function selectstation() {
                        if(selected_from_number === number) {
                            selected_from_number = -1
                            selected_from_index = -1
                            selected_from_station_number = ""
                            selected_from_station_name = ""
                            //namelabel.text = station_number + " " + station_name
                            //selectedindicator.visible = false
                        }
                        else if(selected_to_number === number) {
                            selected_to_number = -1
                            selected_to_index = -1
                            selected_to_station_number = ""
                            selected_to_station_name = ""
                            //namelabel.text = station_number + " " + station_name
                            //selectedindicator.visible = false
                        }
                        else if(selected_from_number === -1) {
                            selected_from_number = number
                            selected_from_index = index
                            selected_from_station_number = station_number
                            selected_from_station_name = station_name
                            //namelabel.text = "出发站 " + station_number + " " + station_name
                            //selectedindicator.visible = true
                            if(auto_accept && selected_to_number !== -1) {
                                listdialog.accept()
                            }
                        }
                        else if(selected_to_number === -1) {
                            selected_to_number = number
                            selected_to_index = index
                            selected_to_station_number = station_number
                            selected_to_station_name = station_name
                            //namelabel.text = "目的站 " + station_number + " " + station_name
                            //selectedindicator.visible = true
                            if(auto_accept && selected_from_number !== -1) {
                                listdialog.accept()
                            }
                        }
                        //listdialog.accept()
                        //searchfield.focus = true
                        searchfield.text = ""
                        //searchfield.focus = true
                        //searchfield.forceActiveFocus()
                        //if(selected_from_number === -1 || selected_to_number === -1) {
                            //searchfield.text = ""
                            //searchfield.focus = true
                        //}
                        //else
                            //searchfield.focus = false
                        //console.log(searchfield.focus)
                    }

                    Rectangle {
                        id: selectedindicator
                        visible: number === selected_from_number || number === selected_to_number
                        anchors.fill: parent
                        color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                        //color: Theme.secondaryHighlightColor
                    }

                    Rectangle {
                        id: listicon
                        anchors {
                            left: parent.left
                            leftMargin: Theme.horizontalPageMargin
                            verticalCenter: parent.verticalCenter
                        }
                        width: listlinelabel.width + Theme.paddingSmall * 2//Theme.paddingMedium
                        height: listlinelabel.height + Theme.paddingSmall * 2//namelabel.height
                        radius: height / 7
                        color: Theme.rgba(line_colour, 0.7)
                        border.width: 2
                        border.color: Theme.rgba("black", 0.7)
                        Label {
                            id: listlinelabel
                            anchors.centerIn: parent
                            text: line_name
                        }
                    }

                    Label {
                        id: namelabel
                        anchors {
                            verticalCenter: parent.verticalCenter
                            //horizontalCenter: parent.horizontalCenter
                            left: listicon.right
                            leftMargin: Theme.paddingLarge
                        }
                        color: listitem.highlighted ?
                                   Theme.highlightColor :
                                   Theme.primaryColor
                        text: selected_from_number === number ?
                                  Theme.highlightText(qsTr("出发站 ") + station_number + " " + station_name, searchfield.text, Theme.highlightColor) :
                                  (selected_to_number === number ?
                                       Theme.highlightText(qsTr("目的站 ") + station_number + " " + station_name, searchfield.text, Theme.highlightColor) :
                                       Theme.highlightText(station_number + " " + station_name, searchfield.text, Theme.highlightColor)
                                   )
                    }

                    Component.onCompleted: {
                        //delegateinit()
                    }
                    onReleased: {
                        //console.log("click" + index)
                        selectstation()
                    }
                }
                VerticalScrollDecorator {}

                onFlickStarted: searchfield.focus = false
                onMovementEnded: searchfield.focus = (listview.contentY === 0)
            }
        }
    }

    canAccept: selected_from_number !== -1 && selected_to_number !== -1
    onAccepted: {
        //selected_station = listmodel.get(selected_index).no_name_string
        //console.log("selected" + selected_number)
    }
}

