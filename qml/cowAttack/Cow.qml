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

    Rectangle {
        border.width: 1
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
                pastureAcc += 0.1;
                if (pastureAmount < pastureMax)
                    pastureAmount += Math.min(pastureInc, pastureMax-pastureAmount);
                if (pastureAmount >= pastureMax)
                    pasturing = false;
            }
    }
}
