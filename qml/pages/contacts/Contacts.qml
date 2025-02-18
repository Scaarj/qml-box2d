import QtQuick 2.6
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    readonly property int wallMeasure: 40 

    Component {
        id: rectComponent
        RectangleBoxBody {
            id: rect
            width: 20
            height: 20

            world: physicsWorld
            bodyType: Body.Dynamic

            property variant colors : [
                "#FF0000","#FF8000","#FFFF00","#00FF00",
                "#0080FF","#0000FF","#FF00FF","#FFFFFF"
            ]
            property int colorIndex : 0
            property bool animateDeletion: false

            property bool isBall: true
            density: 0.5
            friction: 1
            restitution: 0.2

            border.color: "#999"
            color: colors[colorIndex]
            radius: 3

            PropertyAnimation {
                target: rect
                property: "opacity"
                duration: 1000
                to: 0
                easing.type: Easing.InCubic
                running: animateDeletion
                onRunningChanged: {
                    if (!running) {
                        rect.destroy()
                    }
                }
            }
        }
    }

    World {
        id: physicsWorld

        onPreSolve: {
            var targetA = contact.fixtureA.getBody().target
            var targetB = contact.fixtureB.getBody().target
            if (targetA.isBall && contact.fixtureB === topBeltFixture)
                contact.tangentSpeed = -3.0
            else if (targetB.isBall && contact.fixtureA === topBeltFixture)
                contact.tangentSpeed = 3.0
        }
    }

    Item {
        id: physicsRoot
        anchors.fill: parent

        PhysicsItem {
            id: ground
            height: ((root.height - 600) + wallMeasure)
            world: physicsWorld
            anchors {
                top: bottomBelt.bottom
                left: parent.left
                right: parent.right
                bottom: debugButton.top
            }
            fixtures: Box {
                id: groundFixture
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

        Item {
            id: topWall
            height: 10
            y: -10
            anchors.left: parent.left
            anchors.right: parent.right
            BoxBody {
                target: topWall
                world: physicsWorld
                width: topWall.width
                height: topWall.height
            }
        }

        Wall {
            id: leftWall
            width: wallMeasure
            anchors {
                left: parent.left
                top: parent.top
                bottom: parent.bottom
            }
        }

        Wall {
            id: rightWall
            width: wallMeasure
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
        }

        PhysicsItem {
            id: drivingWheel
            width: 48
            height: 48
            world: physicsWorld
            bodyType: Body.Dynamic
            fixtures: Circle {
                radius: 24
                density: 0.5
            }
            Image {
                anchors.fill: parent
                source: "qrc:/images/contacts/wheel.png"
            }
        }

        PhysicsItem {
            id: drivenWheel
            width: 48
            height: 48
            world: physicsWorld
            bodyType: Body.Dynamic
            fixtures: Circle {
                radius: 24
                density: 0.5
            }
            Image {
                anchors.fill: parent
                source: "qrc:/images/contacts/wheel.png"
            }
        }

        PhysicsItem {
            id: topBelt
            x: 65
            y: 500
            width: 600
            height: 5
            world: physicsWorld
            fixtures: Box {
                id: topBeltFixture
                width: topBelt.width
                height: topBelt.height
                density: 0.5
            }
            Rectangle {
                anchors.fill: parent
                color: "#000"
                radius: 5
            }
        }
        Rectangle {
            id: bottomBelt
            x: 65
            y: 543
            width: 600
            height: 5
            color: "#000"
            radius: 5
        }

        RevoluteJoint {
            bodyA: topBelt.body
            bodyB: drivingWheel.body
            localAnchorA: Qt.point(600,24)
            localAnchorB: Qt.point(24,24)
            collideConnected: false
            enableMotor: true
            motorSpeed: 180
            maxMotorTorque: 100
        }

        RevoluteJoint {
            bodyA: topBelt.body
            bodyB: drivenWheel.body
            localAnchorA: Qt.point(0,24)
            localAnchorB: Qt.point(24,24)
            collideConnected: false
            enableMotor: true
            motorSpeed: 180
            maxMotorTorque: 100
        }
        PhysicsItem {
            id: tube
            anchors { right: parent.right; rightMargin: wallMeasure }
            y: 10
            width: 250
            height: 450
            world: physicsWorld
            fixtures: [
                Chain {
                    vertices: [
                        Qt.point(0,60),
                        Qt.point(170,60),
                        Qt.point(180,70),
                        Qt.point(180,350),
                        Qt.point(170,400),
                        Qt.point(170,430)
                    ]
                },
                Chain {
                    vertices: [
                        Qt.point(0,5),
                        Qt.point(190,5),
                        Qt.point(225,25),
                        Qt.point(240,60),
                        Qt.point(240,350),
                        Qt.point(250,400),
                        Qt.point(250,430)
                    ]
                }
            ]
            Canvas {
                id: canvas
                anchors.fill: parent
                onPaint: {
                    var context = canvas.getContext("2d")
                    context.beginPath()
                    context.moveTo(0,60)
                    context.lineTo(170,60)
                    context.lineTo(180,70)
                    context.lineTo(180,350)
                    context.lineTo(170,400)
                    context.lineTo(170,430)
                    context.lineTo(250,430)
                    context.lineTo(250,400)
                    context.lineTo(240,350)
                    context.lineTo(240,60)
                    context.lineTo(225,25)
                    context.lineTo(190,5)
                    context.lineTo(0,5)
                    context.lineTo(0,60)
                    context.fillStyle = "#DEDEDE"
                    context.lineWidth = 1
                    context.lineJoin = "miter"
                    context.fill()
                    context.strokeStyle = "#999"
                    context.stroke()
                }
            }
        }

        BoxBody {
            id: flowVertical
            x: 660
            y: 60
            width: 60
            height: 500
            world: physicsWorld
            sensor: true
            onBeginContact: {
                other.getBody().gravityScale = -4
            }
        }
        BoxBody {
            id: flowHorizontal
            x: 500
            y: 10
            width: 240
            height: 60
            world: physicsWorld
            sensor: true
            onBeginContact: {
                var body = other.getBody()
                body.gravityScale = 0.5
                body.applyLinearImpulse(Qt.point(-5,0), Qt.point(24,24))
            }
            onEndContact: {
                var body = other.getBody()
                body.gravityScale = 1
                body.applyForce(Qt.point(5,0), Qt.point(24,24))
                var rect = body.target
                var index = rect.colorIndex
                index ++
                rect.colorIndex = index
                if ((index + 1) === rect.colors.length)
                    rect.animateDeletion = true
            }
        }

        Button {
            id: debugButton
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
            text: debugDraw.visible ? "Debug view: on" : "Debug view: off"
            onClicked: debugDraw.visible = !debugDraw.visible;
        }

        Timer {
            id: rectTimer
            interval: 2000
            running: true
            repeat: true
            onTriggered: {
                var newBox = rectComponent.createObject(physicsRoot)
                newBox.x = 60 + (Math.random() * 300)
                newBox.y = 200
            }
        }

        DebugDraw {
            id: debugDraw
            anchors.fill: parent
            world: physicsWorld
            opacity: 0.7
            visible: false
        }
    }
}
