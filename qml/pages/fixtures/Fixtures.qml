import QtQuick 2.6
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    readonly property int wallMeasure: 40 
    readonly property int ballDiameter: 20

    function xPos() {
        if (typeof xPos.min === 'undefined') {
            xPos.min = Math.ceil(wallMeasure)
            xPos.max = Math.floor(root.width - (wallMeasure + ballDiameter))
        }
        return (Math.floor(Math.random() * (xPos.max - xPos.min)) + xPos.min)
    }

    Component {
        id: ballComponent
        Rectangle {
            id: ball

            width: ballDiameter
            height: ballDiameter
            radius: 10
            border.color: "blue"
            color: "#EFEFEF"

            CircleBody {
                target: ball
                world: physicsWorld

                bodyType: Body.Dynamic

                radius: ball.width / 2
                density: 0.1
                friction: 0.3
                restitution: 0.5
            }
        }
    }

    Text {
        width: parent.width
        y: 50
        text: "Fixtures tests"
        font.pixelSize: Theme.fontSizeMedium
        color: Theme.primaryColor
        horizontalAlignment: Text.AlignHCenter
    }

    World { id: physicsWorld }

    PhysicsItem {
        id: ground

        function getVertices(height) {
            var pos = height
            var arr = []
            arr.push(Qt.point(0,0))
            arr.push(Qt.point(height,0))
            while (pos < 700) {
                var y = Math.round(Math.random() * height)
                var x = Math.round(20 + Math.random() * 40)
                pos += x
                arr.push(Qt.point(pos,y))
            }
            arr.push(Qt.point(760,0))
            arr.push(Qt.point(800,0))
            arr.push(Qt.point(800,height))
            arr.push(Qt.point(0,height))
            return arr
        }

        height: 140
        anchors { left: parent.left; right: parent.right; bottom: controlsLayout.top; leftMargin: wallMeasure;
        rightMargin: anchors.leftMargin; bottomMargin: anchors.leftMargin }
        z: 100
        fixtures: Chain {
            id: groundShape
            vertices: ground.getVertices(ground.height)
            loop: true
        }
        Canvas {
            id: groundCanvas
            anchors.fill: parent
            onPaint: {
                var context = groundCanvas.getContext("2d");
                context.beginPath()
                context.moveTo(0,0)
                var points = groundShape.vertices
                for (var i = 1; i < points.length; i++) {
                    var point = points[i]
                    var x = point.x
                    var y = point.y
                    context.lineTo(x,y)
                }
                context.fillStyle = "#000000"
                context.fill()
            }
        }
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
            bottomMargin: wallMeasure
        }
    }

    Wall {
        id: rightWall
        width: wallMeasure
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            bottomMargin: wallMeasure
        }
    }

    PhysicsItem {
        id: dynamicTest
        x: 200
        y: 150
        width: 200
        height: 30
        fixtures: [
            Box {
                x: 0
                y: 0
                width: dynamicTest.width * 0.45
                height: dynamicTest.height
            },
            Box {
                x: dynamicTest.width * 0.55
                y: 0
                width: dynamicTest.width * 0.45
                height: dynamicTest.height
            }
        ]
        Rectangle {
            anchors.fill: parent
            color: "blue"
        }
    }

    PhysicsItem {
        id: staticTest
        x: 350
        y: 250
        width: 100
        height: 25
        fixtures: Box {
            x: 0
            y: 0
            width: 100
            height: 25
        }
        Rectangle {
            anchors.fill: parent
            color: "orange"
        }
    }

    PhysicsItem {
        id: radiusTest
        bodyType: Body.Dynamic
        x: 600
        y: 100
        fixtures: [
            Circle {
                id: circleShape
                radius: 50
                x: -circleShape.radius
                y: -circleShape.radius
                density: 0.9
                friction: 0.3
                restitution: 0.8
            }
        ]
        Rectangle {
            width: circleShape.radius * 2
            height: circleShape.radius * 2
            anchors.centerIn: parent
            radius: circleShape.radius
            color: "red"
        }
    }

    PhysicsItem {
        id: polygonTest
        world: physicsWorld
        bodyType: Body.Dynamic
        x: 450
        y: 50
        width: 100
        height: 100
        fixtures: Polygon {
            vertices: [
                Qt.point(polygonTest.width / 2,0),
                Qt.point(polygonTest.width,polygonTest.height),
                Qt.point(0,polygonTest.height)
            ]
            density: 0.9
            friction: 0.3
            restitution: 0.8
        }
        Canvas {
            id: canvas
            anchors.fill: parent
            onPaint: {
                var context = canvas.getContext("2d")
                context.beginPath()
                context.moveTo(parent.width / 2,0)
                context.lineTo(0,parent.height)
                context.lineTo(parent.width,parent.height)
                context.lineTo(parent.width / 2,0)
                context.fillStyle = "green"
                context.fill()
            }
        }
    }

    ColumnLayout {
        id: controlsLayout
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; leftMargin: wallMeasure;
            rightMargin: anchors.leftMargin }

        Text {
            id: ballsCounter
            property int count: 0
            Layout.alignment: Qt.AlignHCenter
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
            text: count + " balls"
        }

        Button {
            text: debugDraw.visible ? "Debug view: on" : "Debug view: off"
            onClicked: debugDraw.visible = !debugDraw.visible
        }

        GridLayout {
            columns: 2

            Button {
                text: "Falling balls"
                onClicked: ballsTimer.running = !ballsTimer.running
            }

            Button {
                text: "Dynamic fixtures"
                onClicked: {
                    if(dynamicTest.width == 300)
                    {
                        dynamicTest.width = 200
                        dynamicTest.height = 30
                    }
                    else
                    {
                        dynamicTest.width = 300
                        dynamicTest.height = 50
                    }
                }
            }

            Button {
                text: "Static fixture"
                onClicked: {
                    if(staticTest.width == 200)
                    {
                        staticTest.width = 100
                        staticTest.height = 25
                    }
                    else
                    {
                        staticTest.width = 200
                        staticTest.height = 50
                    }
                }
            }

            Button {
                text: "Circle"
                onClicked: {
                    if (circleShape.radius == 75)
                        circleShape.radius = 50
                    else
                        circleShape.radius = 75
                }
            }

            Button {
                text: "Polygon"
                onClicked: {
                    if(polygonTest.height == 100 && polygonTest.width == 100)
                        polygonTest.height = 200
                    else if(polygonTest.height == 200 && polygonTest.width == 100)
                        polygonTest.width = 200
                    else
                    {
                        polygonTest.height = 100
                        polygonTest.width = 100
                    }
                }
            }

            Button {
                text: "Chain"
                onClicked: {
                    if (ground.height == 40)
                        ground.height = 100
                    else
                        ground.height = 40
                }
            }
        }
    }

    Timer {
        id: ballsTimer
        interval: 200
        running: false
        repeat: true
        onTriggered: {
            var newBox = ballComponent.createObject(root)
            newBox.x = xPos()
            newBox.y = 50
            ballsCounter.count++
        }
    }

    DebugDraw {
        id: debugDraw
        anchors.fill: parent
        world: physicsWorld
        opacity: 1
        visible: false
    }
}
