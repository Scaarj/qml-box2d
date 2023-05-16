import QtQuick 2.6
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root
    focus: true

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
            revolute.motorSpeed -= 10;
        }
        else if (event.key === Qt.Key_Right) {
            revolute.motorSpeed += 10
        }
        event.accepted = true;
    }

    // BOX2D WORLD
    World { id: physicsWorld }

    PhysicsItem {
        id: rod

        sleepingAllowed: false
        bodyType: Body.Dynamic
        x: 350
        y: 300

        width: 250
        height: 40

        fixtures: Box {
            width: rod.width
            height: rod.height
            density: 1;
            friction: 1;
            restitution: 0.3;
        }

        Rectangle {
            color: "green"
            radius: 6
            anchors.fill: parent
        }
    }

    PhysicsItem {
        id: middle

        x: 400
        y: 300

        fixtures: Circle { radius: itemShape.radius }

        Rectangle {
            id: itemShape
            radius: width / 2
            width: 40; height: 40
            color: "black"
        }
    }

    RevoluteJoint {
        id: revolute
        maxMotorTorque: 1000
        motorSpeed: 0
        enableMotor: false
        bodyA: middle.body
        bodyB: rod.body
        localAnchorA: Qt.point(20,20)
    }

    // Debug
    DebugDraw {
        id: debugDraw
        world: physicsWorld
        opacity: 0.5
        visible: false
    }

    MouseArea {
        anchors.fill: parent
        onClicked: revolute.enableMotor = !revolute.enableMotor
    }



    ColumnLayout {
        id: buttons

        anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }

        Text {
            id: motorText
            Layout.alignment: Qt.AlignHCenter

            text: "Motor: " + ((revolute.enableMotor === true) ? "on" : "off")
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: "on"
                onPressed: revolute.enableMotor = true
            }

            Button {
                Layout.fillWidth: true
                text: "off"
                onPressed: revolute.enableMotor = false
            }
        }

        Text {
            id: motorSpeed
            Layout.alignment: Qt.AlignHCenter

            text: "Motorspeed: " + revolute.motorSpeed
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: "-"
                onPressed: revolute.motorSpeed -= 10
            }

            Button {
                Layout.fillWidth: true
                text: "+"
                onPressed: revolute.motorSpeed += 10
            }
        }
    }
}
