// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: scout
    width: shipPic.width
    height: shipPic.height

    property int scoutIndex: 0
    property bool selected: spaceshipManager.selectedScoutIndex == scoutIndex
    property int destX
    property int destY
    property int floatHeight: 100

    Connections {
        target: spaceshipManager
        onMoveScout: {
            if (selected) {
                destX = spaceshipManager.destX;
                destY = spaceshipManager.destY;
            }
        }

        onUpdateSpaceships: {
            var stepSize = 10
            var incx = Math.min(stepSize, Math.max(-stepSize, destX - x) );
            var incy = Math.min(stepSize, Math.max(-stepSize, destY - y) );
            x += incx;
            y += incy;
        }

        onRecallShip: {
            if (selected) {
                destX = mothershipX
                destY = mothershipY + floatHeight
            }
        }

    }

    Behavior on x { NumberAnimation { duration: heartBeat } }
    Behavior on y { NumberAnimation { duration: heartBeat } }

    Image {
        id: shipPic
        source: "../../gfx/cowscout-38x24-left.png"
//        width: parent.width
//        height: parent.height
        y: -floatHeight + incy
        property int incy: 0

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "yellow"
            visible: scout.selected
        }


        MouseArea {
            anchors.fill: parent
            onClicked: {
                spaceshipManager.selectedScoutIndex = scoutIndex
            }
        }

        SequentialAnimation {
            id: floatAnimation
            loops: Animation.Infinite
            running: true
            property int dur: 200 + Math.random() * 20
            PropertyAnimation {
                property: "incy"
                target: shipPic
                from: -2
                to: 2
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
            PropertyAnimation {
                property: "incy"
                target: shipPic
                from: 2
                to: -2
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
        }
    }

    Image {
        id: shadow
        source: "../../gfx/cowscoutshadow-38x24-left.png"
        width: parent.width
        height: parent.height
        opacity: Math.max(0, Math.min(1, (scout.y - grass.y)/50));
    }

    function update() {
    }
}
