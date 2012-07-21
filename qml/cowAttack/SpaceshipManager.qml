// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: spaceshipManager

    property int selectedScoutIndex: -1

    signal moveScout
    signal updateSpaceships
    property int destX
    property int destY

    // mothership
    Mothership {
        id: motherShip
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

    property int scoutCount: 2

    // scouts
    Repeater {
        model: scoutCount
        delegate: Scout {
            scoutIndex: index
            x: index * 40
            y: 100
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
