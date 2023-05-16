import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

ImageBoxBody {
    id: woodenBox
    source: "qrc:/images/boxes/woodenbox.png"

    bodyType: Body.Dynamic
    world: physicsWorld

    density: 1
    friction: 0.3
    restitution: 0.5
}
