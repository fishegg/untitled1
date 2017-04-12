import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.stationmodel 1.0

Item {
    id: root
    /*contentHeight: column.height > Theme.itemSizeSmall ?
                       column.height:
                       Theme.itemSizeSmall*/
    width: parent.width
    height: column1.height
    Column {
        id: column1
        width: parent.width

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            visible: count !== 0
            //width: parent.width
            color: Theme.secondaryColor
            font.pixelSize: Theme.fontSizeTiny
            text: count + "个站"
        }
        Row {
            id: row
            height: column2.height
            width: parent.width
            spacing: Theme.paddingMedium
            //anchors.verticalCenter: parent.verticalCenter
            Rectangle {
                id: line
                anchors.verticalCenter: parent.verticalCenter
                height: parent.height - Theme.paddingSmall
                width: Theme.paddingSmall
                radius: width / 2
                color: line_colour
            }
            Column {
                id: column2
                anchors.verticalCenter: parent.verticalCenter
                width: row.width - line.width - row.spacing

                Label {
                    id: namelabel
                    width: parent.width
                    color: Theme.highlightColor
                    //font.pixelSize: Theme.fontSizeSmall
                    text: station_name
                }
                Label {
                    id: actionlabel
                    width: parent.width
                    wrapMode: Text.Wrap
                    //color: Theme.secondaryColor
                    font.pixelSize: Theme.fontSizeTiny
                    property string _line_name: line_name
                    property string _towards: towards
                    text: action === StationModel.Arrive ?
                              qsTr("到达") :
                              qsTr("%1 %2方向").arg(_line_name).arg(_towards)
                    /*{
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
                    }*/
                }
            }
        }
    }
}
