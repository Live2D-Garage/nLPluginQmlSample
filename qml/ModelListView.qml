
/**
 * Copyright(c) Live2D Inc. All rights reserved.
 * Licensed under the MIT License. See LICENSE file in the project root for license information.
 */
import QtQuick

ListView {
    id: root

    property bool removable: false
    property string selectedModelId: internal.selectedModelId
    property string selectedSceneId: internal.selectedSceneId

    signal selected(string modelId, string sceneId)
    signal removeButtonClicked(string modelId)

    QtObject {
        id: internal
        property string selectedModelId
        property string selectedSceneId
        function select(modelId, sceneId) {
            selectedModelId = modelId
            selectedSceneId = sceneId
            root.selected(modelId, sceneId)
        }
    }

    implicitHeight: 180
    implicitWidth: parent.width
    spacing: 8
    orientation: ListView.Horizontal
    clip: true
    delegate: Model {
        highlighted: root.selectedModelId === ModelId
        source: IconPath ? "file:///" + IconPath : ""
        text: Name
        onClicked: internal.select(ModelId, SceneId)

        CloseButton {
            visible: root.removable
            anchors {
                margins: 12
                top: parent.top
                right: parent.right
            }
            onClicked: root.removeButtonClicked(ModelId)
        }
    }
}
