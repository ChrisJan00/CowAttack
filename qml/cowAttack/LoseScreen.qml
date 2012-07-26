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
    id: loseScreen
    anchors.fill: parent
//    color: "gray"
//    opacity: 0

    SoundClip {
        id: loseSound
        source: "sfx/gameover-lose.ogg"
        volume: sfxVolume * 2
    }

    Image {
        id: curtain
        width: parent.width
        height: parent.height + 400
        source: ":/gfx/backgroundover-900x500-darkness.png"
        y: -height
    }

    Image {
        id: losePic
        source: ":/gfx/cowfaceohno-400x580.png"
        anchors.centerIn: parent
        opacity: 0
        scale: 0.7
    }

    Text {
        id: timeText
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: losePic.bottom
        anchors.topMargin: -64
        opacity: losePic.opacity
        font.family: customFont.name
        font.pixelSize: 32
        color: "white"
        text: {
            var hours = Math.floor(root.elapsedTime / 60000 / 60);
            var mins = Math.floor(root.elapsedTime / 60000 - hours * 60);
            var secs = Math.floor(root.elapsedTime  / 1000 - mins * 60);
            return "Total time  " +
                    (hours > 0? hours + ":" : "") +
                    (mins < 10 ? "0" : "") + mins + ":" +
                    (secs < 10 ? "0" : "") + secs;
        }
    }

    MouseArea {
        id: mouseEater
        anchors.fill: parent
        enabled: false
    }

    function show() {
        root.elapsedTime = new Date().getTime() - root.startTime;
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
            script: loseSound.play();
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            target: losePic
            property: "opacity"
            to: 1
            duration: 1000
        }
    }

}
