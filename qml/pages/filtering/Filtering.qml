import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    World { id: physicsWorld }

    Repeater {
        model: 5
        delegate: RectangleBoxBody {
            x: index * 150 + 10
            y: Math.random() * (root.height / 3)
            width: 50
            height: 50

            world: physicsWorld
            sleepingAllowed: false
			bodyType: Body.Dynamic

            density: 1
            friction: 0.3
            restitution: 0.5
            categories: Box.Category2
            collidesWith: Box.Category1 | Box.Category3 | Box.Category4

            rotation: Math.random() * 90

            color: "blue"
            opacity: 0.5
        }
    }

    Repeater {
        model: 5
        delegate: RectangleBoxBody {
            x: index * 150 + 10
            y: Math.random() * (root.height / 3)
            width: 50
            height: 50

            world: physicsWorld
            sleepingAllowed: false
			bodyType: Body.Dynamic

            density: 1
            friction: 0.3
            restitution: 0.5
            categories: Box.Category3
            collidesWith: Box.Category1 | Box.Category2 | Box.Category4

            rotation: Math.random() * 90;

            color: "red"
            opacity: 0.5
        }
    }

    Repeater {
        model: 5
        delegate: RectangleBoxBody {
            x: index * 150 + 10
            y: Math.random() * (root.height / 3)
            width: 50
            height: 50

            world: physicsWorld
            sleepingAllowed: false
            fixedRotation: true

			bodyType: Body.Dynamic

            density: 1
            friction: 0.3
            restitution: 0.5
            categories: Box.Category4
            collidesWith: Box.All

            rotation: Math.random() * 90;

            color: "green"
            opacity: 0.5
        }
    }

    ScreenBoundaries {}
}
