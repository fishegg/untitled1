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
                    width: column.width / 2
                    label: "起点"
                    value: "选择"
                    onClicked: openlistdialog()
                    function openlistdialog() {
                        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"))
                        dialog.accepted.connect(function() {
                            value = dialog.selected_station
                        })
                    }
                }
                ValueButton {
                    width: column.width / 2
                    label: "终点"
                    value: "选择"
                    onClicked: openlistdialog()
                    function openlistdialog() {
                        var dialog = pageStack.push(Qt.resolvedUrl("StationsListDialog.qml"))
                        dialog.accepted.connect(function() {
                            value = dialog.selected_station
                        })
                    }
                }
            }

            SilicaListView {
                id: listview
                width: parent.width
                height: page.height - header.height - row.height - column.spacing*2
                clip: true

                model: stationmodel

                section.property: "line_name"
                section.delegate: SectionHeader {
                    text: section
                }

                delegate: BackgroundItem {
                    Label {
                        anchors {
                            verticalCenter: parent.verticalCenter
                            horizontalCenter: parent.horizontalCenter
                        }
                        text: station_number + " " + station_name
                    }
                    onClicked: console.log("click")
                }
            }
        }
    }
}


