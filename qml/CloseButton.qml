
/**
 * Copyright(c) Live2D Inc. All rights reserved.
 * Licensed under the MIT License. See LICENSE file in the project root for license information.
 */
import QtQuick

MouseArea {
    id: root

    property color color: "red"

    implicitHeight: 15
    implicitWidth: 15

    Rectangle {
        y: -2
        height: 4
        width: 21
        radius: 2
        transform: Rotation {
            angle: 45
            origin.y: 2
        }
        color: root.color
    }

    Rectangle {
        y: 13
        height: 4
        width: 21
        radius: 2
        transform: Rotation {
            angle: -45
            origin.y: 2
        }
        color: root.color
    }
}
