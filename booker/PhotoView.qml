import QtQuick 2.0

Item {
    id: root
    width: 600
    height: 400
    property string imgSource: "img/camera.png"
    property string fullImgSource: "image://bookmembersprovider/" + imgSource

    signal buttonClicked

    Image {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        width: (root.width > root.height ? root.height : root.width) * 0.9
        height: width
        fillMode: Image.PreserveAspectFit
        source: root.imgSource
    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
            buttonClicked();
        }
    }
}
