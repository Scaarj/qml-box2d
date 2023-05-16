import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0

Page {
    id: root

    Image {
        anchors.fill: parent
        source: "qrc:/images/boxes/background.png"
    }

    World { id: physicsWorld }

    Repeater {
        model: 3
        delegate: WoodenBox {
            x: Math.random() * (root.width - 100)
            y: Math.random() * (root.height / 3)
            rotation: Math.random() * 90
        }
    }

    Wall {
        id: ground
        anchors { left: parent.left; right: parent.right; top: parent.bottom }
        height: 20
    }

    Wall {
        id: ceiling
        anchors { left: parent.left; right: parent.right; bottom: parent.top }
        height: 20
    }

    Wall {
        id: leftWall
        anchors { right: parent.left; bottom: ground.top; top: ceiling.bottom }
        width: 20
    }

    Wall {
        id: rightWall
        anchors { left: parent.right; bottom: ground.top; top: ceiling.bottom }
        width: 20
    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        anchors.fill: parent
        opacity: 0.75
        visible: false
    }

    MouseArea {
        id: debugMouseArea
        anchors.fill: parent
        onPressed: debugDraw.visible = !debugDraw.visible
    }
}
