import QtQuick 2.6
import QtQuick.Layouts 1.1
import Sailfish.Silica 1.0
import Box2DStatic 2.0
import "../shared"

Page {
    id: root
    focus: true

    property bool enableTracking: false
    property real requestedAngle: 0

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
        	console.log("Key left")
            revolute.motorSpeed -= 10
        }
        else if (event.key === Qt.Key_Right) {
        	console.log("Key right")
            revolute.motorSpeed += 10
        }
	    else if (event.key === Qt.Key_Up) {
	    	console.log("Key up")
	    	revolute.enableMotor = true
		    revolute.maxMotorTorque = 200
		    enableTracking = true
	    }
		else if (event.key === Qt.Key_Down) {
			console.log("Key down")
		    revolute.enableMotor = false
		    enableTracking = false
		}
        event.accepted = true
    }

    Text {
        id: helpText
        anchors {
            right: parent.right
            top: parent.top
            left: parent.left
        }
        horizontalAlignment: Text.AlignHCenter
        text: "Mouse click to set new tracking point (if motor active)"
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeMedium
        wrapMode: Text.WrapAtWordBoundaryOrAnywhere
    }

    Text {
        id: angleText
        anchors { top: helpText.bottom; right: parent.right; margins: Theme.paddingSmall }
        horizontalAlignment: Text.AlignHCenter

        text: "Angle: " + requestedAngle.toFixed(0)
        color: Theme.primaryColor
        font.pixelSize: Theme.fontSizeMedium
    }

    // BOX2D WORLD
    World { 
    	id: physicsWorld

    	onStepped: {
    		if(enableTracking) {
                var targetAngle = root.requestedAngle
	    		var angleError = revolute.getJointAngle() - targetAngle
                var gain = 1.4
	    		var newMotorSpeed = -gain * angleError

	    		revolute.motorSpeed = newMotorSpeed
	    	}
    	}
	}

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
            density: 1
            friction: 1
            restitution: 0.3
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
            width: 40
            height: 40
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

    MouseArea {
        anchors.fill: parent
        onClicked: {
            var radTodeg = 57.295779513082320876
            var bodyAPosition = Qt.vector2d(middle.x, middle.y)
            var localAnchorRevolute = Qt.vector2d(revolute.localAnchorA.x, revolute.localAnchorA.y)
            var globalPositionRevolute = bodyAPosition.plus(localAnchorRevolute)
            var mousePosition = Qt.vector2d(mouseX, mouseY)
            var differenceVector = mousePosition.minus(globalPositionRevolute)

            root.requestedAngle = Math.atan2(differenceVector.y, differenceVector.x) * radTodeg
        }
    }


    ColumnLayout {
        anchors { left: parent.left; right: parent.right; bottom: parent.bottom; margins: Theme.paddingSmall}

        Text {
            id: motorText
            Layout.alignment: Qt.AlignHCenter

            text: "Motor: " + ((revolute.enableMotor === true) ? "on" : "off")
            font.pixelSize: Theme.fontSizeMedium
            color: Theme.primaryColor
        }

        Row {
            Layout.alignment: Qt.AlignHCenter

            Button {
                Layout.fillWidth: true
                text: "on"
                onPressed: {
                    revolute.enableMotor = true
                    revolute.maxMotorTorque = 200
                    enableTracking = true
                }
            }

            Button {
                Layout.fillWidth: true
                text: "off"
                onPressed: {
                    revolute.enableMotor = false
                    enableTracking = false
                }
            }
        }
    }
}
