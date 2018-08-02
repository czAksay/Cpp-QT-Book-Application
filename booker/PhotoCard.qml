import QtQuick 2.0

Item {
    width: 100
    height: 100
    property string imgSource: "none"
    property int chosenIndex: 0

    signal buttonClicked

    Image {
        id: img
        source: imgSource
        anchors.fill: parent
    }

    Image {
        id: camera
        fillMode: Image.PreserveAspectFit
        source: "img/camera.png"
        anchors.fill: parent
        anchors.margins: 6
        opacity: mouseArea.containsMouse ? 0.5 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: 150
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: containsMouse ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: {
            buttonClicked();
        }
    }
}
