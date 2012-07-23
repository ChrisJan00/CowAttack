// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// Container for aliens
Item {
    id: aliensManager

    signal updateAlienPositions

    property int alienCount: 25
    property int arrayCountX: 10
    property int arrayCountY: 5
    property double alienSpeed: 2.5
    property int leftBound: 0
    property int rightBound: root.width
    property int topBound: grass.y
    property int bottomBound: root.height

    property double thresholdDistance : 4000
    Timer {
        id: updateTimer
        interval: heartBeat; running: true; repeat: true
        onTriggered: updateAlienPositions()
    }

    Repeater {
        model: alienCount
        delegate: Alien {
            alienIndex: index
            x: Math.floor((index%(arrayCountX+1))/arrayCountX*grass.width)
            y: Math.floor((Math.floor(index/arrayCountX))/arrayCountY*grass.height + grass.y)
            speedX: (index%2) * alienSpeed; speedY: ((index+1)%2) * alienSpeed
        }
    }
}
