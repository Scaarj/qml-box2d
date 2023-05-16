import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    property int selected: -1

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    SpeciesModel {
        id: speciesModel
    }

    World {
        id: physicsWorld
        gravity: Qt.point(0, 0)
    }

    Repeater {
        anchors.fill: parent
        model: speciesModel
        delegate: SpeciesInfo {
            id: speciesInfo
            x: Math.random() * (root.width - radius)
            y: Math.random() * (root.height - radius)
            expanded: index == root.selected
            speciesName: species
            descriptionText: description
            photoUrl: photo
            onSelected: root.selected = index
        }
    }

    ScreenBoundaries {}

    DebugDraw {
        world: physicsWorld
        visible: false
    }
}
