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
import SDLMixerWrapper 1.0

Image {
    id: cow
    source: ":/gfx/cow-48x32-left.png"

    property bool pasturing: false
    property int pastureAmount: 0
    property int pastureMax: 250
    property int pastureInc: 1
    property int pastureAcc: 1
    property bool dying: false

    state: "normal"

    SoundClip {
        id: mooSound
        source: "sfx/moo-death.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: chewingSound
        source: "sfx/chewing.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: satiatedSound
        source: "sfx/moo-notification.ogg"
        volume: sfxVolume
    }

    Connections {
        target: root
        onCowIsShot: {
            if (root.whichCow == scoutIndex) {
                pastureAmount -= 10;
                pastureAcc = 0;
                if (pastureAmount <= 0) {
                    die();
                }
            }
        }
    }

    Rectangle {
        border.width: 0
        border.color: "black"
        color: "purple"
        visible: pastureAmount > 0
        width: pastureAmount / pastureMax * cow.width
        height: 4
        y : -8
        Rectangle {
            border.width: 1
            border.color: "black"
            color: "transparent"
            width: cow.width
            height: parent.height
        }
    }

    Timer {
        interval: heartBeat
        running: true
        repeat: true
        onTriggered: if (pasturing) {
                pastureInc += pastureAcc;
                pastureAcc += 0.3;
                if (pastureAmount < pastureMax)
                    pastureAmount += Math.min(pastureInc, pastureMax-pastureAmount);
                if (pastureAmount >= pastureMax) {
                    satiatedSound.play();
                    pasturing = false;
                }
            }
    }

    SequentialAnimation {
        id: deathAnimation
        ParallelAnimation {
            RotationAnimation {
                target: cow
                property: "rotation"
                from: 0
                to: 180
                duration: 500
            }
            SequentialAnimation {
                PropertyAnimation {
                    target: cow
                    property: "y"
                    from: y
                    to: y - 40
                    easing.type: Easing.OutQuad
                    duration: 250
                }
                PropertyAnimation {
                    target: cow
                    property: "y"
                    from: y - 40
                    to: y
                    easing.type: Easing.InQuad
                    duration: 250
                }
            }
        }
        ScriptAction {
            script: {
                cowPositions.get(scoutIndex).active = false;
                cow.opacity = 0;
                scout.cowSpawned = false;
                cow.pastureAmount = 0;
                cow.pasturing = false;
                cow.rotation = 0;
                cow.dying = false;
            }
        }

    }

    function die()
    {
        if (dying)
           return;
        dying = true;
        scout.lives--;
        deathAnimation.start();
        mooSound.play();
        if (scout.lives == 0)
            scout.die();
    }

    states: [
        State {
            name: "normal"
            PropertyChanges {
                target: cow
                source: ":/gfx/cow-48x32-left.png"
            }
        },
        State {
            name: "chew1"
            PropertyChanges {
                target: cow
                source: ":/gfx/cow-48x32-left-eat1.png"
            }
        },
        State {
            name: "chew2"
            PropertyChanges {
                target: cow
                source: ":/gfx/cow-48x32-left-eat2.png"
            }
        }
    ]

    property int pasturingTime: 0

    Timer {
        running: true
        repeat: true
        interval: 350
        onTriggered: if (pasturing) {
                         if (cow.state == "chew1")
                             cow.state = "chew2";
                         else
                             cow.state = "chew1";
                         pasturingTime -= interval;
                         if (pasturingTime <= 0) {
                             pasturingTime = 3500;
                             chewingSound.play();
                         }
                     } else {
                         pasturingTime = 0;
                         chewingSound.stop();
                         cow.state = "normal";
                     }
    }
}
