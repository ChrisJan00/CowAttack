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
    property int speedX: 0;
    property int speedY: 0;
    property bool move: true;
    property int victimCow: -1
    property bool wasLookingLeft: false

    width: sprite.width
    height: sprite.height

    Image {
        id: sprite
        source: ":/gfx/alien-16x32-right.png"
        Component.onCompleted: rectifyPosition()
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

    function updateSprite() {
        if (move) {
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

            if (cowAngle <= -45 && cowAngle >= -135) {
                state = "shootup";
                return;
            }
            if (cowPositions.get(victimCow).x < alien.x) {
                state = "shootleft";
                return;
            }
            if (cowPositions.get(victimCow).x > alien.x) {
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
        x += speedX;
        y += speedY;
        rectifyPosition();
        updateSprite();
    }

    property bool alreadyChanged: false
    function rectifyPosition() {
        if (!alreadyChanged && isInNode()) {
            alreadyChanged = true;
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
        if ((x + sprite.width) > aliensManager.rightBound) {
            x = aliensManager.rightBound - sprite.width;
            speedX = -alienSpeed;
            speedY = 0;
        }
        if ((y + sprite.height) > aliensManager.bottomBound) {
            y = aliensManager.bottomBound - sprite.height;
            speedY = -alienSpeed;
            speedX = 0;
        }

        if (x < aliensManager.leftBound) {
            x = aliensManager.leftBound;
            speedX = alienSpeed;
            speedY = 0;
        }
        if (y < aliensManager.topBound) {
            y = aliensManager.topBound;
            speedY = alienSpeed;
            speedX = 0;
        }
    }

    function isInNode() {
        var tolerance = 10
        if (x % Math.floor(grass.width / aliensManager.arrayCountX) < tolerance && (y - grass.y) % Math.floor(grass.height / aliensManager.arrayCountY) < tolerance)
            return true;
        return false;
    }

    function checkDistanceFromCowScouts() {
        var distanceToCowScout = aliensManager.thresholdDistance;
        var nearestCow = -1;
        for (var i = 0; i < cowPositions.count; ++i) {
            var cowPosition = cowPositions.get(i);
            if (cowPosition.active) {
                var distance = Math.pow(cowPosition.x - x - width/2, 2) +
                        Math.pow(cowPosition.y - y - height/2, 2);
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
            emitter.x = x + width/2;
            emitter.y = y + height/2;
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
        if (cowX != x)
            return Math.atan2(cowY - y - alien.height/2, cowX - x - alien.width/2) * 180/ Math.PI;
        else
            return cowY < y? 0 : 180;
    }
}
