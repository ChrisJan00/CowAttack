// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import SDLMixerWrapper 1.0

Rectangle {
    id: root
    width: 800
    height: 600

    property int heartBeat: 100
    property int sfxVolume: 32


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


    property int whichCow: -1
    signal cowIsShot
    ListModel {
        id: cowPositions
        ListElement {
            active: false
            x: 0
            y: 0
        }
        ListElement {
            active: false
            x: 0
            y: 0
        }
        ListElement {
            active: false
            x: 0
            y: 0
        }
    }

    Sky {
        id: sky
    }

    Rectangle {
        id: grass
        color: "green"
        width: parent.width
        height: parent.height
        y: sky.height
        gradient: Gradient {
            GradientStop { position: 0.0; color:"green"}
            GradientStop { position: 1.0; color:Qt.darker("green")}
        }
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
        source: "../../gfx/titlescreen.png"
        anchors.fill: parent
        Behavior on opacity { NumberAnimation { duration: 1000 } }
        MouseArea {
            anchors.fill: parent
            onClicked: {
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
