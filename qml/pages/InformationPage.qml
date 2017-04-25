import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
    Flickable {
        anchors.fill: parent
        contentHeight: column.height
        Image {
            anchors {
                horizontalCenter: parent.horizontalCenter
                bottom: column.top
                bottomMargin: height
            }
            source: "image://theme/untitled1"
        }
        Column {
            id: column
            /*anchors {
                left: parent.left
                right: parent.right
                leftMargin: Theme.horizontalPageMargin
                rightMargin: Theme.horizontalPageMargin
            }*/
            width: parent.width
            spacing: Theme.paddingMedium
            PageHeader {
                title: "软件信息"
            }

            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: Theme.paddingLarge
                Image {
                    //anchors.horizontalCenter: parent.horizontalCenter
                    source: "image://theme/untitled1"
                }
                Column {
                    anchors.verticalCenter: parent.verticalCenter
                    Label {
                        text: "fsdafsdafds"
                        font.pixelSize: Theme.fontSizeLarge
                    }
                    Label {
                        text: "asfsd"
                        font.pixelSize: Theme.fontSizeSmall
                        color: Theme.secondaryColor
                    }
                }
            }

            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }
                text: "fsdf"
            }

            Label {
                anchors {
                    left: parent.left
                    right: parent.right
                    leftMargin: Theme.horizontalPageMargin
                    rightMargin: Theme.horizontalPageMargin
                }
                text: "sdfjslkdf"
            }
        }
    }
}
