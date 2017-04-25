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

    property var previous_colour: stationmodel.linecolourat(original_index - 1)
    Column {
        id: column1
        width: parent.width
        spacing: 0

        Loader {
            id: loader
            sourceComponent: count !== 0 ?
                                 stationcountlabelcomponent :
                                 undefined
        }

        Row {
            id: row
            height: rightcolumn.height
            width: parent.width
            spacing: Theme.paddingSmall
            //anchors.verticalCenter: parent.verticalCenter

            Item {
                id: iconitem
                height: parent.height
                width: Theme.paddingSmall
                Rectangle {
                    id: upperline
                    visible: action !== StationModel.Depart
                    anchors.bottom: parent.verticalCenter
                    height: parent.height / 2 - Theme.paddingSmall
                    width: Theme.paddingSmall
                    //radius: width / 2
                    color: action === StationModel.Arrive ?
                               Theme.rgba(line_colour, 0.7) :
                               Theme.rgba(previous_colour, 0.7)
                }
                Rectangle {
                    id: lowerline
                    visible: action !== StationModel.Arrive
                    anchors.top: parent.verticalCenter
                    height: parent.height / 2 - Theme.paddingSmall
                    width: Theme.paddingSmall
                    //radius: width / 2
                    color: Theme.rgba(line_colour, 0.7)
                }
            }

            Column {
                id: rightcolumn
                anchors.verticalCenter: parent.verticalCenter
                width: row.width - iconitem.width - row.spacing

                Label {
                    id: namelabel
                    width: parent.width
                    color: action !== StationModel.Arrive ?
                               Theme.highlightColor :
                               Theme.primaryColor
                    font.pixelSize: Theme.fontSizeSmall
                    text: station_name
                }
                Label {
                    id: actionlabel
                    width: parent.width
                    //wrapMode: Text.Wrap
                    //color: Theme.secondaryColor
                    truncationMode: TruncationMode.Fade
                    font.pixelSize: Theme.fontSizeExtraSmall
                    text: action === StationModel.Arrive ?
                              qsTr("到达") :
                              qsTr("%1→%2").arg(line_name).arg(towards)
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

    Component {
        id: stationcountlabelcomponent
        Row {
            //visible: count !== 0
            //height: stationcountlabel.height
            //width: parent.width
            spacing: Theme.paddingSmall

            /*Rectangle {
                id: viastationline
                height: parent.height// / 3
                width: Theme.paddingSmall
                anchors.verticalCenter: parent.verticalCenter
                color: previous_colour
            }*/

            Label {
                id: stationcountlabel
                //anchors.horizontalCenter: parent.horizontalCenter
                //width: parent.width
                color: Theme.secondaryColor
                font.pixelSize: Theme.fontSizeTiny
                text: qsTr("%1 个站").arg(count)
            }
        }
    }
}
