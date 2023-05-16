import QtQuick 2.6
import QtQuick.Window 2.2
import QtQuick.Layouts 1.1
import Box2DStatic 2.0
import QtMultimedia 5.0
import Sailfish.Silica 1.0
import "../shared"

Page {
    id: root

    readonly property int wallMeasure: 40

    function createDominos() {
        var i

        for (i = 0; i < 5; i++) {
            var newDomino = dominoComponent.createObject(root)
            newDomino.x = 500 + 50 * i
            newDomino.y = 510
        }
        for (i = 0; i < 4; i ++) {
            newDomino = dominoComponent.createObject(root)
            newDomino.x = 525 + 50 * i
            newDomino.y = 480
            newDomino.rotation = 90
        }
        for (i = 0; i < 4; i ++) {
            newDomino = dominoComponent.createObject(root)
            newDomino.x = 525 + 50 * i
            newDomino.y = 450
        }
        for (i = 0; i < 3; i ++) {
            newDomino = dominoComponent.createObject(root)
            newDomino.x = 550 + 50 * i
            newDomino.y = 420
            newDomino.rotation = 90
        }
    }

    function createChain() {
        var i, prev = chainAnchor
        for (i = 0; i < 12; i++) {
            var y = 300 + i * 20 - 5
            var newLink = link.createObject(root)
            newLink.y = y
            var newJoint = linkJoint.createObject(root)
            newJoint.bodyA = prev.body
            newJoint.bodyB = newLink.body
            prev = newLink
        }
    }

    Component.onCompleted: {
        createDominos();
        createChain();
    }

    Component {
        id: link
        Rectangle {
            id: chainBall

            width: 20
            height: 20
            x: 400
            color: "orange"
            radius: 10

            property Body body: circleBody

            CircleBody {
                id: circleBody
                target: chainBall
                world: physicsWorld

                bodyType: Body.Dynamic
                radius: 10
                friction: 0.9
                density: 0.8
            }
        }
    }

    Component {
        id: linkJoint
        RevoluteJoint {
            localAnchorA: Qt.point(10, 30)
            localAnchorB: Qt.point(10, 5)
            collideConnected: true
        }
    }

    Component {
        id: ball
        Rectangle {
            id: bulletBall

            width: 10
            height: 10
            radius: 5
            color: "black"
            smooth: true

            property Body body: circleBody

            CircleBody {
                id: circleBody

                target: bulletBall
                world: physicsWorld

                bullet: true
                bodyType: Body.Dynamic

                radius: 5
                density: 0.9
                friction: 0.9
                restitution: 0.2
            }
        }
    }

    Component {
        id: dominoComponent
        RectangleBoxBody {
            width: 10
            height: 50
            x: 0
            y: 510
            color: "black"

            world: physicsWorld
            bodyType: Body.Dynamic

            density: 1
            friction: 0.3
            restitution: 0.5
        }
    }

    World { id: physicsWorld }

    RectangleBoxBody {
        id: ground
        world: physicsWorld
        anchors {
            top: canonBase.bottom
            left: parent.left
            right: parent.right
            bottom: controls.top
        }
        friction: 1
        density: 1
        color: "#DEDEDE"
    }

    Wall {
        id: topWall
        height: wallMeasure
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
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

    ImageBoxBody {
        id: canon
        bodyType: Body.Dynamic
        world: physicsWorld
        x: 150
        y: 443
        source: "qrc:/images/cannon/cannon.png"
        density: 0.5
    }

    ImageBoxBody {
        id: canonBase
        x: 50
        y: 493
        source: "qrc:/images/cannon/cannon_base.png"
        world: physicsWorld
        density: 0.5
    }

    RevoluteJoint {
        id: joint
        bodyA: canonBase.body
        bodyB: canon.body
        localAnchorA: Qt.point(75, 18)
        localAnchorB: Qt.point(36, 19)
        collideConnected: false
        motorSpeed: 0
        enableMotor: false
        maxMotorTorque: 100
        enableLimit: true
        lowerAngle: 0
        upperAngle: -60
    }

    RectangleBoxBody {
        id: chainAnchor
        width: 20
        height: 20
        x: 400
        y: 230
        color: "black"
        world: physicsWorld
    }

    ColumnLayout {
        id: controls
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: wallMeasure;
            rightMargin: anchors.leftMargin }

        Button {
            id: debugButtonText
            Layout.fillWidth: true
            text: debugDraw.visible ? "Debug view: on" : "Debug view: off"
            onClicked: {
                debugDraw.visible = !debugDraw.visible
                debugButtonText.text = debugDraw.visible ? "Debug view: on" : "Debug view: off"
            }
        }

        Slider {
            id: power
            Layout.fillWidth: true
            minimumValue: 0.01
            maximumValue: 5
            value: 3
        }

        RowLayout {
            Layout.fillWidth: true

            Button {
                Layout.fillWidth: true
                text: "up"
                onPressed: {
                    canon.fixture.density = 0.5
                    joint.motorSpeed = -15
                    joint.enableMotor = true
                    gearSound.play()
                }
                onReleased: {
                    joint.motorSpeed = 0
                    gearSound.stop()
                }
            }

            Button {
                Layout.fillWidth: true
                text: "down"
                onPressed: {
                    joint.motorSpeed = 15
                    joint.enableMotor = true
                    gearSound.play()
                }
                onReleased: {
                    joint.motorSpeed = 0
                    gearSound.stop()
                }
            }

            Button {
                Layout.fillWidth: true
                text: "fire!"
                onClicked: {
                    var angle = Math.abs(joint.getJointAngle())
                    var offsetX = 65 * Math.cos(angle * Math.PI / 180)
                    var offsetY = 65 * Math.sin(angle * Math.PI / 180)
                    var newBall = ball.createObject(root)
                    newBall.x = 125 + offsetX
                    newBall.y = 500 - offsetY
                    var impulse = power.value
                    var impulseX = impulse * Math.cos(angle * Math.PI / 180)
                    var impulseY = impulse * Math.sin(angle * Math.PI / 180)
                    newBall.body.applyLinearImpulse(Qt.point(impulseX, -impulseY), newBall.body.getWorldCenter())
                    shotSound.play()
                }
            }
        }

    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        visible: false
        z: 1
    }

    SoundEffect { id: shotSound; source: "qrc:/sound/cannon/cannon.wav" }
    SoundEffect { id: gearSound; source: "qrc:/sound/cannon/gear.wav" }
}
