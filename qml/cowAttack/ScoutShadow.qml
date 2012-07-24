// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Image {
    id: shadow
    source: "../../gfx/cowscoutshadow-38x24-left.png"
    opacity: Math.max(0, Math.min(1, (y - grass.y)/50));
}
