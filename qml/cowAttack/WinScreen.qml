// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import SDLMixerWrapper 1.0

Item {
    id: winScreen
    anchors.fill: parent
//    color: "gray"
//    opacity: 0

    SoundClip {
        id: winSound
        source: "sfx/gameover-win.ogg"
        volume: sfxVolume * 2
    }

    Image {
        id: curtain
        width: parent.width
        height: parent.height + 400
        source: "../../gfx/backgroundover-900x500-milk.png"
        y: -height
    }

    Image {
        id: winPic
        source: "../../gfx/cowfacehappy-340x420.png"
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
