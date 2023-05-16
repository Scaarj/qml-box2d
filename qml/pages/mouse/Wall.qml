import QtQuick 2.6
import "../shared"

ImageBoxBody {
    source: "qrc:/images/mouse/wall.jpg"
    fillMode: Image.Tile

    world: physicsWorld

    friction: 1
    density: 1
}
