// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: scout
    width: 64
    height: 64
    color: "gray"

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
        anchors.fill: parent
        color: "transparent"
        border.width: 1
        border.color: "yellow"
        visible: parent.selected
    }

    function update() {
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            spaceshipManager.selectedScoutIndex = scoutIndex
        }
    }
}
