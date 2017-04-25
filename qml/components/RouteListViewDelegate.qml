import QtQuick 2.0
import Sailfish.Silica 1.0
import untitled1.stationmodel 1.0

ListItem {
    id: root
    contentHeight: column.height > Theme.itemSizeSmall ?
                       column.height:
                       Theme.itemSizeSmall
    Row {
        height: parent.height
        width: parent.width - Theme.horizontalPageMargin
        anchors.verticalCenter: parent.verticalCenter
        Item {
            id: iconitem
            height: parent.height
            width: Theme.iconSizeLarge

            Rectangle {
                id: icon
                z: 2
                anchors.verticalCenter: parent.verticalCenter
                width: Theme.paddingLarge
                height: width
                radius: width / 2
                color: line_colour
                anchors.horizontalCenter: parent.horizontalCenter
            }
            Rectangle {
                id: upperline
                visible: action !== StationModel.Depart
                width: /*(action === StationModel.Transfer) ?
                           Theme.paddingMedium :*/
                           Theme.paddingMedium
                height: root.contentHeight / 2
                color: line_colour
                anchors {
                    bottom: icon.verticalCenter
                    horizontalCenter: icon.horizontalCenter
                }
            }
            Rectangle {
                id: lowerline
                visible: action !== StationModel.Arrive
                width: /*(action === StationModel.GetOffTransfer) ?
                           Theme.paddingMedium :*/
                           Theme.paddingMedium
                height: root.contentHeight / 2// + contextmenu.height
                color: line_colour
                anchors {
                    top: icon.verticalCenter
                    horizontalCenter: icon.horizontalCenter
                }
            }

            Rectangle {
                id: iconbackground
                z: (action === StationModel.GetOff ||
                    action === StationModel.Transfer ||
                    action === StationModel.ExitTransfer) ?
                       1 :
                       -1
                anchors.centerIn: icon
                width: (action === StationModel.GetOff ||
                        action === StationModel.Transfer ||
                        action === StationModel.Exit ||
                        action === StationModel.ExitTransfer) ?
                           icon.width + Theme.paddingMedium :
                           icon.width + Theme.paddingSmall
                height: width
                radius: width / 2
                color: (action === StationModel.GetOff ||
                        action === StationModel.Exit) ?
                           Theme.rgba(stationmodel.linecolourat(index + 1), 0.7) :
                           ((action === StationModel.Transfer ||
                            action === StationModel.ExitTransfer) ?
                                Theme.rgba(stationmodel.linecolourat(index - 1), 0.7) :
                                Theme.secondaryColor)
            }
            Rectangle {
                id: upperlinebackground
                z: -1
                anchors.centerIn: upperline
                visible: upperline.visible
                width: upperline.width + Theme.paddingSmall
                height: upperline.height
                color: Theme.secondaryColor
            }
            Rectangle {
                id: lowerlinebackground
                z: -1
                anchors.centerIn: lowerline
                visible: lowerline.visible
                width: lowerline.width + Theme.paddingSmall
                height: lowerline.height
                color: Theme.secondaryColor
            }
        }

        Column {
            id: column
            anchors.verticalCenter: parent.verticalCenter
            width: row.width - iconitem.width
            Label {
                id: namelabel
                width: parent.width
                color: ((action !== StationModel.OnTrain &&
                        action !== StationModel.GetOff &&
                        action !== StationModel.Exit &&
                        action !== StationModel.Arrive) ||
                       root.highlighted) ?
                           Theme.highlightColor:
                           Theme.primaryColor
                text: station_number + " " + station_name
            }
            Loader {
                id: loader
                width: parent.width
                sourceComponent: action !== StationModel.OnTrain ?
                                     actionlabelcomponent :
                                     undefined
            }
        }
    }

    Component {
        id: actionlabelcomponent
        Label {
            id: actionlabel
            wrapMode: Text.Wrap
            //visible: action != StationModel.OnTrain
            color: !root.highlighted ?
                       Theme.secondaryColor :
                       Theme.secondaryHighlightColor
            font.pixelSize: Theme.fontSizeSmall
            text: action === StationModel.Depart ?
                      qsTr("在 %1入闸处 入闸<br>乘坐 %2 %3方向 列车").arg(line_name).arg(line_name).arg(towards) :
                      (action === StationModel.GetOff ?
                           qsTr("下车") :
                           (action === StationModel.Transfer ?
                                qsTr("换乘 %1 %2方向 列车").arg(line_name).arg(towards) :
                                (action === StationModel.Exit ?
                                     qsTr("下车，出闸") :
                                     (action === StationModel.ExitTransfer ?
                                          qsTr("在 %1入闸处 入闸<br>换乘 %2 %3方向 列车").arg(line_name).arg(line_name).arg(towards) :
                                          (action === StationModel.Arrive ?
                                               qsTr("下车，到达") :
                                               "")
                                      )
                                 )
                            )
                       )/*{
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

    /*menu: ContextMenu {
        id: contextmenu
        MenuItem {
            text: "haha"
        }
    }*/
}
