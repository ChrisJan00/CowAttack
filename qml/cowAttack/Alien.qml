// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.particles 1.0

Item {
    id: alien

    property int alienIndex;
    property int speedX: 0;
    property int speedY: 0;
    property bool move: true;
    property int victimCow: -1

    Image {
        id: sprite
        source: "../../gfx/alien-16x32-right.png"
        Component.onCompleted: rectifyPosition()
    }

    function updatePosition() {
        checkDistanceFromCowScouts();
        if (!move)
            return;
        x += speedX;
        y += speedY;
        rectifyPosition();
    }

    function rectifyPosition() {
        if ((x + sprite.width) > aliensManager.rightBound) {
            x = aliensManager.rightBound - sprite.width;
            speedX = -speedX;
        }
        if ((y + sprite.height) > aliensManager.bottomBound) {
            y = aliensManager.bottomBound - sprite.height;
            speedY = -speedY;
        }

        if (x < aliensManager.leftBound) {
            x = aliensManager.leftBound;
            speedX = -speedX;
        }
        if (y < aliensManager.topBound) {
            y = aliensManager.topBound;
            speedY = -speedY;
        }
    }

    function checkDistanceFromCowScouts() {
        var distanceToCowScout = aliensManager.thresholdDistance;
        var nearestCow = -1;
        for (var i = 0; i < cowPositions.count; ++i) {
            var cowPosition = cowPositions.get(i);
            if (cowPosition.active) {
                var distance = Math.pow(cowPosition.x - x, 2) +
                        Math.pow(cowPosition.y - y, 2);
                if (distance < distanceToCowScout) {
                    distanceToCowScout = distance
                    nearestCow = i;
                }
            }
        }
        if (nearestCow >= 0) {
            move = false;
            victimCow = nearestCow;
        }
        else
            move = true;
    }

    Connections {
        target: aliensManager
        onUpdateAlienPositions: updatePosition()
    }

    Component.onCompleted: {
        if (Math.random() > 0.5) {
            speedX = -speedX;
            speedY = -speedY;
        }
    }

    Particles {
        id: emitter
        parent: root
        width: 1
        height: 1
        source: "../../gfx/lasershot-3x1.png"
        lifeSpan: 1000
        count: 1
        emissionRate: 0
        angle: 0;
        rotation: 0
        angleDeviation: 0
        velocity: 100
    }

    Timer {
        running: !move
        repeat: true
        interval: 1000
        onTriggered: {
            if (!cowPositions.get(victimCow).active)
                return;
            emitter.x = x + width/2;
            emitter.y = y + height/2;
            emitter.rotation = getCowAngle(victimCow);
            emitter.burst(1);
            root.whichCow = victimCow
            root.cowIsShot();
        }
    }

    function getCowAngle(cowIndex)
    {
        var cowX = cowPositions.get(cowIndex).x;
        var cowY = cowPositions.get(cowIndex).y;
        if (cowX != x)
            return Math.atan2(cowY - y - alien.width/2, cowX - x - alien.height/2) * 180/ Math.PI;
        else
            return cowY < y? 0 : 180;
    }
}
