import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

PhysicsItem {
    id: wall

    fixtures: Box {
        width: wall.width
        height: wall.height
        friction: 1
        density: 1
    }

    Image {
        source: "qrc:/images/rope/wall.jpg"
        fillMode: Image.Tile
        anchors.fill: parent
    }
}
