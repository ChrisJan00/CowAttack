/***************************************************************************/
/* This file is part of Attack of the Cows from outer Space.               */
/*                                                                         */
/*    Attack of the Cows from outer Space is free software: you can        */
/*    redistribute it and/or modify it under the terms of the GNU General  */
/*    Public License as published by the Free Software Foundation, either  */
/*    version 3 of the License, or (at your option) any later version.     */
/*                                                                         */
/*    Attack of the Cows from outer Space is distributed in the hope that  */
/*    it will be useful, but WITHOUT ANY WARRANTY; without even the        */
/*    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      */
/*    PURPOSE.  See the GNU General Public License for more details.       */
/*                                                                         */
/*    You should have received a copy of the GNU General Public License    */
/*    along with Attack of the Cows from outer Space.  If not,             */
/*    see <http://www.gnu.org/licenses/>.                                  */
/***************************************************************************/

import QtQuick 1.1
import Qt.labs.particles 1.0
import SDLMixerWrapper 1.0

Item {
    id: alien

    property int alienIndex;
    property real speedX: 0;
    property real speedY: 0;
    property real posx;
    property real posy;
    property bool move: true;
    property bool wasMoving: false;
    property bool speedUpdate: true;
    property int victimCow: -1
    property bool wasLookingLeft: false

    width: sprite.width
    height: sprite.height

    Image {
        id: sprite
        source: ":/gfx/alien-16x32-right.png"
        Component.onCompleted: rectifyPosition();
    }

    SoundClip {
        id: shootSound
        source: "sfx/gun-piu.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: targetSound
        source: "sfx/targeting.ogg"
        volume: sfxVolume
    }

    states: [
        State {
            name: "lookleft"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-left.png"
            }
        },
        State {
            name: "lookright"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-right.png"
            }
        },
        State {
            name: "lookup"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-up.png"
            }
        },
        State {
            name: "shootleft"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-left-withgun.png"
            }
        },
        State {
            name: "shootright"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-right-withgun.png"
            }
        },
        State {
            name: "shootup"
            PropertyChanges {
                target: sprite
                source: ":/gfx/alien-16x32-up-withgun.png"
            }
        }
    ]

    x: posx
    y: posy
    Behavior on x { NumberAnimation { duration: heartBeat } }
    Behavior on y { NumberAnimation { duration: heartBeat } }

    function updateSprite() {
        if (move) {
            if (!speedUpdate && wasMoving)
                return;
            wasMoving = true;
            speedUpdate = false;
            if (speedY < 0) {
                state = "lookup";
                return;
            }
            if (speedX < 0) {
                state = "lookleft";
                wasLookingLeft = true;
                return;
            }
            if (speedX > 0) {
                state = "lookright";
                wasLookingLeft = false;
                return;
            }
            // default
            state = wasLookingLeft ? "lookleft" : "lookright";
        } else {
            if (victimCow == -1)
                return;
            var cowAngle = getCowAngle(victimCow);

            // skip tests if I'm already shooting
            if (!wasMoving)
                return;
            wasMoving = false;

            if (cowAngle <= -45 && cowAngle >= -135) {
                state = "shootup";
                return;
            }
            if (cowPositions.get(victimCow).x < alien.posx) {
                state = "shootleft";
                return;
            }
            if (cowPositions.get(victimCow).x > alien.posx) {
                state = "shootright";
                return;
            }
            state = wasLookingLeft ? "shootleft" : "shootright";
        }
    }

    function updatePosition() {
        checkDistanceFromCowScouts();
        if (!move) {
            updateSprite();
            return;
        }
        posx += speedX;
        posy += speedY;
        rectifyPosition();
        updateSprite();
    }

    property bool alreadyChanged: false
    function rectifyPosition() {
        if (!alreadyChanged && isInNode()) {
            alreadyChanged = true;
            speedUpdate = true;
            switch (Math.floor(Math.random()*4)) {
            case 0: {
                speedX = alienSpeed;
                speedY = 0;
                break;
            }
            case 1: {
                speedX = -alienSpeed;
                speedY = 0;
                break;
            }
            case 2: {
                speedX = 0;
                speedY = alienSpeed;
                break;
            }
            case 3: {
                speedX = 0;
                speedY = -alienSpeed;
                break;
            }
            }
        }

        if (!isInNode())
            alreadyChanged = false;
        if ((posx + sprite.width) > aliensManager.rightBound) {
            posx = aliensManager.rightBound - sprite.width;
            speedX = -alienSpeed;
            speedY = 0;
            speedUpdate = true;
        }
        if ((posy + sprite.height) > aliensManager.bottomBound) {
            posy = aliensManager.bottomBound - sprite.height;
            speedY = -alienSpeed;
            speedX = 0;
            speedUpdate = true;
        }

        if (posx < aliensManager.leftBound) {
            posx = aliensManager.leftBound;
            speedX = alienSpeed;
            speedY = 0;
            speedUpdate = true;
        }
        if (posy < aliensManager.topBound) {
            posy = aliensManager.topBound;
            speedY = alienSpeed;
            speedX = 0;
            speedUpdate = true;
        }
    }

    function isInNode() {
        var tolerance = 10
        if (posx % Math.floor(grass.width / aliensManager.arrayCountX) < tolerance && (posy - grass.y) % Math.floor(grass.height / aliensManager.arrayCountY) < tolerance)
            return true;
        return false;
    }

    function checkDistanceFromCowScouts() {
        // skip test if I'm already shooting
        if (!move && victimCow != -1 && cowPositions.get(victimCow).active)
            return;

        var distanceToCowScout = aliensManager.thresholdDistance;
        var nearestCow = -1;
        for (var i = 0; i < cowPositions.count; ++i) {
            var cowPosition = cowPositions.get(i);
            if (cowPosition.active) {
                var distance = Math.pow(cowPosition.x - posx - width/2, 2) +
                        Math.pow(cowPosition.y - posy - height/2, 2);
                if (distance < distanceToCowScout) {
                    distanceToCowScout = distance
                    nearestCow = i;
                }
            }
        }
        if (nearestCow >= 0) {
            if (move) {
                targetSound.play();
            }
            move = false;
            victimCow = nearestCow;
        }
        else
            move = true;
    }

//    Connections {
//        target: aliensManager
//        onUpdateAlienPositions: updatePosition()
//    }
    Timer {
        id: synchronizer
        repeat: false
        running: true
        interval: alienIndex * heartBeat / alienCount
        onTriggered: heartTimer.start();
    }
    Timer {
        id: heartTimer
        interval: heartBeat
        running: false
        repeat: true
        onTriggered: updatePosition()
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
        source: ":/gfx/lasershot-3x1.png"
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
            emitter.x = posx + width/2;
            emitter.y = posy + height/2;
            emitter.rotation = getCowAngle(victimCow);
            emitter.burst(1);
            root.whichCow = victimCow
            root.cowIsShot();
            shootSound.play();
        }
    }

    function getCowAngle(cowIndex)
    {
        var cowX = cowPositions.get(cowIndex).x;
        var cowY = cowPositions.get(cowIndex).y;
        if (cowX != posx)
            return Math.atan2(cowY - posy - alien.height/2, cowX - posx - alien.width/2) * 180/ Math.PI;
        else
            return cowY < posy? 0 : 180;
    }
}
