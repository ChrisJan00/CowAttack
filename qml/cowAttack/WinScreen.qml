// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: winScreen
    anchors.fill: parent
//    color: "gray"
//    opacity: 0

    Image {
        id: curtain
        source: "../../gfx/backgroundover-900x500-milk.png"
        y: -height
    }

    Image {
        id: winPic
        source: "../../gfx/cowfacehappy-340x420.png"
        anchors.centerIn: parent
        opacity: 0
    }

    MouseArea {
        id: mouseEater
        anchors.fill: parent
        enabled: false
    }

    function show() {
        mouseEater.enabled = true;
        endAnimation.start();
    }

    SequentialAnimation {
        id: endAnimation
        PropertyAnimation {
            target: curtain
            property: "y"
            from: -curtain.height
            to: 0
            duration: 4000
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            target: winPic
            property: "opacity"
            to: 1
            duration: 1000
        }
    }

}
