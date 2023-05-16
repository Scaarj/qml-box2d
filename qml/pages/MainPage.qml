/*******************************************************************************
**
** Copyright (C) 2022 ru.auroraos
**
** This file is part of the My Aurora OS Application project.
**
** Redistribution and use in source and binary forms,
** with or without modification, are permitted provided
** that the following conditions are met:
**
** * Redistributions of source code must retain the above copyright notice,
**   this list of conditions and the following disclaimer.
** * Redistributions in binary form must reproduce the above copyright notice,
**   this list of conditions and the following disclaimer
**   in the documentation and/or other materials provided with the distribution.
** * Neither the name of the copyright holder nor the names of its contributors
**   may be used to endorse or promote products derived from this software
**   without specific prior written permission.
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
** AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
** THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
** FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
** IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
** FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY,
** OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
** PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
** LOSS OF USE, DATA, OR PROFITS;
** OR BUSINESS INTERRUPTION)
** HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
** WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE)
** ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
** EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**
*******************************************************************************/

import QtQuick 2.6
import Sailfish.Silica 1.0

Page {
    objectName: "mainPage"
    allowedOrientations: Orientation.All

    ListModel {
        id: scenesList
        ListElement {
            name: "accelerometer"
            path: "accelerometer/Accelerometer.qml"
        }
        ListElement {
            name: "angletracking"
            path: "angletracking/AngleTracking.qml"
        }
        ListElement {
            name: "boxes"
            path: "boxes/Boxes.qml"
        }
        ListElement {
            name: "cannon"
            path: "cannon/Cannon.qml"
        }
        ListElement {
            name: "contacts"
            path: "contacts/Contacts.qml"
        }
        ListElement {
            name: "demolition"
            path: "demolition/Demolition.qml"
        }
        ListElement {
            name: "distance"
            path: "distance/Distance.qml"
        }
        ListElement {
            name: "filtering"
            path: "filtering/Filtering.qml"
        }
        ListElement {
            name: "fixtures"
            path: "fixtures/Fixtures.qml"
        }
        ListElement {
            name: "friction"
            path: "friction/Friction.qml"
        }
        ListElement {
            name: "gear"
            path: "gear/Gear.qml"
        }
        ListElement {
            name: "impulse"
            path: "impulse/Impulse.qml"
        }
        ListElement {
            name: "monera"
            path: "monera/Monera.qml"
        }
        ListElement {
            name: "motorjoint"
            path: "motorjoint/Boat.qml"
        }
        ListElement {
            name: "mouse"
            path: "mouse/Mouse.qml"
        }
        ListElement {
            name: "movingBox"
            path: "movingBox/MovingBox.qml"
        }
        ListElement {
            name: "polygons"
            path: "polygons/Polygons.qml"
        }
        ListElement {
            name: "prismatic"
            path: "prismatic/Prismatic.qml"
        }
        ListElement {
            name: "pulley"
            path: "pulley/Pulley.qml"
        }
        ListElement {
            name: "raycast"
            path: "raycast/Raycast.qml"
        }
        ListElement {
            name: "revolute"
            path: "revolute/Revolute.qml"
        }
        ListElement {
            name: "rope"
            path: "rope/Rope.qml"
        }
        ListElement {
            name: "weld"
            path: "weld/Weld.qml"
        }
        ListElement {
            name: "wheel"
            path: "wheel/Wheel.qml"
        }
    }

    PageHeader {
        id: pageHeader

        objectName: "pageHeader"
        title: qsTr("Box2d examples")
    }

    ListView {
        id: listView
        anchors { top: pageHeader.bottom; left: parent.left; right: parent.right; bottom: parent.bottom }
        model: scenesList
        spacing: Theme.paddingSmall

        delegate: Button {
            width: parent.width
            text: name

            onClicked: pageStack.push(Qt.resolvedUrl(path))
        }
    }
}
