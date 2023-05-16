import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {

    World {
        id: physicsWorld

        onStepped: {
            joint.step += 0.2;
            if (joint.step > width - 150)
                joint.step = 0;
            joint.linearOffset = Qt.point(joint.step + 100, Math.sin(joint.step * 6.0));
            joint.angularOffset = Math.sin(joint.step / 8.0) * 10.0;
        }
    }

    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: waves.top }
        color: "white"
    }

    Rectangle {
        id: waves
        height: 30
        y: 260
        anchors {
            left: parent.left
            right: parent.right
        }
        Image {
            id: waveImg
            source: "qrc:/images/motorjoint/wave.png"
            fillMode: Image.Tile
            anchors.fill: parent
        }
    }

    Rectangle {
        id: water
        anchors { left: parent.left; right: parent.right; top: waves.bottom; bottom: debugBtn.top }
        color: "#74c2e6"
    }

    PhysicsItem {
        id: berth
        height: 30
        width: 100
        x: 0
        y: 260
        fixtures: Box {
            width: berth.width
            height: berth.height
        }
        Rectangle {
            anchors.fill: parent
            color: "brown"
        }
    }

    PhysicsItem {
        id: boat
        width: 64
        height: 64
        x: 100
        y: 250
        bodyType: Body.Dynamic
        fixtures: Box {
            width: boat.width
            height: boat.height
            friction: 0.6
            density: 2

        }
        Image {
            id: boatImg
            source: "qrc:/images/motorjoint/boat.png"
            anchors.fill: parent
        }
    }

    MotorJoint {
        id: joint
        bodyA: berth.body
        bodyB: boat.body
        maxForce: 1000
        maxTorque: 1000
        property double step: 0.0
        angularOffset: 0
    }

    Button {
        id: debugBtn
        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
        text: debugDraw.visible ? "Debug view: on" : "Debug view: off"
        onClicked: debugDraw.visible = !debugDraw.visible;
    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        visible: false
    }
}
