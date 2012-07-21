// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: loseScreen
    anchors.fill: parent
    color: "gray"
    opacity: 0

    Image {
        id: losePic
        source: "../../gfx/cowfaceohno-400x580.png"
        anchors.centerIn: parent
        opacity: 0
    }

    function show() {
        endAnimation.start();
    }

    SequentialAnimation {
        id: endAnimation
        PropertyAnimation {
            target: loseScreen
            property: "opacity"
            from: 0
            to: 1
            duration: 2000
            easing.type: Easing.InQuad
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            target: losePic
            property: "opacity"
            to: 1
            duration: 1000
        }
    }

}
