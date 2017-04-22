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

    property int from: -1
    property int to: -1
    property int preference: 0

    function openlistdialog() {
        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"),
                                    {selected_from_number: from,
                                    selected_to_number: to
                                    })
        dialog.accepted.connect(function() {
            frombutton.value = dialog.selected_from_station_number + " " + dialog.selected_from_station_name
            from = dialog.selected_from_number
            tobutton.value = dialog.selected_to_station_number + " " + dialog.selected_to_station_name
            to = dialog.selected_to_number
            if(from !== -1 && to !== -1) {
                stationmodel.search(from,to,preference)
                //stationmodel.getroutelistdata()
                touchblocker.enabled = true
                timer.start()
            }
        })
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
        interval: 600
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
                text: "选择出发站及目的站"
                onClicked: {
                    from = -1
                    to = -1
                    openlistdialog()
                }
            }
            MenuItem {
                visible: from !== -1 && to !== -1
                //enabled: from !== -1 && to !== -1
                text: "出发站↔目的站"
                property var t
                onClicked: {
                    t = to
                    to = from
                    from = t
                    t = tobutton.value
                    tobutton.value = frombutton.value
                    frombutton.value = t
                    stationmodel.search(from,to,preference)
                    //stationmodel.getroutelistdata()
                    touchblocker.enabled = true
                    timer.start()
                }
            }
        }

        PushUpMenu {
            visible: flickable.contentHeight > flickable.height + 1
            MenuItem {
                visible: from !== -1 && to !== -1
                //enabled: from !== -1 && to !== -1
                text: "出发站↔目的站"
                property var t
                onClicked: {
                    t = to
                    to = from
                    from = t
                    t = tobutton.value
                    tobutton.value = frombutton.value
                    frombutton.value = t
                    flickable.scrollToTop()
                    stationmodel.search(from,to,preference)
                    //stationmodel.getroutelistdata()
                    touchblocker.enabled = true
                    timer.start()
                }
            }
            MenuItem {
                text: "选择出发站及目的站"
                onClicked: {
                    from = -1
                    to = -1
                    openlistdialog()
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
                title: qsTr("Show Page 2𧒽") + listview.contentItem.height + "\u274BD"
            }

            Row {
                id: row
                width: parent.width
                ValueButton {
                    id: frombutton
                    width: parent.width / 2
                    label: "出发站"
                    value: "选择"
                    onClicked: {
                        from = -1
                        openlistdialog()
                    }
                }
                ValueButton {
                    id: tobutton
                    width: parent.width / 2
                    label: "目的站"
                    value: "选择"
                    onClicked: {
                        to = -1
                        openlistdialog()
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

            Row {
                //anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width// - Theme.horizontalPageMargins
                //spacing: Theme.paddingSmall
                height: Theme.itemSizeExtraSmall
                BackgroundItem {
                    id: type0button
                    width: parent.width / 4
                    highlighted: preference === 0
                    Label {
                        anchors.centerIn: parent
                        color: type0button.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: "换乘方便"
                    }
                    onReleased: {
                        preference = 0
                        highlighted = preference === 0
                        type1button.highlighted = false
                        type2button.highlighted = false
                        type3button.highlighted = false
                        if(from !== -1 && to !== -1) {
                            stationmodel.search(from,to,preference)
                            //stationmodel.getroutelistdata()
                            touchblocker.enabled = true
                            timer.start()
                        }
                    }
                    /*onPressed: {
                        highlighted = !highlighted
                    }*/
                }
                BackgroundItem {
                    id: type1button
                    width: parent.width / 4
                    highlighted: preference === 1
                    Label {
                        anchors.centerIn: parent
                        color: type1button.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: "换乘少"
                    }
                    onReleased: {
                        preference = 1
                        highlighted = preference === 1
                        type0button.highlighted = false
                        type2button.highlighted = false
                        type3button.highlighted = false
                        if(from !== -1 && to !== -1) {
                            stationmodel.search(from,to,preference)
                            //stationmodel.getroutelistdata()
                            touchblocker.enabled = true
                            timer.start()
                        }
                    }
                }
                BackgroundItem {
                    id: type2button
                    width: parent.width / 4
                    highlighted: preference === 2
                    Label {
                        anchors.centerIn: parent
                        color: type2button.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: "车程短"
                    }
                    onReleased: {
                        preference = 2
                        highlighted = preference === 2
                        type0button.highlighted = false
                        type1button.highlighted = false
                        type3button.highlighted = false
                        if(from !== -1 && to !== -1) {
                            stationmodel.search(from,to,preference)
                            //stationmodel.getroutelistdata()
                            touchblocker.enabled = true
                            timer.start()
                        }
                    }
                }
                BackgroundItem {
                    id: type3button
                    width: parent.width / 4
                    highlighted: preference === 3
                    Label {
                        anchors.centerIn: parent
                        color: type3button.highlighted ? Theme.highlightColor : Theme.primaryColor
                        text: "平衡"
                    }
                    onReleased: {
                        preference = 3
                        highlighted = preference === 3
                        type0button.highlighted = false
                        type1button.highlighted = false
                        type2button.highlighted = false
                        if(from !== -1 && to !== -1) {
                            stationmodel.search(from,to,preference)
                            //stationmodel.getroutelistdata()
                            touchblocker.enabled = true
                            timer.start()
                        }
                    }
                }
            }

            SilicaListView {
                id: listview
                width: parent.width
                //height: page.height - header.height - row.height - button.height - column.spacing*3
                height: contentItem.height
                //clip: true
                //visible: count < 150
                boundsBehavior: Flickable.StopAtBounds

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
                    text: "下拉或者点击<br>选择出发站及目的站"
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
}


