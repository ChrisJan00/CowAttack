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

Item {
    id: spaceshipManager

    property int selectedScoutIndex: 0

    property int mothershipX: motherShadow.x + motherShadow.width / 2 - 28
    property int mothershipY: motherShadow.y + motherShadow.height / 2 - 90
    property alias motherMilk: motherShip.milk

    signal moveScout
    signal updateSpaceships
    signal recallShip
    signal recallAllShips
    signal shipOnPlace
    property int destX
    property int destY

    Image {
        id: motherShadow
        source: ":/gfx/mothershadow.png"
        y: motherShip.y + 200
        x: motherShip.x
    }

    MouseArea {
        id: scoutControl
        x: 0
        y: grass.y
        width: grass.width
        height: grass.height
        property int ylimit : grass.y - 16
        onClicked: {
            destX = mouseX - 29;
            destY = mouseY + y - 32;

            if (destY < ylimit)
                destY = ylimit;
            if (destY > root.height - 48)
                destY = root.height - 48;
            if (destX > grass.width - 58)
                destX = grass.width - 58;
            if (destX < 0)
                destX = 0;

            // avoid going behind the mothership
            if (destX >= motherShadow.x - 38 && destX <= motherShadow.x+motherShadow.width && destY < motherShadow.y + motherShadow.height/2)
                destY = motherShadow.y + motherShadow.height/2;

            moveScout();
        }
    }

    property int scoutCount: 3
    property int liveScoutCount: scoutCount
    onLiveScoutCountChanged: {
        if (liveScoutCount == 0)
            motherShip.fall();
    }

    // shadows
    Repeater {
        model: scoutCount
        delegate: ScoutShadow {
            x: cowPositions.get(index).x - 24
            y: cowPositions.get(index).y
            visible: cowPositions.get(index).scoutAlive
        }
    }

    // scouts
    Repeater {
        model: scoutCount
        delegate: Scout {
            scoutIndex: index
            x: Math.floor(40 + index * root.width*0.4)
            y: 250 + Math.random() * 200
            destX: x
            destY: y
        }
    }

    // mothership
    Mothership {
        id: motherShip
        y: 20
    }

    Timer {
        running: true
        repeat: true
        onTriggered: updateSpaceships();
        interval: heartBeat
    }
}
