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

    property int energy: 0
    property int energyMax: 1000

    property bool docked: x == mothershipX && y == (mothershipY + floatHeight)

    property int lives: 5

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
            //if (selected && !cowSpawned && energy == energyMax) {
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
//        width: parent.width
//        height: parent.height
        y: height/2
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
        z: 2

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
                cow.pastureAcc = 0;
                cow.pasturing = true;
                cowPositions.get(scoutIndex).active = true;
                cowPositions.get(scoutIndex).x = scout.x + cow.width/2;
                cowPositions.get(scoutIndex).y = scout.y + cow.height / 2;
            }
        }
    }

    SequentialAnimation {
        id: retrieveAnimation
        ScriptAction {
            script: {
                beam.opacity = 1;
                cow.pasturing = false;
                cowPositions.get(scoutIndex).active = false;
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
                energy += cow.pastureAmount
                if (energy > energyMax)
                    energy = energyMax
                cow.pastureAmount = 0;
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

    Rectangle {
        border.width: 0
        border.color: "black"
        color: "purple"
        visible: energy > 0
        width: energy / energyMax * scout.width
        height: 6
        y : -8 - floatHeight
        Rectangle {
            border.width: 1
            border.color: "black"
            color: "transparent"
            width: scout.width
            height: parent.height
        }
    }

    Timer {
        interval: heartBeat
        running: true
        repeat: true
        onTriggered: {
            if (docked && energy > 0) {
                var inc = Math.min(10, energy);
                motherMilk += inc;
                energy -= inc;
            }
        }
    }

    Row {
        spacing: 2
        y: -20 - floatHeight
        Repeater {
            model: lives
            delegate: Image {
                width: 10
                height: 13
                source: "../../gfx/cowhead-10x13.png"
            }
        }
    }

    function die() {
        if (selected)
            spaceshipManager.selectedScoutIndex = -1;
        crashAnimation.start();
    }

    SequentialAnimation {
        id: crashAnimation
        PauseAnimation { duration: 500 }
        ParallelAnimation {
            RotationAnimation {
                target: shipPic
                property: "rotation"
                from: 0
                to: -90
                direction: RotationAnimation.Counterclockwise
                duration: 2000
                easing.type: Easing.InQuart
            }
            PropertyAnimation {
                target: scout
                property: "floatHeight"
                to: 0
                easing.type: Easing.InQuart
                duration: 2000
            }
        }
        PauseAnimation { duration: 500 }
        ScriptAction {
            script: {
                scout.visible = false;
                spaceshipManager.liveScoutCount--;
            }
        }
    }
}
