import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: listpage
    property string searchString

    TestModel {
        id: originalmodel
    }

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: TestModel {
            id: testmodel

            function update() {
                clear()
                for (var i=0; i<originalmodel.count; i++) {
                    if (listview.headerItem.text == "" ||
                            originalmodel.get(i).station_number.indexOf(listview.headerItem.text) >= 0 ||
                            originalmodel.get(i).station.indexOf(listview.headerItem.text) >= 0) {
                        append({"line": originalmodel.get(i).line,
                               "station_number": originalmodel.get(i).station_number,
                               "station": originalmodel.get(i).station})
                    }
                }
            }
        }

        header: SearchField {
            id: searchField
            width: parent.width
            onTextChanged: testmodel.update()
        }

        section.property: "line"
        section.delegate: SectionHeader {
            text: section
        }

        delegate: BackgroundItem {
            Label {
                anchors {
                    verticalCenter: parent.verticalCenter
                    horizontalCenter: parent.horizontalCenter
                }
                text: station_number + " " + station
            }
            onClicked: console.log("click")
        }
    }
}

