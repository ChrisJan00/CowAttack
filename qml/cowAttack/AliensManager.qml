// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// Container for aliens
Item {
    id: aliensManager

    signal updateAlienPositions

    property int alienCount: 9
    property variant xPos: [0,250,500]
    property variant yPos: [200,450,700]

    Timer {
        id: updateTimer
        interval: heartBeat; running: true; repeat: true
        onTriggered: updateAlienPositions()
    }

    Repeater {
        model: alienCount
        delegate: Alien {
            alienIndex: index
            x: xPos[index%3]; y: yPos[Math.floor(index/3)]
            speedX: (index%2) * 1.5; speedY: ((index+1)%2) * 1.5
        }
    }
}
