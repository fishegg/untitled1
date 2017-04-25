/*
  Copyright (C) 2013 Jolla Ltd.
  Contact: Thomas Perl <thomas.perl@jollamobile.com>
  All rights reserved.

  You may use this file under the terms of BSD license as follows:

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the Jolla Ltd nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
  ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
  ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
  ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick 2.2
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import untitled1.stationmodel 1.0
//import ".."
import "../components"
//import "../cover"


Page {
    id: page

    property int from_number: -1
    property int to_number: -1
    property string from_station_number
    property string to_station_number
    property string from_station_name
    property string to_station_name
    property int from_index
    property int to_index
    property int preference: 1
    property int multiple: 10

    function openlistdialog(f, t, fnu, tnu, fna, tna, fi, ti) {
        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"),
                                    {selected_from_number: f,
                                        selected_to_number: t,
                                        selected_from_station_number: fnu,
                                        selected_to_station_number: tnu,
                                        selected_from_station_name: fna,
                                        selected_to_station_name: tna,
                                        selected_from_index: fi,
                                        selected_to_index: ti
                                    })
        dialog.accepted.connect(function() {
            //frombutton.value = dialog.selected_from_station_number + " " + dialog.selected_from_station_name
            from_number = dialog.selected_from_number
            from_station_name = dialog.selected_from_station_name
            from_station_number = dialog.selected_from_station_number
            from_index = dialog.selected_from_index
            //frombutton.value = from_station_number + " " + from_station_name
            //tobutton.value = dialog.selected_to_station_number + " " + dialog.selected_to_station_name
            to_number = dialog.selected_to_number
            to_station_name = dialog.selected_to_station_name
            to_station_number = dialog.selected_to_station_number
            to_index = dialog.selected_to_index
            //tobutton.value = to_station_number + " " + to_station_name
            /*if(from_number !== -1 && to_number !== -1) {
                stationmodel.search(from_number,to_number,preference)
                //stationmodel.getroutelistdata()
                wait()
            }*/
            search()
        })
    }

    function swapfromto() {
        var t
        t = to_number
        to_number = from_number
        from_number = t
        //t = tobutton.value
        //tobutton.value = frombutton.value
        //frombutton.value = t
        t = to_station_number
        to_station_number = from_station_number
        from_station_number = t
        t = to_station_name
        to_station_name = from_station_name
        from_station_name = t
        t = to_index
        to_index = from_index
        from_index = to_index
    }

    function wait() {
        touchblocker.enabled = true
        timer.start()
    }

    function setpreference(type) {
        /*type0button.highlighted = false
        type1button.highlighted = false
        type2button.highlighted = false
        type3button.highlighted = false*/
        preference = type
        //search()
    }

    function search() {
        if(from_number !== -1 && to_number !== -1) {
            stationmodel.search(from_number,to_number,preference,multiple)
            wait()
        }
    }

    Component.onCompleted: {
        //console.log("count"+stationmodel.rowCount())
        //load_status = stationmodel.getdata()
    }

    //stationmodel.onDataChanged: console.log("data changed")
    Connections {
        target: stationmodel
        //onRowsInserted: console.log("data changed")
        //onRowsInserted: console.log("count"+stationmodel.rowCount())
    }

    Timer {
        id: timer
        interval: 300
        //running: true
        onTriggered: {
            //stationmodel.getfulllistdata()
            //appwindow.load_status = stationmodel.getmapdata()
            stationmodel.getroutelistdata()
            touchblocker.enabled = false
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        id: flickable
        anchors.fill: parent
        //width: parent.width
        //height: parent.height - 100
        //boundsBehavior: Flickable.DragOverBounds

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
            MenuItem {
                text: qsTr("设置")
                onClicked: pageStack.push(Qt.resolvedUrl("SettingDialog.qml"))
            }
            MenuItem {
                text: qsTr("软件信息")
                onClicked: pageStack.push(Qt.resolvedUrl("InformationPage.qml"))
            }
            MenuItem {
                text: from_number !== -1 || to_number !== -1 ?
                          qsTr("重选出发站及目的站") :
                          qsTr("选择出发站及目的站")
                onClicked: {
                    /*from_number = -1
                    to_number = -1*/
                    openlistdialog(-1, -1, "", "", "", "", -1, -1)
                }
            }
            MenuItem {
                visible: from_number !== -1 && to_number !== -1
                //enabled: from_number !== -1 && to_number !== -1
                text: qsTr("出发站↔目的站")
                onClicked: {
                    swapfromto()
                    stationmodel.search(from_number,to_number,preference)
                    //stationmodel.getroutelistdata()
                    wait()
                }
            }
        }

        PushUpMenu {
            //visible: flickable.contentHeight > flickable.height + 1
            MenuItem {
                visible: from_number !== -1 && to_number !== -1
                //enabled: from_number !== -1 && to_number !== -1
                text: qsTr("出发站↔目的站")
                property var t
                onClicked: {
                    swapfromto()
                    flickable.scrollToTop()
                    stationmodel.search(from_number,to_number,preference)
                    //stationmodel.getroutelistdata()
                    wait()
                }
            }
            MenuItem {
                text: from_number !== -1 || to_number !== -1 ?
                          qsTr("重选出发站及目的站") :
                          qsTr("选择出发站及目的站")
                onClicked: {
                    /*from_number = -1
                    to_number = -1*/
                    openlistdialog(-1, -1, "", "", "", "", -1, -1)
                    flickable.scrollToTop()
                }
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height + column.spacing > height ?
                           column.height + column.spacing :
                           height + 1

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingMedium
            //bottomPadding: spacing
            PageHeader {
                id: header
                title: stationmodel.getname() + qsTr("Show Page 2𧒽") + listview.contentItem.height + "\u274BD"
            }

            Row {
                id: row
                width: parent.width
                ValueButton {
                    id: frombutton
                    width: parent.width / 2
                    label: qsTr("出发站")
                    value: from_number === -1 ?
                               qsTr("点击选择") :
                               from_station_number + " " + from_station_name
                    onClicked: {
                        //from_number = -1
                        //console.log("to_number" + to_number)
                        openlistdialog(-1, to_number, "", to_station_number, "", to_station_name, -1, to_index)
                    }
                }
                ValueButton {
                    id: tobutton
                    enabled: from_number !== -1
                    width: parent.width / 2
                    label: qsTr("目的站")
                    value: to_number === -1 ?
                               "" :
                               to_station_number + " " + to_station_name
                    onClicked: {
                        //to_number = -1
                        //console.log("from_name" + from_station_name)
                        openlistdialog(from_number, -1, from_station_number, "", from_station_name, "", from_index, -1)
                    }
                }
            }

            /*Button {
                id: button
                text: "出发"
                onClicked: {
                    console.log(frombutton.source+">"+tobutton.destination)
                    //stationmodel.getfulllistdata()
                    stationmodel.search(frombutton.source,tobutton.destination)
                    //listmodel.update()
                    stationmodel.getroutelistdata()
                }
            }*/

            /*Row {
                //anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width// - Theme.horizontalPageMargins
                //spacing: Theme.paddingSmall
                //height: Theme.itemSizeExtraSmall

            }*/

            Loader {
                id: loader
                width: parent.width
                sourceComponent: typebuttoncomponent
            }

            SilicaListView {
                id: listview
                width: parent.width
                //height: page.height - header.height - row.height - button.height - column.spacing*3
                height: contentItem.height
                //clip: true
                //visible: count < 150
                //boundsBehavior: Flickable.StopAtBounds

                model: stationmodel
                /*ListModel {
                    id: listmodel

                    function update() {
                        console.log("count"+stationmodel.rowCount())
                        clear()
                        for(var j=0; j<stationmodel.routestationlistrowcount(); j++)
                        {
                            console.log(stationmodel.routedata(j))
                            for (var i=0; i<stationmodel.rowCount(); i++) {
                                if(stationmodel.data(i,StationModel.NumRole) === stationmodel.routedata(j)) {
                                    append({"number": stationmodel.data(i,StationModel.NumRole),
                                               "station_name": stationmodel.data(i,StationModel.StnNameRole),
                                               "station_number": stationmodel.data(i,StationModel.StnNumRole),
                                               "line_name": stationmodel.data(i,StationModel.LineRole)})
                                }
                            }
                        }
                    }
                }*/

                delegate: RouteListViewDelegate {
                    onClicked: console.log("click")
                }

                ViewPlaceholder {
                    enabled: listview.count === 0
                    hintText: qsTr("下拉或者点击<br>选择出发站及目的站")
                }
            }
        }

        VerticalScrollDecorator {}
    }

    TouchBlocker {
        id: touchblocker
        anchors.fill: parent
        enabled: false

        Rectangle {
            visible: touchblocker.enabled
            anchors.fill: parent
            color: Theme.rgba(Theme.highlightDimmerColor, Theme.highlightBackgroundOpacity)
        }

        BusyIndicator {
            anchors.centerIn: parent
            running: touchblocker.enabled
            size: BusyIndicatorSize.Large
        }
    }

    Component {
        id: typebuttoncomponent
        Row {
            BackgroundItem {
                id: type0button
                width: parent.width / 4
                //highlighted: preference === 0
                Rectangle {
                    id: selectedindicator0
                    visible: preference === StationModel.ConvenientlyTransfer
                    anchors.fill: parent
                    color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                    //color: Theme.secondaryHighlightColor
                }
                Label {
                    anchors.centerIn: parent
                    color: type0button.highlighted || selectedindicator0.visible ?
                               Theme.highlightColor :
                               Theme.primaryColor
                    text: qsTr("步行少")
                }
                onReleased: {
                    /*preference = 0
                    highlighted = preference === 0
                    type1button.highlighted = false
                    type2button.highlighted = false
                    type3button.highlighted = false
                    if(from_number !== -1 && to_number !== -1) {
                        stationmodel.search(from_number,to_number,preference)
                        //stationmodel.getroutelistdata()
                        touchblocker.enabled = true
                        timer.start()
                    }*/
                    setpreference(StationModel.ConvenientlyTransfer)
                    search()
                }
                /*onPressed: {
                    highlighted = !highlighted
                }*/
            }
            BackgroundItem {
                id: type1button
                width: parent.width / 4
                //highlighted: preference === 1
                Rectangle {
                    id: selectedindicator1
                    visible: preference === StationModel.LessTimeTransfer
                    anchors.fill: parent
                    color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                    //color: Theme.secondaryHighlightColor
                }
                Label {
                    anchors.centerIn: parent
                    color: type1button.highlighted || selectedindicator1.visible ?
                               Theme.highlightColor :
                               Theme.primaryColor
                    text: qsTr("换乘少")
                }
                onReleased: {
                    setpreference(StationModel.LessTimeTransfer)
                    search()
                }
            }
            BackgroundItem {
                id: type2button
                width: parent.width / 4
                //highlighted: preference === 2
                Rectangle {
                    id: selectedindicator2
                    visible: preference === StationModel.ShortDistance
                    anchors.fill: parent
                    color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                    //color: Theme.secondaryHighlightColor
                }
                Label {
                    anchors.centerIn: parent
                    color: type2button.highlighted || selectedindicator2.visible ?
                               Theme.highlightColor :
                               Theme.primaryColor
                    text: qsTr("车程短")
                }
                onReleased: {
                    setpreference(StationModel.ShortDistance)
                    search()
                }
            }
            BackgroundItem {
                id: type3button
                width: parent.width / 4
                //highlighted: preference === 3
                Rectangle {
                    id: selectedindicator3
                    visible: preference === StationModel.Balance
                    anchors.fill: parent
                    color: Theme.rgba(Theme.secondaryHighlightColor, Theme.highlightBackgroundOpacity)
                    //color: Theme.secondaryHighlightColor
                }
                Label {
                    anchors.centerIn: parent
                    color: type3button.highlighted || selectedindicator3.visible ?
                               Theme.highlightColor :
                               Theme.primaryColor
                    text: qsTr("个性化")
                }
                onReleased: {
                    setpreference(StationModel.Balance)
                    loader.sourceComponent = slidercomponent
                }
            }
        }
    }

    Component {
        id: slidercomponent
        Row {
            Slider {
                id: slider
                width: parent.width - acceptbutton.width - closebutton.width
                minimumValue: 1
                maximumValue: 20
                stepSize: 1
                value: multiple
                /*valueText: sliderValue < 6 ?
                               qsTr("车程较短") :
                               (sliderValue < 11 ?
                                    qsTr("车程较短") :
                                    (sliderValue < 15 ?
                                         qsTr("步行较少") :
                                         qsTr("步行较少")
                                     )
                                )*/
                label: "车程较短↔步行较少"// + sliderValue + " " + multiple
                /*Rectangle {
                    anchors.fill: parent
                    border.color: "white"
                    color: "transparent"
                }*/
                Component.onCompleted: {
                    //value = multiple
                }
                //onSliderValueChanged: multiple = sliderValue
                onDownChanged: multiple = sliderValue
            }
            IconButton {
                id: acceptbutton
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-certificates"
                onClicked: {
                    //multiple = slider.sliderValue
                    search()
                }
            }
            IconButton {
                id: closebutton
                anchors.verticalCenter: parent.verticalCenter
                icon.source: "image://theme/icon-m-close"
                onClicked: {
                    loader.sourceComponent = typebuttoncomponent
                }
            }
        }
    }
}


