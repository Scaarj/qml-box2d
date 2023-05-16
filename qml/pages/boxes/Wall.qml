import QtQuick 2.6
import "../shared"

Item {
    id: wall

    BoxBody {
        target: wall
        world: physicsWorld

        width: wall.width
        height: wall.height
    }
}
