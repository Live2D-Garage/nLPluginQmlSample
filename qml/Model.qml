
/**
 * Copyright(c) Live2D Inc. All rights reserved.
 * Licensed under the MIT License. See LICENSE file in the project root for license information.
 */
import QtQuick

MouseArea {
    id: root

    property bool highlighted: false
    property alias source: image.source
    property alias text: label.text

    implicitHeight: 180
    implicitWidth: 120

    Rectangle {
        anchors.fill: parent
        radius: 8
        color: palette.base
        border.color: "#915EFF"
        border.width: root.highlighted ? 2 : 0
    }

    Column {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 8

        Image {
            id: image
            width: parent.width
            height: width * 240 / 184
        }

        Text {
            id: label
            width: parent.width
            horizontalAlignment: Text.AlignHCenter
            elide: Text.ElideRight
            color: palette.text
        }
    }
}
