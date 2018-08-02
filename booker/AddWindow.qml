import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

ApplicationWindow  {
    id: root
    visible: true
    width: 420
    height: 500
    title: qsTr("Add member")
    modality: Qt.ApplicationModal

    onClosing: {
        statecontroller.endAddingEvent();
    }

    Image {
        id: fon
        anchors.fill: parent
        source: "img/note.png"
    }

    property int rowsHeight: 28

    GridLayout {
        id: mainGrid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 185
        anchors.margins: 15
        property variant tiles: ["Имя", "Дата рождения", "Фото", "Биография"]
        flow: GridLayout.TopToBottom
        rows: tiles.length

        Repeater {
            id: labelRepeat
            model: mainGrid.tiles

            Rectangle {
                color: "#60DDDDDD"
                border.color: "Black"
                width: 170
                height: root.rowsHeight
                Text {
                    id: text1
                    anchors.fill:parent
                    anchors.leftMargin: 5
                    font.pixelSize: 15
                    font.family: "Times New Roman"
                    text: modelData + ":"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        TextField {
            id: textName
            text: ""
            placeholderText: "Введите имя"
            font.pixelSize: 14
            font.family: "times new roman"
            Layout.fillWidth: true
            maximumLength: 50
        }

        RowLayout {
            id: rowDate
            Layout.fillWidth: true
            height: root.rowsHeight
            property int spinWidth: 60
            spacing: 5

            SpinBox {
                id: day
                minimumValue: 1
                maximumValue: 31
                value: minimumValue
                width: parent.spinWidth
                Layout.fillWidth:true
            }
            SpinBox {
                id: month
                minimumValue: 1
                maximumValue: 12
                value: minimumValue
                width: parent.spinWidth
                Layout.fillWidth:true
            }
            SpinBox {
                id: year
                minimumValue: 1
                maximumValue: 2018
                value: maximumValue
                width: parent.spinWidth * 1.5
                Layout.fillWidth:true
            }
        }

        Button {
            id: btnOpenFile
            text: fileChosen ? (filePath.length > 10 ? "..." + filePath.substring(filePath.length - 10, filePath.length): filePath): "Выбрать..."
            Layout.preferredWidth: 125
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter

            property string filePath: "none"
            property bool fileChosen: false

            onClicked: {
                fileDialog.visible = true
            }
        }
    }

    TextArea {
        id: textBio
        property int marg: 15
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainGrid.bottom
        anchors.bottom: parent.bottom
        anchors.bottomMargin: marg * 6
        anchors.leftMargin: marg
        anchors.rightMargin: marg
    }

    Button {
        id: btnSave
        text: "Save"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: textBio.bottom
        anchors.margins: 15
        enabled: textName.length > 0 && btnOpenFile.fileChosen

        onClicked:  {
            bookcontroller.add(textName.text, day.value, month.value, year.value, btnOpenFile.filePath, textBio.text);
            root.close();
        }
    }

    FileDialog {
        id: fileDialog
        title: "Выберите фото"
        nameFilters: [ "Image files (*.jpg *.jpeg *.png *.bmp)" ]
        folder: shortcuts.home
        onAccepted: {
            btnOpenFile.fileChosen = true
            btnOpenFile.filePath = fileUrl
        }
    }
}
