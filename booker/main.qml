import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4

ApplicationWindow  {
    visible: true
    width: 960
    height: 665
    title: qsTr("Booker")

    Loader {
        source: "mainWindow.qml"
        anchors.fill: parent
    }
}
