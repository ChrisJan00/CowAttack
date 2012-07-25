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

Item {
    id: winScreen
    anchors.fill: parent

    SoundClip {
        id: winSound
        source: "sfx/gameover-win.ogg"
        volume: sfxVolume * 2
    }

    Image {
        id: curtain
        width: parent.width
        height: parent.height + 400
        source: ":/gfx/backgroundover-900x500-milk.png"
        y: -height
    }

    Image {
        id: winPic
        source: ":/gfx/cowfacehappy-340x420.png"
        anchors.centerIn: parent
        opacity: 0
    }

    MouseArea {
        id: mouseEater
        anchors.fill: parent
        enabled: false
    }

    function show() {
        mouseEater.enabled = true;
        endAnimation.start();
        if (introMusic.playing) {
            introMusic.repeating = false;
            introMusic.fadeOut(4000);
            ingameMusic.unqueue();
        } else {
            ingameMusic.fadeOut(4000);
        }
    }

    SequentialAnimation {
        id: endAnimation
        PropertyAnimation {
            target: curtain
            property: "y"
            from: -curtain.height
            to: 0
            duration: 4000
        }
        ScriptAction {
            script: winSound.play();
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            target: winPic
            property: "opacity"
            to: 1
            duration: 1000
        }
    }

}
