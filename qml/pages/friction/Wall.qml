import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

ImageBoxBody {
    world: physicsWorld

    source: "qrc:/images/mouse/wall.jpg"
    fillMode: Image.Tile

    friction: 1
    density: 1
}
