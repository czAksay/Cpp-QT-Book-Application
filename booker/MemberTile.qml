import QtQuick 2.0

Rectangle {
    id: root
    width: size
    height: width
    border.color: "black"
    border.width: 2
    color: "#50DDDDDD"
    //color: "transparent"
    property int size: 50
    property string nameText: "Name"
    property string logoPath: "error"
    property string logoFullPath: "image://bookmembersprovider/"+logoPath
    property int rotationAngle: 0
    property int newRotationAngle: 0
    property color blackoutColor: "#00000000"

    signal signalClicked
    signal signalMouseUp

    transform: Rotation { origin.x: 30; origin.y: 30; angle: rotationAngle }

    Image {
        id: logo
        source: logoFullPath
        anchors.fill: parent
        anchors.margins: 2
    }

    states: [
        State {
            name: "Normal"
            when: !mouseArea.containsMouse

            PropertyChanges {
                target: root
                scale: 1
                rotationAngle: 0
                blackoutColor: "#00000000"
            }
            PropertyChanges {
                target: textName
                opacity: 0
            }
        },
        State {
            name: "Hovered"
            when: mouseArea.containsMouse

            PropertyChanges {
                rotationAngle: newRotationAngle
                target: root
                scale: 1.4
                blackoutColor: "#CB000000"
            }
            PropertyChanges {
                target: textName
                opacity: 1
            }
        }
    ]

    onStateChanged: {
        if(state == "Normal")
        {
            //угол поворота = градус от 0 до 6  |  если в настройках включено  |  по часовой стрелке или против
            newRotationAngle = Math.random() * 7 * settingscontroller.rotateTiles.value * (Math.floor(Math.random() * 2) == 1 ? 1 : -1);
        }
    }

    transitions: [
        Transition {
            from: "Normal"
            to: "Hovered"
            NumberAnimation {
                targets: root
                properties: "scale"
                duration: 255
            }
            NumberAnimation {
                targets: root
                properties: "rotationAngle"
                duration: 265
            }
            SequentialAnimation {
                PauseAnimation { duration: 1000; }

                ParallelAnimation {
                    ColorAnimation {
                        target: root
                        property: "blackoutColor"
                        duration: 400
                    }
                    NumberAnimation {
                        target: textName
                        property: "opacity"
                        duration: 250
                    }
                }
            }
        },
        Transition {
            from: "Hovered"
            to: "Normal"
            NumberAnimation {
                targets: root
                properties: "scale"
                duration: 205
            }
            NumberAnimation {
                targets: root
                properties: "rotationAngle"
                duration: 235
            }
            ColorAnimation {
                target: root
                property: "blackoutColor"
                duration: 250
            }
            NumberAnimation {
                target: textName
                property: "opacity"
                duration: 250
            }
        }
    ]

    Text {
        visible: false
        id: name
        text: root.nameText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.fill: parent
        font.pixelSize: 16
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: {
            root.signalClicked()
        }

        onHoveredChanged: {
            if (containsMouse)
                root.signalMouseUp();
        }
    }

    Rectangle {
        id: blackout
        anchors.fill: parent
        gradient: Gradient {
            GradientStop {position: 0.0; color: blackoutColor;}
            GradientStop {position: 0.45; color: "#00000000";}
            GradientStop {position: 0.55; color: "#00000000";}
            GradientStop {position: 1.0; color: blackoutColor;}
        }
    }

    Text {
        id: textName
        text: nameText
        wrapMode: Text.WrapAnywhere
        horizontalAlignment: Text.AlignHCenter
        font.family: "Times New Roman"
        font.pointSize: 12
        color: "White"
        anchors.left: parent.left
        anchors.right: parent.right

    }
}
