// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: root
    width: 500
    height: 700

    property int heartBeat: 100


    ListModel {
        id: cowPositions
        ListElement {
            active: false
            x: 0
            y: 0
        }
        ListElement {
            active: false
            x: 0
            y: 0
        }
        ListElement {
            active: false
            x: 0
            y: 0
        }
    }

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


    SpaceshipManager {
        anchors.fill: parent
    }


    AliensManager {
        anchors.fill: parent
    }
}
