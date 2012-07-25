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

Particles {
    id: light
    width: 1
    height: 1
    count: 1
    source: {
        switch (Math.floor(Math.random() * 4)) {
        case 0: return ":/gfx/lightred-15x15.png";
        case 1: return ":/gfx/lightcyan-15x15.png";
        case 2: return ":/gfx/lightyellow-15x15.png";
        case 3: return ":/gfx/lightpurple-15x15.png";
        }
    }

    lifeSpan: 4000
    lifeSpanDeviation: 4000
    fadeInDuration: 1000
    fadeOutDuration: 1000
    emissionRate: 1
}
