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

import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.dbc 1.0
import untitled1.stationmodel 1.0
import ".."


Page {
    id: page

    Component.onCompleted: {
        console.log("count"+stationmodel.rowCount())
        //load_status = stationmodel.getdata()
    }

    Timer {
        interval: 1
        //running: true
        onTriggered: {
            //stationmodel.getfulllistdata()
            //appwindow.load_status = stationmodel.getmapdata()
            stop()
        }
    }

    // To enable PullDownMenu, place our content in a SilicaFlickable
    SilicaFlickable {
        anchors.fill: parent

        // PullDownMenu and PushUpMenu must be declared in SilicaFlickable, SilicaListView or SilicaGridView
        PullDownMenu {
            MenuItem {
                text: qsTr("Show Page 2")
                onClicked: pageStack.push(Qt.resolvedUrl("SecondPage.qml"))
            }
        }

        // Tell SilicaFlickable the height of its content.
        contentHeight: column.height

        // Place our content in a Column.  The PageHeader is always placed at the top
        // of the page, followed by our content.
        Column {
            id: column
            width: page.width
            spacing: Theme.paddingMedium
            PageHeader {
                id: header
                title: qsTr("Show Page 2")
            }

            Row {
                id: row
                ValueButton {
                    id: sourcebutton
                    width: column.width / 2
                    label: "起点"
                    value: "选择"
                    onClicked: openlistdialog()
                    property int source: 0
                    function openlistdialog() {
                        stationmodel.getfulllistdata()
                        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"))
                        dialog.accepted.connect(function() {
                            value = dialog.selected_station
                            source = dialog.selected_number
                        })
                    }
                }
                ValueButton {
                    id: destinationbutton
                    width: column.width / 2
                    label: "终点"
                    value: "选择"
                    onClicked: openlistdialog()
                    property int destination: 1
                    function openlistdialog() {
                        stationmodel.getfulllistdata()
                        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"))
                        dialog.accepted.connect(function() {
                            value = dialog.selected_station
                            destination = dialog.selected_number
                        })
                    }
                }
            }

            Button {
                id: button
                text: "出发"
                onClicked: {
                    console.log(sourcebutton.source+">"+destinationbutton.destination)
                    stationmodel.getfulllistdata()
                    stationmodel.search(sourcebutton.source,destinationbutton.destination)
                    //listmodel.update()
                    stationmodel.getroutelistdata()
                }
            }

            SilicaListView {
                id: listview
                width: parent.width
                height: page.height - header.height - row.height - button.height - column.spacing*3
                clip: true

                model: stationmodel/*ListModel {
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

                delegate: BackgroundItem {
                    Label {
                        id: namelabel
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                            verticalCenterOffset: actionlabel.visible ?
                                                      -namelabel.height / 2 :
                                                      0
                        }
                        //text: station_number + " " + station_name + " " + action + " " + line_name + " " + direction + "方向列车"
                        text: station_number + " " + station_name/*{
                            if(action === "" && direction ==="")
                                station_number + station_name
                            else if(action !== "" && direction === "")
                                station_number + station_name + action
                            else
                                station_number + station_name + action + line_name + direction + "方向"
                        }*/
                    }
                    Label {
                        id: actionlabel
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                            verticalCenterOffset: namelabel.height / 2
                        }
                        enabled: !(action === "" && direction ==="")
                        visible: !(action === "" && direction ==="")
                        text: {
                            if(action !== "" && direction === "")
                                action
                            else
                                action + line_name + direction + "方向列车"
                        }
                    }
                    onClicked: console.log("click")
                }
            }
        }
    }
}


