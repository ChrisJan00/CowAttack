// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: scout
    width: shipPic.width
    height: shipPic.height

    property int scoutIndex: 0
    property bool selected: spaceshipManager.selectedScoutIndex == scoutIndex
    property int destX
    property int destY
    property int floatHeight: 150
    property bool cowSpawned: false

    Connections {
        target: spaceshipManager
        onMoveScout: {
            if (selected && !cowSpawned) {
                destX = spaceshipManager.destX;
                destY = spaceshipManager.destY;
            }
        }

        onUpdateSpaceships: {
            var stepSize = 10
            var incx = Math.min(stepSize, Math.max(-stepSize, destX - x) );
            var incy = Math.min(stepSize, Math.max(-stepSize, destY - y) );
            x += incx;
            y += incy;
        }

        onRecallShip: {
            if (selected && !cowSpawned) {
                destX = mothershipX
                destY = mothershipY + floatHeight
            }
        }

    }

    Behavior on x { NumberAnimation { duration: heartBeat } }
    Behavior on y { NumberAnimation { duration: heartBeat } }

    Image {
        id: shadow
        source: "../../gfx/cowscoutshadow-38x24-left.png"
        width: parent.width
        height: parent.height
        opacity: Math.max(0, Math.min(1, (scout.y - grass.y)/50));
    }

    Image {
        id: beam
        source: "../../gfx/beamsimple-48x200.png"
        opacity: 0
        Behavior on opacity { NumberAnimation { duration: 250 } }
        y: -floatHeight + shipPic.height * 3 / 4
        x: shipPic.width / 2 - width/2
        height: floatHeight
    }

    Image {
        id: shipPic
        source: "../../gfx/cowmothership2-58x52.png"
//        width: parent.width
//        height: parent.height
        y: -floatHeight + incy
        property int incy: 0

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "yellow"
            visible: scout.selected
        }


        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (!selected) {
                    spaceshipManager.selectedScoutIndex = scoutIndex
                } else if (!cowSpawned) {
                        deployCow();
                } else {
                        retrieveCow();
                }
            }
        }

        SequentialAnimation {
            id: floatAnimation
            loops: Animation.Infinite
            running: true
            property int dur: 200 + Math.random() * 20
            PropertyAnimation {
                property: "incy"
                target: shipPic
                from: -2
                to: 2
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
            PropertyAnimation {
                property: "incy"
                target: shipPic
                from: 2
                to: -2
                easing.type: Easing.InOutSine
                duration: floatAnimation.dur
            }
            PauseAnimation { duration: floatAnimation.dur }
        }
    }

    function update() {
    }

    Cow {
        id: cow
        x: 0
        y: 0
        visible: false
    }

    SequentialAnimation {
        id: deployAnimation
        ScriptAction {
            script: {
                cow.opacity = 0;
                cow.visible = true;
                cow.x = shipPic.width / 2 - cow.width / 2
                cow.y = shipPic.height - floatHeight
                beam.opacity = 1;
            }
        }
        ParallelAnimation {

            PropertyAnimation {
                target: cow
                property: "y"
                from: shipPic.height - floatHeight
                to: 0
                easing.type: Easing.InCubic
                duration: 1500
            }
            PropertyAnimation {
                target: cow
                property: "opacity"
                from: 0
                to: 1
                duration: 500
            }
        }
        ScriptAction {
            script: {
                beam.opacity = 0;
            }
        }
    }

    SequentialAnimation {
        id: retrieveAnimation
        ScriptAction {
            script: {
                beam.opacity = 1;
            }
        }
        ParallelAnimation {
            SequentialAnimation {
                PauseAnimation { duration: 1000 }
            PropertyAnimation {
                target: cow
                property: "opacity"
                from: 1
                to: 0
                duration: 500
            }
            }
            PropertyAnimation {
                target: cow
                property: "y"
                from: 0
                to: shipPic.height - floatHeight
                easing.type: Easing.InCubic
                duration: 1500
            }
        }

        ScriptAction {
            script: {
                cow.opacity = 0;
                cow.visible = true;
                cow.x = shipPic.width / 2 - cow.width / 2
                cow.y = shipPic.height
                beam.opacity = 0;
            }
        }
    }

    function deployCow() {
        if (scout.y < grass.y)
            return;
        if (destX != x || destY != y)
            return;
        if (retrieveAnimation.running)
            return;
        cowSpawned = true;
        deployAnimation.start();
    }

    function retrieveCow() {
        if (deployAnimation.running)
            return;
        cowSpawned = false;
        retrieveAnimation.start();
    }
}
