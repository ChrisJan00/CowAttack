// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: scout
    width: 64
    height: 64

    property int scoutIndex: 0
    property bool selected: spaceshipManager.selectedScoutIndex == scoutIndex
    property int destX
    property int destY

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
    }

    Behavior on x { NumberAnimation { duration: heartBeat } }
    Behavior on y { NumberAnimation { duration: heartBeat } }

    Rectangle {
        id: shipPic
        color: "purple"
        width: parent.width
        height: parent.height
        y: -100 + incy
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
                from: -4
                to: 4
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PropertyAnimation {
                property: "incy"
                target: shipPic
                from: 4
                to: -4
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
        }
    }

    Rectangle {
        id: shadow
        color: "gray"
        width: parent.width
        height: parent.height
        opacity: Math.max(0, Math.min(1, (scout.y - grass.y)/50));
    }

    function update() {
    }
}
