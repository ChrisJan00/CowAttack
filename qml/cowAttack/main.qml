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

Rectangle {
    id: root
    width: 800
    height: 600

    property int heartBeat: 100
    property int sfxVolume: 32

    property variant startTime;
    property variant elapsedTime;


    MusicClip {
        id: introMusic
        source: "sfx/intromusic.ogg"
        repeating: true
    }

    MusicClip {
        id: ingameMusic
        source: "sfx/ingamemusic.ogg"
        loops: -1
    }

    FontLoader {
        id: customFont
        source: ":/Adventure.ttf"
    }


    property int whichCow: -1
    signal cowIsShot
    ListModel {
        id: cowPositions
        ListElement {
            active: false
            x: 0
            y: 0
            scoutAlive: true
        }
        ListElement {
            active: false
            x: 0
            y: 0
            scoutAlive: true
        }
        ListElement {
            active: false
            x: 0
            y: 0
            scoutAlive: true
        }
    }

    Sky {
        id: sky
    }

    Grass {
        id: grass
        width: parent.width
        height: parent.height - sky.height
        y: sky.height
    }


    AliensManager {
        anchors.fill: parent
    }

    SpaceshipManager {
        anchors.fill: parent
    }

    LoseScreen {
        id: loseScreen
    }

    WinScreen {
        id: winScreen
    }

    Image {
        id: titleScreen
        source: ":/gfx/titlescreen.png"
        anchors.fill: parent
        Behavior on opacity { NumberAnimation { duration: 1000 } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
                root.startTime = new Date().getTime();
                titleScreen.opacity = 0;
                introMusic.repeating = false;
            }
        }
    }

    Component.onCompleted: {
        introMusic.play();
        ingameMusic.enqueue();
    }

}
