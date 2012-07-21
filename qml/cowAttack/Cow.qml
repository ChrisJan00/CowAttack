// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    id: cow
    source: "../../gfx/cow-48x32-left.png"

    property bool pasturing: false
    property int pastureAmount: 0
    property int pastureMax: 300
    property int pastureInc: 1
    property int pastureAcc: 1

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
                pastureAcc += 0.4;
                if (pastureAmount < pastureMax)
                    pastureAmount += Math.min(pastureInc, pastureMax-pastureAmount);
                if (pastureAmount >= pastureMax)
                    pasturing = false;
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
            }
        }

    }

    function die()
    {
        deathAnimation.start();
    }
}
