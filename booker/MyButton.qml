import QtQuick 2.0

Rectangle {
    id: root
    width: 400
    height: 80
    border.color: "black"
    border.width: 1
    property string imgSource: "none"
    property double heightPercent: 0.6

    property color grColor1: grColorNormal
    property color grColorNormal: "#C9A85C"
    property color grColorHovered:"#E9C88C"
    property color grColorPressed: "#B7964A"

    signal buttonClickedSignal

    gradient: Gradient {
        GradientStop { position: 0.35; color: grColor1 }
        GradientStop { position: 1.0; color: "#808080" }
    }

    Image {
        id: image
        width: height
        height: root.height * root.heightPercent
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: imgSource
        //visible: source == "none"
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor

        onClicked: {
            root.buttonClickedSignal()
        }

        onPressed: {
            root.grColor1 = root.grColorPressed
        }

        onReleased: {
            root.grColor1 = root.grColorNormal
        }
    }

    state: "Normal"

    states: [
        State {
            name: "Normal"
            when: !mouseArea.containsMouse

            PropertyChanges {
                target: root
                scale: 1
                grColor1: grColorNormal
            }
        },
        State {
            name: "Hovered"
            when: mouseArea.containsMouse

            PropertyChanges {
                target: root
                scale: 1.04
                grColor1: grColorHovered
            }
        }
    ]

    transitions: [
        Transition {
            from: "Normal"
            to: "Hovered"
            ColorAnimation {
                targets: root
                properties: "grColor1"
                duration: 400
            }
            NumberAnimation {
                targets: root
                properties: "scale"
                duration: 165
            }
        },
        Transition {
            from: "Hovered"
            to: "Normal"
            NumberAnimation {
                targets: root
                properties: "scale"
                duration: 500
            }
            ColorAnimation {
                targets: root
                properties: "grColor1"
                duration: 500
            }
        }
    ]
}
