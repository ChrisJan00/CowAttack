// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    id: mothership
//    width: 50
//    height: 30
//    color: "purple"
    x: parent.width / 2 - width/2
    y: 4 + incy
    property int incy

    source: "../../gfx/cowmothership-54x38.png"
    function update() {
    }

    SequentialAnimation {
        id: floatAnimation
        loops: Animation.Infinite
        running: true
        property int dur: 400
        PropertyAnimation {
            property: "incy"
            target: mothership
            from: -4
            to: 4
            easing.type: Easing.InOutSine
            duration: floatAnimation.dur
        }
        PauseAnimation { duration: floatAnimation.dur }
        PropertyAnimation {
            property: "incy"
            target: mothership
            from: 4
            to: -4
            easing.type: Easing.InOutSine
            duration: floatAnimation.dur
        }
        PauseAnimation { duration: floatAnimation.dur }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: spaceshipManager.recallShip()
    }
}
