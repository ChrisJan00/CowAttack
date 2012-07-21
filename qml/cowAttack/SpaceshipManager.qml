// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: spaceshipManager

    property int selectedScoutIndex: 0

    property int mothershipX: motherShip.x + motherShip.width / 2 - 28
    property int mothershipY: motherShip.y + motherShip.height / 2 + 100 - 26
    property alias motherMilk: motherShip.milk

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
        x: 29
        y: grass.y + 26
        width: grass.width - 58
        height: grass.height - 52
        onClicked: {
            destX = mouseX;
            destY = mouseY + y - 26;
            moveScout();
        }
    }

    property int scoutCount: 3
    property int liveScoutCount: scoutCount
    onLiveScoutCountChanged: {
        if (liveScoutCount == 0)
            loseScreen.show();
    }

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
