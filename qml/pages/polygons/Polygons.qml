import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    readonly property int wallMeasure: 32

    function xPos() {
        if (typeof xPos.min === 'undefined') {
        xPos.min = Math.ceil(wallMeasure)
        xPos.max = Math.floor(root.width - wallMeasure)
        }
        return (Math.floor(Math.random() * (xPos.max - xPos.min)) + xPos.min)
    }


    World { id: physicsWorld; }

    Repeater {
        model: 10
        delegate: Trapezoid {
            x: xPos();
            y: Math.random() * (root.height / 3);
            rotation: Math.random() * 90;
        }
    }

    ScreenBoundaries {}

    DebugDraw {
        world: physicsWorld
        opacity: 0.75
        visible: true
    }
}
