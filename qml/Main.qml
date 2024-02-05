
/**
 * Copyright(c) Live2D Inc. All rights reserved.
 * Licensed under the MIT License. See LICENSE file in the project root for license information.
 */
import QtCore
import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import NLPluginApi

Window {
    id: window
    width: 640
    height: 500
    visible: true
    title: Application.name
    color: palette.window

    License {
        id: licenseWindow
    }

    // call from C++
    function autoConnect(port) {
        api.autoLaunched = true
        api.port = port
        api.open()
    }

    NLPluginApi {
        id: api
        enableAutoLaunch: true
        pluginName: Application.name
        pluginDeveloper: Application.organization
        pluginVersion: Application.version
        readonly property bool closed: state === NLPluginApi.Closed
        readonly property bool available: state === NLPluginApi.Available
        onStateChanged: function (state) {
            if (state === NLPluginApi.Closed && api.autoLaunched)
                Qt.quit()
        }
    }

    Settings {
        category: "api"
        property alias token: api.token
        property alias port: api.port
    }

    // Models
    ListModel {
        id: modelList
        function setData(data) {
            clear()
            for (let model of data.Models) {
                append(model)
            }
        }
    }
    Connections {
        target: api
        function onStateChanged() {
            if (api.available) {
                api.send(Method.GetModels).accepted.connect(modelList.setData)
                api.send(Method.NotifyModelsChanged)
            }
        }
        function onEventReceived(method, data) {
            if (method === Method.NotifyModelsChanged) {
                modelList.setData(data)
            }
        }
    }
    // RegisteredModels
    ListModel {
        id: registeredModelList
        function setData(data) {
            clear()
            for (let model of data.RegisteredModels) {
                append(model)
            }
        }
    }
    Connections {
        target: api
        function onStateChanged() {
            if (api.available) {
                api.send(Method.GetRegisteredModels).accepted.connect(
                            registeredModelList.setData)
            }
        }
    }

    component SplitBar: Rectangle {
        property bool vertical: false
        implicitHeight: vertical ? parent.height : 2
        implicitWidth: vertical ? 2 : parent.width
        color: palette.base.hslLightness < 0.5 ? "white" : "black"
    }

    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Item {
            Layout.fillWidth: true
            Layout.preferredHeight: 24

            Row {
                anchors.centerIn: parent
                height: parent.height
                spacing: 8
                Rectangle {
                    anchors.verticalCenter: parent.verticalCenter
                    width: 12
                    height: width
                    radius: width / 2
                    color: api.closed ? "#f00" : api.available ? "#0f0" : "#ff0"
                }
                Text {
                    anchors.verticalCenter: parent.verticalCenter
                    text: "Port"
                    color: palette.text
                }
                TextField {
                    width: 60
                    anchors.verticalCenter: parent.verticalCenter
                    text: String(api.port)
                    validator: IntValidator {}
                    onTextEdited: api.port = text
                }
                Button {
                    anchors.verticalCenter: parent.verticalCenter
                    text: api.closed ? "Connect" : "Disconnect"
                    onClicked: api.closed ? api.open() : api.close()
                }
            }

            Button {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "About"
                onClicked: licenseWindow.show()
            }
        }

        SplitBar {}

        ModelListView {
            id: modelListView
            removable: true
            model: modelList
            onRemoveButtonClicked: function (modelId) {
                api.send(Method.RemoveModel, {
                             "ModelId": modelId
                         })
            }
        }

        SplitBar {}

        RegisteredModelListView {
            model: registeredModelList
            onAddModelClicked: function (modelPath) {
                api.send(Method.AddModel, {
                             "SceneId": modelListView.selectedSceneId,
                             "ModelPath": modelPath
                         })
            }
            onChangeModelClicked: function (modelPath) {
                api.send(Method.ChangeModel, {
                             "ModelId": modelListView.selectedModelId,
                             "ModelPath": modelPath
                         })
            }
            onNewWindowClicked: function (modelPath) {
                api.send(Method.AddModel, {
                             "ModelPath": modelPath
                         })
            }
        }

        Item {
            Layout.fillHeight: true
            Layout.fillWidth: true
        }
    }
}
