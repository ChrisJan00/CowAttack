// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// Container for aliens
Item {
    id: aliensManager

    signal updateAlienPositions

    property int alienCount: 25
    property int arrayCount: 5
    property double alienSpeed: 1.5
    property variant xPos: [0,125,250,375,500]
    property variant yPos: [200,325,450,575,700]
    property int leftBound: 0
    property int rightBound: 500
    property int topBound: 200
    property int bottomBound: 700

    property double thresholdDistance : 10000
    Timer {
        id: updateTimer
        interval: heartBeat; running: true; repeat: true
        onTriggered: updateAlienPositions()
    }

    Repeater {
        model: alienCount
        delegate: Alien {
            alienIndex: index
            x: xPos[index%arrayCount]; y: yPos[Math.floor(index/arrayCount)]
            speedX: (index%2) * alienSpeed; speedY: ((index+1)%2) * alienSpeed
        }
    }
}
