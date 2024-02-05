
/**
 * Copyright(c) Live2D Inc. All rights reserved.
 * Licensed under the MIT License. See LICENSE file in the project root for license information.
 */
import QtQuick
import QtQuick.Controls.Fusion

ListView {
    id: root

    signal addModelClicked(string modelPath)
    signal changeModelClicked(string modlePath)
    signal newWindowClicked(string modlePath)

    implicitHeight: 280
    implicitWidth: parent.width
    spacing: 8
    orientation: ListView.Horizontal
    clip: true
    delegate: Model {
        height: root.height
        source: IconPath ? "file:///" + IconPath : ""
        text: Name

        Column {
            anchors {
                margins: 8
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            spacing: 8
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Add Model"
                onClicked: root.addModelClicked(ModelPath)
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Change Model"
                onClicked: root.changeModelClicked(ModelPath)
            }
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "New Window"
                onClicked: root.newWindowClicked(ModelPath)
            }
        }
    }
}
