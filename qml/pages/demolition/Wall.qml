import QtQuick 2.6
import "../shared"

ImageBoxBody {
    source: "qrc:/images/demolition/brickwall.png"
    fillMode: Image.Tile

    world: physicsWorld
    friction: 1.0
}
