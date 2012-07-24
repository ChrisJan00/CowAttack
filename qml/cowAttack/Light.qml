// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import Qt.labs.particles 1.0

Particles {
    id: light
    width: 1
    height: 1
    count: 1
    source: {
        switch (Math.floor(Math.random() * 4)) {
        case 0: return "../../gfx/lightred-15x15.png";
        case 1: return "../../gfx/lightcyan-15x15.png";
        case 2: return "../../gfx/lightyellow-15x15.png";
        case 3: return "../../gfx/lightpurple-15x15.png";
        }
    }

    lifeSpan: 4000
    lifeSpanDeviation: 4000
    fadeInDuration: 1000
    fadeOutDuration: 1000
    emissionRate: 1
}
