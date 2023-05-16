import QtQuick 2.6
import Box2DStatic 2.0
import "../shared"

ImageBoxBody {
    source: "qrc:/images/fixtures/wall.jpg"
    fillMode: Image.Tile

    world: physicsWorld

    friction: 1
    density: 1
}
