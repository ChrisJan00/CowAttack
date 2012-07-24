// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import SDLMixerWrapper 1.0

Item {
    id: scout
    width: shipPic.width
    height: shipPic.height

    property int scoutIndex: 0
    property bool selected: spaceshipManager.selectedScoutIndex == scoutIndex
    property int destX: x
    property int destY: y
    property int floatHeight: 100
    property bool cowSpawned: false

    property int energy: 0
    property int energyMax: 1000

    property bool docked: x == mothershipX && y == (mothershipY + floatHeight)
    property bool moving: x != destX || y != destY

    property int lives: 5
    property bool finishing: false

    property bool ready: false
    onXChanged: if (ready) cowPositions.get(scoutIndex).x = x + cow.width/2;
    onYChanged: if (ready) cowPositions.get(scoutIndex).y = y + cow.height/2;

    onDockedChanged: checkFinish();
    onFinishingChanged: checkFinish();

    Component.onCompleted: {
        cowPositions.get(scoutIndex).x = x + 24;
        cowPositions.get(scoutIndex).y = y + 16;
        ready = true;
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
        id: deploySound
        source: "sfx/beam-down.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: retrieveSound
        source: "sfx/beam-up.ogg"
        volume: sfxVolume
    }

    SoundClip {
        id: moveSound
        source: "sfx/beam-wowow.ogg"
        volume: sfxVolume
    }

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
        onRecallAllShips: {
            if (!visible) {
                spaceshipManager.shipOnPlace();
                return;
            }
            finishing = true;
            if (cowSpawned) {
                retrieveCow();
            }
            destX = mothershipX
            destY = mothershipY + floatHeight
        }

    }

    Behavior on x { NumberAnimation { duration: heartBeat } }
    Behavior on y { NumberAnimation { duration: heartBeat } }

    Item {
        id: shadowPlaceholder
        y: height/2
        width: 38
        height: 24
        MouseArea {
            anchors.fill: parent
            enabled: !finishing
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
        y: -floatHeight + incy
        property int incy: 0
        z: 2

        Light { x: 0; y: 18 }
        Light { x: 29; y: 32 }
        Light { x: 57; y: 18 }

        Rectangle {
            anchors.fill: parent
            color: "transparent"
            border.width: 1
            border.color: "yellow"
            visible: scout.selected
        }


        MouseArea {
            anchors.fill: parent
            enabled: !finishing
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
                deploySound.play();
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
                retrieveSound.play();
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

    property int movingTime: 3587
    Timer {
        interval: heartBeat
        running: true
        repeat: true
        onTriggered: {
            if (docked && energy > 0) {
                var inc = Math.min(5, energy);
                motherMilk += inc;
                energy -= inc;
            }
            if (moving) {
                movingTime -= interval;
                if (movingTime <= 0) {
                    moveSound.play();
                    movingTime = 3587;
                }
            } else {
                movingTime = 0;
                moveSound.stop();
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
        ScriptAction {
            script: zapSound.play();
        }
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
        ScriptAction {
            script: mooLament.play();
        }
        PauseAnimation { duration: 500 }
        ScriptAction {
            script: {
                scout.visible = false;
                spaceshipManager.liveScoutCount--;
                cowPositions.get(scoutIndex).scoutAlive = false;
            }
        }
    }

    Image {
        id: headBeam
        opacity: (docked && energy > 0) ? 1 : 0
        onOpacityChanged: if (opacity == 1)
                              retrieveSound.play();
        Behavior on opacity { NumberAnimation { duration: 500 } }
        source: "../../gfx/beamsimple-48x200.png"
        x: scout.width/2 - width/2
        y: -height - floatHeight + 38
        height: 100
    }

    function checkFinish()
    {
        if (finishing && docked && !leaveAnimation.running)
            leaveAnimation.start();
    }

    SequentialAnimation {
        id: leaveAnimation
        ScriptAction {
            script: headBeam.opacity = 1;
        }
        PauseAnimation { duration: 500 }
        PropertyAnimation {
            target: scout
            property: "opacity"
            to: 0
            duration: 2000
        }
        ScriptAction {
            script: {
                // hack for hiding shadow
                cowPositions.get(scoutIndex).scoutAlive = false;
                headBeam.opacity = 0;
            }
        }
        PauseAnimation { duration: 500 }
        ScriptAction {
            script: spaceshipManager.shipOnPlace();
        }
    }
}
