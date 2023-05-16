import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import QtSensors 5.0
import "../shared"

Page {
    id: root

    Image {
        anchors.fill: parent
        source: "qrc:/images/accelerometer/background.png"
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

    ScreenBoundaries {}

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        opacity: 0.75
        visible: false
    }

    MouseArea {
        id: debugMouseArea
        anchors.fill: parent
        onPressed: debugDraw.visible = !debugDraw.visible
    }

    Accelerometer {
        Component.onCompleted: start()
        onReadingChanged: {
            var r = reading
            physicsWorld.gravity = Qt.point(r.x, r.y)
        }
    }
}
