import QtQuick 2.0
import Sailfish.Silica 1.0
import ".."

Page {
    id: listpage
    property string searchString

    SilicaListView {
        id: listview
        anchors.fill: parent
        model: TestModel {
            id: testmodel

            function update() {
                clear()
                for (var i=0; i<testmodel.count; i++) {
                    if (searchField.text == "" || testmodel.get(i).station_number.indexOf(searchField.text) >= 0) {
                        append({"line": testmodel.get(i).line,
                               "station_number": testmodel.get(i).station_number,
                               "station": testmodel.get(i).station})
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

