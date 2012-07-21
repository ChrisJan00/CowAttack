// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    id: cow
    source: "../../gfx/cow-48x32-left.png"

    property bool pasturing: false
    property int pastureAmount: 0
    property int pastureMax: 100
    property int pastureInc: 1

    Rectangle {
        border.width: 1
        border.color: "black"
        color: "purple"
        visible: pastureAmount > 0
        width: pastureAmount / pastureMax * cow.width
        height: 3
        y : -4
        Rectangle {
            border.width: 1
            border.color: "black"
            color: "transparent"
            width: cow.width
            height: 3
        }
    }

    Timer {
        interval: heartBeat
        running: true
        repeat: true
        onTriggered: if (pasturing) {
                if (pastureAmount < pastureMax)
                    pastureAmount += Math.min(pastureInc, pastureMax-pastureAmount);
                if (pastureAmount >= pastureMax)
                    pasturing = false;
            }
    }
}
