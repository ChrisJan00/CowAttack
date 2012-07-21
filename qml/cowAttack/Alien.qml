// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: alien

    property int alienIndex;
    property int speedX: 0;
    property int speedY: 0;

    Image {
        id: sprite
        source: "../../gfx/alien-16x32-right.png"
        Component.onCompleted: rectifyPosition()
    }

    function updatePosition() {
        x += speedX;
        y += speedY;
        rectifyPosition();
    }

    function rectifyPosition() {
        if ((x + sprite.width) > aliensManager.rightBound) {
            x = aliensManager.rightBound - sprite.width;
            speedX = -speedX;
        }
        if ((y + sprite.height) > aliensManager.bottomBound) {
            y = aliensManager.bottomBound - sprite.height;
            speedY = -speedY;
        }

        if (x < aliensManager.leftBound) {
            x = aliensManager.leftBound;
            speedX = -speedX;
        }
        if (y < aliensManager.topBound) {
            y = aliensManager.topBound;
            speedY = -speedY;
        }
    }

    Connections {
        target: aliensManager
        onUpdateAlienPositions: updatePosition()
    }

    Component.onCompleted: {
        if (Math.random() > 0.5) {
            speedX = -speedX;
            speedY = -speedY;
        }
    }
}
