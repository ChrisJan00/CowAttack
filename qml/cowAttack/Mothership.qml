// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import SDLMixerWrapper 1.0

Item {
    id: mothership
    x: parent.width / 2 - width/2
    width: motherPic.width

    property int milk: 0
    property int milkMax: 7000

    onMilkChanged: if (milk > milkMax) {
                       milk = milkMax;
                       leave();
                   }

    SoundClip {
        id: mooLament
        source: "sfx/moo-notification.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: zapSound
        source: "sfx/gun-zap.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: leavingSound
        source: "sfx/beam-wowowfast.ogg"
        volume: sfxVolume
    }

    Image {
        id: motherPic
        y: incy
        property int incy

        source: "../../gfx/cowmothership3-256x138.png"
        function update() {
        }

        SequentialAnimation {
            id: floatAnimation
            loops: Animation.Infinite
            running: true
            property int dur: 400
            PropertyAnimation {
                property: "incy"
                target: motherPic
                from: -4
                to: 4
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
            PropertyAnimation {
                property: "incy"
                target: motherPic
                from: 4
                to: -4
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: spaceshipManager.recallShip()
        }
    }

    Rectangle {
        id: milkDisplay
        border.width: 0
        border.color: "black"
        color: "purple"
        visible: milk > 0
        width: milk / milkMax * mothership.width
        height: 8
        y : -8
        x : motherPic.x
        Rectangle {
            border.width: 1
            border.color: "black"
            color: "transparent"
            width: mothership.width
            height: parent.height
        }
    }

    function fall() {
        fallAnimation.start();
    }

    SequentialAnimation {
        id: fallAnimation
        ScriptAction {
            script: zapSound.play();
        }
        SequentialAnimation {
            loops: 10
            PropertyAnimation {
                target: motherPic
                property: "y"
                from: 0
                to: -5
                duration: 50
                easing.type: Easing.InOutSine
            }
            PropertyAnimation {
                target: motherPic
                property: "y"
                from: -5
                to: 0
                duration: 50
                easing.type: Easing.InOutSine
            }
        }
        ParallelAnimation {
            RotationAnimation {
                target: motherPic
                property: "rotation"
                from: 0
                to: -90
                direction: RotationAnimation.Counterclockwise
                duration: 2000
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: motherPic
                property: "y"
                to: mothership.y + 200
                easing.type: Easing.InQuart
                duration: 2000
            }
            PropertyAnimation {
                target: motherPic
                property: "opacity"
                to: 0
                duration: 2000
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: motherShadow
                property: "opacity"
                to: 0
                duration: 2000
                easing.type: Easing.InQuart
            }
        }
        ScriptAction {
            script: {
                mothership.visible = false;
                mooLament.play();
                loseScreen.show();
            }
        }
    }

    function leave()
    {
        spaceshipManager.recallAllShips();
//        leaveAnimation.start();
    }

    Connections {
        target: spaceshipManager
        onShipOnPlace: {
            var i, dockedCount = 0;
            for (i=0; i < cowPositions.count; i++) {
                if ((!cowPositions.get(i).scoutAlive) ||
                     (cowPositions.get(i).x - 24 == spaceshipManager.mothershipX &&
                        cowPositions.get(i).y - 16 == spaceshipManager.mothershipY))
                    dockedCount++;
            }

            if (dockedCount == 3)
                leaveAnimation.start();
        }
    }

    SequentialAnimation {
        id: leaveAnimation
        property int dur : 10000
        ScriptAction{
            script: leavingAlready = true;
        }
        PropertyAnimation {
            target: milkDisplay
            property: "opacity"
            to: 0
            duration: 1000
        }
        ParallelAnimation {
            PropertyAnimation {
                target: motherPic
                property: "x"
                from: 0
                to: root.width
                duration: leaveAnimation.dur
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: motherPic
                property: "y"
                to: -motherPic.height
                duration: leaveAnimation.dur
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: motherShadow
                property: "x"
                from: mothership.x
                to: root.width + mothership.x
                duration: leaveAnimation.dur
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: motherShadow
                property: "opacity"
                to: 0
                duration: leaveAnimation.dur
                easing.type: Easing.InQuart
            }
        }
        ScriptAction {
            script: {
                leavingAlready = false;
                winScreen.show();
            }
        }
    }

    property bool leavingAlready: false
    property int movingTime: 4119
    Timer {
        interval: heartBeat
        running: true
        repeat: true
        onTriggered: {
            if (leavingAlready) {
                movingTime -= interval;
                if (movingTime <= 0) {
                    leavingSound.play();
                    movingTime = 4119;
                }
            } else {
                movingTime = 0;
                leavingSound.stop();
            }
        }
    }
}
