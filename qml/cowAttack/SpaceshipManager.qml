// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: spaceshipManager

    property int selectedScoutIndex: 0

    property alias mothershipX: motherShip.x
    property alias mothershipY: motherShip.y

    signal moveScout
    signal updateSpaceships
    signal recallShip
    property int destX
    property int destY

    // mothership
    Mothership {
        id: motherShip
        y: 20
    }

    MouseArea {
        id: scoutControl
        x: 0
        y: grass.y
        width: grass.width
        height: grass.height
        onClicked: {
            destX = mouseX;
            destY = mouseY + y;
            moveScout();
        }
    }

    property int scoutCount: 3

    // scouts
    Repeater {
        model: scoutCount
        delegate: Scout {
            scoutIndex: index
            x: 40 + index * 140
            y: 200 + Math.random() * 100
            destX: x
            destY: y
        }
    }

    Timer {
        running: true
        repeat: true
        onTriggered: updateSpaceships();
        interval: heartBeat
    }
}
