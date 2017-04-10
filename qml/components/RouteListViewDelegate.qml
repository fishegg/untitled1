import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.stationmodel 1.0

ListItem {
    id: root
    contentHeight: column.height > Theme.itemSizeSmall ?
                       column.height:
                       Theme.itemSizeSmall
    property int last_index;
    Row {
        height: parent.height
        //width: parent.width
        anchors.verticalCenter: parent.verticalCenter
        Item {
            id: item
            height: parent.height
            width: Theme.iconSizeLarge

            Rectangle {
                id: icon
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.paddingLarge
                height: width
                radius: width / 2
                color: Theme.highlightColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                id: upperline
                visible: index != 0
                width: Theme.paddingMedium
                height: root.contentHeight / 2
                color: Theme.highlightColor
                anchors {
                    bottom: icon.verticalCenter
                    horizontalCenter: icon.horizontalCenter
                }
            }
            Rectangle {
                id: lowerline
                visible: index != last_index
                width: Theme.paddingMedium
                height: root.contentHeight / 2// + contextmenu.height
                color: Theme.highlightColor
                anchors {
                    top: icon.verticalCenter
                    horizontalCenter: icon.horizontalCenter
                }
            }
        }

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter
            Label {
                id: namelabel
                //color: Theme.highlightColor
                text: station_number + " " + station_name
            }
            Label {
                id: actionlabel
                visible: action != StationModel.OnTrain
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeSmall
                property string line: line_name
                property string toward: direction
                text: {
                    if(action == StationModel.Depart)
                        qsTr("乘坐 %1 往%2方向 列车").arg(line).arg(toward)
                    else if(action == StationModel.GetoffTransfer)
                        qsTr("下车")
                    else if(action == StationModel.Transfer)
                        qsTr("换乘 %1 往%2方向 列车").arg(line).arg(toward)
                    else if(action == StationModel.Exit)
                        qsTr("下车，出闸")
                    else if(action == StationModel.ExitTransfer)
                        //action + " " + line_name + " 往" + direction + "方向 列车"
                        qsTr("%1入闸，换乘 %2 往%3方向 列车").arg(line).arg(line).arg(toward)
                    else if(action == StationModel.Arrive)
                        qsTr("下车，到达")
                }
            }
        }
    }

    menu: ContextMenu {
        id: contextmenu
        MenuItem {
            text: "haha"
        }
    }
}
