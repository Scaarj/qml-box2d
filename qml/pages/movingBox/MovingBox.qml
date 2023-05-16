import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root
    width: 800
    height: 600
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
            movableBox.moveBackward();
        }
        else if (event.key === Qt.Key_Right) {
            movableBox.moveForward();
        }
        else if (event.key === Qt.Key_Up) {
            movableBox.jump();
        }
        event.accepted = true;
    }

    Keys.onReleased: {
        if (event.isAutoRepeat)
            return ;

        if (event.key === Qt.Key_Left ||
            event.key === Qt.Key_Right) {
            movableBox.stopMoving();
        }
    }

    World { id: physicsWorld; }

    Repeater {
        model: 4
        delegate: WoodenBox {
            x: Math.random() * (root.width - 100);
            y: Math.random() * (root.height / 3);
            rotation: Math.random() * 90;
        }
    }

    MovableBox {
        id: movableBox
        width: 40
        height: width
    }

    ScreenBoundaries {}
}
