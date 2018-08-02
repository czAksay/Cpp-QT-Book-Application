import QtQuick 2.0

Rectangle {
    id: root
    color: "#33000000"
    width: 300
    height: 35
    property string textToShow: "0"
    visible: opacity > 0 ? true : false

    Text {
        text: root.textToShow
        font.pointSize: 14
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        onTextChanged: {
            root.opacity = 1
            if (timer.running)
                timer.restart();
            timer.running = true;
        }
    }

    Behavior on opacity {
        NumberAnimation {
            duration: 120
        }
    }

    Timer {
        id: timer
        running: false
        interval: 1000

        onTriggered: {
            root.opacity = 0
            running = false
        }
    }
}
