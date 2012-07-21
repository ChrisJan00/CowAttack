// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: scout
    width: 20
    height: 20
    color: "gray"

    property int scoutIndex: 0
    property bool selected: spaceshipManager.selectedScoutIndex == scoutIndex

    Connections {
        target: spaceshipManager
        onMoveScout: {
            if (selected) {
                x = spaceshipManager.destX;
                y = spaceshipManager.destY;
            }
        }
    }

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
