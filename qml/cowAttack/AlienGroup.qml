// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

// Container for aliens
Item {
    id: alienGroup

    signal updateAlienPosition()

    function position() {
        this.x = 0;
        this.y = 0;
    }

    function spawn() {
        updateTimer.start();
    }

    function getNextRallyPosition(x, y) {
        var possibleRallyPositions = nextRallyPositionsForRally()
    }

    Timer {
        id: updateTimer
        interval: 100; running: false; repeat: true
        onTriggered: {
            updateAlienPosition();
//            for (var i = 0; i < aliens.count; ++i) {
//                var alien = aliens.get(i);
//                alien.updatePosition();
////                if (alien.hasReachedRallyPoint()) {
////                    var rallyPosition = getNextRallyPosition(alien.x, alien.y);
////                    alien.distanceToRallyX = rallyPosition.x - alien.x;
////                    alien.distanceToRallyY = rallyPosition.y - alien.y;

////                    if ((alien.distanceToRallyX < 0 && alien.speedX > 0) ||
////                            (alien.distanceToRallyX > 0 && alien.speedX < 0))
////                        alien.speedX = -alien.speedX;
////                    if ((alien.distanceToRallyY < 0 && alien.speedY > 0) ||
////                            (alien.distanceToRallyY > 0 && alien.speedY < 0))
////                        alien.speedY = -alien.speedY;
////                }
//            }
        }
    }

    Repeater {
        model: 1
        delegate: Alien {
            x: 0; y: 200
            speedX: (index%2) * 1.5; speedY: ((index+1)%2) * 1.5
        }
    }

    Component.onCompleted: spawn()
}
