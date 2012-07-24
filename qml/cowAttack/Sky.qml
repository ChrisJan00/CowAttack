// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.particles 1.0

Rectangle {
    id: sky
    color: "blue"
    width: parent.width
    height: 200
    gradient: Gradient {
        GradientStop { position: 0.0; color:"darkBlue"}
        GradientStop { position: 1.0; color:"blue"}
    }

    Particles {
        id: emitter
        width: parent.width
        height: parent.height - 10
        source: "../../gfx/star-15x15.png"
        lifeSpan: 10000
        lifeSpanDeviation: 3000
        count: 50
        emissionRate: 15
        emissionVariance: 10
        fadeInDuration: 2000
        fadeOutDuration: 2000
    }

}
