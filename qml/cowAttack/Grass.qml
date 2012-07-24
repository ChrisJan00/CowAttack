// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.particles 1.0

Rectangle {
    id: grass
    color: "green"
    gradient: Gradient {
        GradientStop { position: 0.0; color:"green"}
        GradientStop { position: 1.0; color:Qt.darker("green")}
    }

    Particles {
        id: emitter
        width: parent.width
        height: parent.height
        source: "../../gfx/leaf-8x15.png"
        lifeSpan: 20000
        lifeSpanDeviation: 10000
        count: 2000
        fadeInDuration: 3000
        fadeOutDuration: 3000

        // angledeviation is ignored? seems to apply only with movement
        angleDeviation: 45
    }
}
