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

// Container for aliens
Item {
    id: aliensManager

    signal updateAlienPositions

    property int alienCount: 25
    property int arrayCountX: 10
    property int arrayCountY: 5
    property double alienSpeed: 2.5
    property int leftBound: 0
    property int rightBound: root.width
    property int topBound: grass.y
    property int bottomBound: root.height

    property double thresholdDistance : 5000
    Timer {
        id: updateTimer
        interval: heartBeat; running: true; repeat: true
        onTriggered: updateAlienPositions()
    }

    Repeater {
        model: alienCount
        delegate: Alien {
            alienIndex: index
            x: Math.floor((index%(arrayCountX+1))/arrayCountX*grass.width)
            y: Math.floor((Math.floor(index/arrayCountX))/arrayCountY*grass.height + grass.y)
            speedX: (index%2) * alienSpeed; speedY: ((index+1)%2) * alienSpeed
        }
    }
}
