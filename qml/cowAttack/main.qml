// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 500
    height: 700

    property int heartBeat: 100

    Rectangle {
        id: sky
        color: "blue"
        width: parent.width
        height: 200
        gradient: Gradient {
            GradientStop { position: 0.0; color:"darkBlue"}
            GradientStop { position: 1.0; color:"blue"}
        }
    }

    Rectangle {
        id: grass
        color: "green"
        width: parent.width
        anchors.top: sky.bottom
        anchors.bottom: parent.bottom
        gradient: Gradient {
            GradientStop { position: 0.0; color:"green"}
            GradientStop { position: 1.0; color:Qt.darker("green")}
        }
    }

//    Image {
//        id: background
//        source: "../../gfx/surface-500x700-withsky.png"

//        Grid {
//            y: 200
//            columns: 6
//            Repeater {
//                model: 60
//                delegate: Image { source: "../../gfx/grass-78x46.png" }
//            }
//        }

//        Grid {
//            x: 39
//            y: 223
//            columns: 6
//            Repeater {
//                model: 54
//                delegate: Image { source: "../../gfx/grass-78x46.png" }
//            }
//        }
//    }


//    Item {
//        id: grass
//        width: parent.width
//        y: 200
//        height: parent.height - y
//    }


    SpaceshipManager {
        anchors.fill: parent
    }

}
