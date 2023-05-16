import QtQuick 2.6
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root

    readonly property int wallMeasure: 40 
    readonly property int ballDiameter: 20

    Component {
        id: linkComponent
        PhysicsItem {
            id: ball

            width: 20
            height: 20
            bodyType: Body.Dynamic

            property color color: "#EFEFEF"

            fixtures: Circle {
                radius: ball.width / 2
                density: 0.5
            }

            Rectangle {
                radius: parent.width / 2
                border.color: "blue"
                color: parent.color
                width: parent.width
                height: parent.height
                smooth: true
            }
        }
    }

    Component {
        id: jointComponent
        RopeJoint {
            localAnchorA: Qt.point(10,10)
            localAnchorB: Qt.point(10,10)
            maxLength: lengthSlider.value
            collideConnected: true
        }
    }

    World { id: physicsWorld }

    Component.onCompleted: {
        var prev = leftWall;
        for (var i = 60;i < 740;i += 20) {
            var newLink = linkComponent.createObject(root);
            newLink.color = "orange";
            newLink.x = i;
            newLink.y = 100;
            var newJoint = jointComponent.createObject(root);
            if (i === 60)
                newJoint.localAnchorA = Qt.point(40, 100);
            newJoint.bodyA = prev.body;
            newJoint.bodyB = newLink.body;
            prev = newLink;
        }
        newJoint = jointComponent.createObject(root);
        newJoint.localAnchorB = Qt.point(0,100);
        newJoint.bodyA = prev.body;
        newJoint.bodyB = rightWall.body;
    }

    PhysicsItem {
        id: ground
        height: 40
        anchors { left: parent.left; right: parent.right; bottom: debugBtn.top }
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
            bottom: parent.bottom
            bottomMargin: 40
        }
    }

    Wall {
        id: rightWall
        width: 40
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
            bottomMargin: 40
        }
    }

    ColumnLayout {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom }

        Slider {
            id: lengthSlider
            Layout.fillWidth: true
            maximumValue: 50
            minimumValue: 20
            value: 30
        }

        Button {
            id: debugBtn
            anchors { horizontalCenter: parent.horizontalCenter; bottom: parent.bottom }
            text: "Debug view: " + (debugDraw.visible ? "on" : "off")
            onClicked: debugDraw.visible = !debugDraw.visible;
        }
    }

    DebugDraw {
        id: debugDraw
        world: physicsWorld
        opacity: 1
        visible: false
    }

    function xPos() {
        if (typeof xPos.min === 'undefined') {
        xPos.min = Math.ceil(wallMeasure)
        xPos.max = Math.floor(root.width - (wallMeasure + ballDiameter))
        }
        return (Math.floor(Math.random() * (xPos.max - xPos.min)) + xPos.min)
    }

    Timer {
        id: ballsTimer
        interval: 500
        running: true
        repeat: true
        onTriggered: {
            var newBox = linkComponent.createObject(root);
            newBox.x = xPos()
            newBox.y = 50;
        }
    }
}
