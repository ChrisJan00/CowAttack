// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 500
    height: 700

    Rectangle {
        id: sky
        color: "blue"
        width: parent.width
        height: 200
    }

    Rectangle {
        id: grass
        color: "green"
        width: parent.width
        anchors.top: sky.bottom
        anchors.bottom: parent.bottom
    }


    SpaceshipManager {
        anchors.fill: parent
    }

}
