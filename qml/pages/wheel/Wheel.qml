import QtQuick 2.6
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    Rectangle {
        anchors { left: parent.left; right: parent.right; top: parent.top; bottom: controls.top }
        color: "#EFEFFF"
    }

    Component {
        id: ballsComponent
        PhysicsItem {
            id: ball
            width: 20
            height: 20
            bodyType: Body.Dynamic
            property color boxColor: "blue"
            fixtures: Circle {
                id: fx
                radius: ball.width / 2
                density: 0.1
                friction: 1
                restitution: 0.5
            }
            Rectangle {
                radius: parent.width / 2
                border.color: "blue"
                color: "#EFEFEF"
                width: parent.width
                height: parent.height
                smooth: true
            }
        }
    }
    World { id: physicsWorld }

    Wall {
        id: topWall
        height: 40
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }
    }

    Wall {
        id: leftWall
        width: 40
        anchors {
            left: parent.left
            top: parent.top
            bottom: controls.top
            bottomMargin: 40
        }
    }

    Wall {
        id: rightWall
        width: 40
        anchors {
            right: parent.right
            top: parent.top
            bottom: controls.top
            bottomMargin: 40
        }
    }

    PhysicsItem {
        id: ground
        height: 40
        anchors {
            left: parent.left
            right: parent.right
            bottom: controls.top
        }
        fixtures: Box {
            width: ground.width
            height: ground.height
            friction: 1
            density: 1
        }
        Rectangle {
            anchors.fill: parent
            color: "#DEDEDE"
        }
    }

    PhysicsItem {
        anchors { right: parent.right; bottom: controls.top; bottomMargin: 40; rightMargin: 40 }
        width: 300
        height: 300
        fixtures: Chain {
            vertices: [
                Qt.point(0,300),
                Qt.point(210,180),
                Qt.point(240,130),
                Qt.point(240,50),
                Qt.point(220,0),
                Qt.point(300,0),
                Qt.point(300,300)
            ]
        }
        Canvas {
            id: canvas1
            anchors.fill: parent
            onPaint: {
                var context = canvas1.getContext("2d");
                context.beginPath();
                context.moveTo(0,300);
                context.lineTo(210,180);
                context.lineTo(240,130);
                context.lineTo(240,50);
                context.lineTo(220,0);
                context.lineTo(300,0);
                context.lineTo(300,300);
                context.fillStyle = "#AAA";
                context.fill();
            }
        }
    }

    Wall {
        anchors.right: parent.right
        anchors.rightMargin: 40
        width:500
        height: 40
        y: 220
    }

    PhysicsItem {
        id: body
        property int speed: speedSlider.value
        property int k: -1
        x: 400
        y: 100
        width: 100
        height: 20
        bodyType: Body.Dynamic
        fixtures: Box {
            width: body.width
            height: body.height
            density: 0.8
            friction: 0.5
            restitution: 0.8
        }
        Rectangle {
            anchors.fill: parent
            color: "orange"
        }
    }
    PhysicsItem {
        id: wheelA
        x: 500
        y: 100
        width: 48
        height: 48
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheelA.width / 2
            density: 0.8
            friction: 10
            restitution: 0.8
        }
        Image {
            source: "qrc:/images/wheel/wheel.png"
            anchors.fill: parent
        }
    }

    PhysicsItem {
        id: wheelB
        x: 400
        y: 100
        width: 48
        height: 48
        bodyType: Body.Dynamic
        fixtures: Circle {
            radius: wheelB.width / 2
            density: 0.8
            friction: 10
            restitution: 0.8
        }
        Image {
            source: "qrc:/images/wheel/wheel.png"
            anchors.fill: parent
        }
    }

    WheelJoint {
        id: wheelJointA
        bodyA: body.body
        bodyB: wheelA.body
        localAnchorA: Qt.point(100,10)
        localAnchorB: Qt.point(24,24)
        enableMotor: true
        motorSpeed: body.k * body.speed
        maxMotorTorque: torqueSlider.value
        frequencyHz: 10
    }

    WheelJoint {
        id: wheelJointB
        bodyA: body.body
        bodyB: wheelB.body
        localAnchorA: Qt.point(0,10)
        localAnchorB: Qt.point(24,24)
        enableMotor: true
        motorSpeed: body.k * body.speed
        maxMotorTorque: torqueSlider.value
        frequencyHz: 10
    }

    ColumnLayout {
        id: controls
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

        Button {
            text: "Debug view: " + (debugDraw.visible ? "on" : "off")
            onClicked: debugDraw.visible = !debugDraw.visible;
        }

        RowLayout {
            Layout.fillWidth: true
            Text {
                id: leftMotorStateSpeed
                text : "Speed: " + speedSlider.value
                font: Theme.fontSizeMedium
                color: Theme.primaryColor
            }

            Slider {
                id: speedSlider
                Layout.fillWidth: true
                minimumValue: 0
                maximumValue: 720
                value: 0
                stepSize: 1
            }
        }

        RowLayout {
            Layout.fillWidth: true
            Text {
                id: leftMotorStateTorque
                text : "Torque: " + torqueSlider.value
                font: Theme.fontSizeMedium
                color: Theme.primaryColor
            }

            Slider {
                id: torqueSlider
                Layout.fillWidth: true
                minimumValue: 1
                maximumValue: 100
                value: 50
                stepSize: 1
            }
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                icon.source: "qrc:/images/wheel/arrow.png"
                onClicked:  body.k = -1
            }

            Button {
                Layout.fillWidth: true
                icon {
                    source: "qrc:/images/wheel/arrow.png"
                    rotation: 180
                }

                onClicked: body.k = 1
            }
        }

    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        opacity: 0.5
        z: 1
        visible: false
    }

    Timer {
        id: ballsTimer
        interval: 1000
        running: true
        repeat: true
        onTriggered: {
            var newBox = ballsComponent.createObject(root);
            newBox.x = 40 + Math.round(Math.random() * 720);
            newBox.y = 50;
        }
    }
}
