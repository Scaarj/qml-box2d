import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

Rectangle {
    id: square

    color: "green"

    property Body body: BoxBody {
        width: square.width
        height: square.height

        target: square
        world: physicsWorld

        fixedRotation: false
        sleepingAllowed: false
        bodyType: Body.Dynamic

        density: 1
        friction: 1
        restitution: 0.3
    }
}
