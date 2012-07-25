/***************************************************************************/
/* This file is part of Attack of the Cows from outer Space.               */
/*                                                                         */
/*    Attack of the Cows from outer Space is free software: you can        */
/*    redistribute it and/or modify it under the terms of the GNU General  */
/*    Public License as published by the Free Software Foundation, either  */
/*    version 3 of the License, or (at your option) any later version.     */
/*                                                                         */
/*    Attack of the Cows from outer Space is distributed in the hope that  */
/*    it will be useful, but WITHOUT ANY WARRANTY; without even the        */
/*    implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      */
/*    PURPOSE.  See the GNU General Public License for more details.       */
/*                                                                         */
/*    You should have received a copy of the GNU General Public License    */
/*    along with Attack of the Cows from outer Space.  If not,             */
/*    see <http://www.gnu.org/licenses/>.                                  */
/***************************************************************************/

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
        source: ":/gfx/star-15x15.png"
        lifeSpan: 10000
        lifeSpanDeviation: 6000
        count: 50
        emissionRate: 15
        emissionVariance: 10
        fadeInDuration: 2000
        fadeOutDuration: 2000
    }

}
