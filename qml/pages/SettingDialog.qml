import QtQuick 2.0
import Sailfish.Silica 1.0

Dialog {
    SilicaFlickable {
        anchors.fill: parent
        contentHeight: column.height
        Column {
            id: column
            width: parent.width
            DialogHeader {

            }
            ComboBox {
                label: "fsjdl"
                menu: ContextMenu {
                    MenuItem {
                        text: "fjsdf"
                    }
                    MenuItem {
                        text: "fsdklj"
                    }
                }
            }
            ComboBox {
                label: "fsdjlkf"
                menu: ContextMenu {
                    MenuItem {
                        text: "fsdjl"
                    }
                }
            }
            Slider {
                minimumValue: 0
                maximumValue: 100
                width: parent.width
                valueText: sliderValue
            }
        }
    }
}
