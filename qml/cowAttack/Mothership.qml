// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: mothership
    x: parent.width / 2 - width/2
    width: motherPic.width

    property int milk
    property int milkMax

    Image {
        id: motherPic
        y: incy
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
                target: motherPic
                from: -4
                to: 4
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
            PropertyAnimation {
                property: "incy"
                target: motherPic
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

    Rectangle {
        border.width: 1
        border.color: "black"
        color: "purple"
        visible: milk > 0
        width: milk / milkMax * mothership.width
        height: 4
        y : -8
        Rectangle {
            border.width: 1
            border.color: "black"
            color: "transparent"
            width: mothership.width
            height: parent.height
        }
    }
}
