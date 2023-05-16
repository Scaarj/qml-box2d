import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

PhysicsItem {
    id: wall

    signal beginContact(Fixture other)

    fixtures: Box {
        width: wall.width
        height: wall.height
        friction: 1
        density: 1
        onBeginContact: wall.beginContact(other)
    }

    Image {
        source: "qrc:/images/raycast/wall.jpg"
        fillMode: Image.Tile
        anchors.fill: parent
    }
}
