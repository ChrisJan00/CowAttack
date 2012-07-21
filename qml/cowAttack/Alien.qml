// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: alien

    property int alienIndex;
    property int speedX: 0;
    property int speedY: 0;
    property int distanceToRallyX: 0;
    property int distanceToRallyY: 0;

    Image {
        source: "../../gfx/alien-16x32-right.png"
    }

    function updatePosition() {
        x += speedX;
        y += speedY;

        distanceToRallyX -= speedX;
        distanceToRallyY -= speedY;
    }

    function hasReachedRallyPoint() {
        return (distanceToRallyX <= 0 && distanceToRallyY <= 0);
    }

    Connections {
        target: aliensManager
        onUpdateAlienPositions: updatePosition()
    }
}
