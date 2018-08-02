import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

ApplicationWindow  {
    id: root
    visible: true
    width: 440
    height: 520
    title: qsTr("Settings & Help")
    modality: Qt.ApplicationModal

    onClosing: {
        statecontroller.endSettingsEvent();
    }

    Image {
        id: imgFon
        anchors.fill: parent
        source: "img/note.png"
    }

    RowLayout {
        id: rowTop
        height: 60
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.topMargin: 15

        Text {
            id: textSettings
            text: qsTr("Settings & Help")
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 24
            Layout.fillHeight: true
            //Layout.fillWidth: true
            Layout.leftMargin: 25
        }

        Item {
            Layout.fillHeight: true
            width: rowTop.height
            Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
            Layout.rightMargin: 20

            Image {
                source: "img/settings.png"
                anchors.fill: parent
            }
        }
    }

    GridLayout {
        id: mainGrid
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowTop.bottom
        height: 165
        anchors.margins: 15
        property variant tiles: ["Размер шрифта текста", "Размер плиток", "Поворот плиток при наведении"]
        flow: GridLayout.TopToBottom
        rows: tiles.length

        Repeater {
            id: labelRepeat
            model: mainGrid.tiles

            Rectangle {
                color: "#60DDDDDD"
                border.color: "Black"
                width: 170
                height: 40
                Text {
                    id: text1
                    anchors.fill:parent
                    anchors.leftMargin: 5
                    font.pixelSize: 16
                    wrapMode: Text.WordWrap
                    font.family: "Times New Roman"
                    text: modelData + ":"
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Slider {
            id: fontSizeSlider
            Layout.fillWidth: true
            minimumValue: settingscontroller.fontSize.minValue
            maximumValue: settingscontroller.fontSize.maxValue
            value: settingscontroller.fontSize.value
            stepSize: 2

            onValueChanged: {
                display.textToShow = value
            }
        }
        Slider {
            id: tileSizeSlider
            Layout.fillWidth: true
            minimumValue: settingscontroller.tileSize.minValue
            maximumValue: settingscontroller.tileSize.maxValue
            value: settingscontroller.tileSize.value
            stepSize: 5

            onValueChanged: {
                display.textToShow = value
            }
        }
        CheckBox {
            id: rotateTilesCheckBox
            Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
            checked: settingscontroller.rotateTiles.value > 0 ? true : false

            onCheckedChanged: {
                display.textToShow = checked
            }
        }
    }

    RowLayout {
        id: rowWithButtons
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: mainGrid.bottom
        height: 55
        anchors.margins: 15
        spacing: 8

        MyButton {
            id: btnSave
            Layout.fillHeight: true
            Layout.fillWidth: true
            imgSource: "img/yes.png"

            onButtonClickedSignal: {
                settingscontroller.setSettings(fontSizeSlider.value, tileSizeSlider.value, rotateTilesCheckBox.checked?1:0);
                root.close();
            }
        }

        MyButton {
            id: btnCancel
            Layout.fillHeight: true
            Layout.fillWidth: true
            imgSource: "img/no.png"

            onButtonClickedSignal: {
                root.close()
            }
        }
    }

    ValueDisplay {
        id: display
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowTop.bottom
        anchors.topMargin: -15
    }

    TextArea {
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: rowWithButtons.bottom
        anchors.bottom: parent.bottom
        anchors.margins: 10
        readOnly: true
        font.pixelSize: 15
        text: "Чтобы добавить новый элемент в коллекцию, нажмите в главном окне кнопку с плюсиком, затем в появившемся окне введите его имя, дату рождения и биографию, а также укажите путь к файлу с его фотографией и нажмите кнопку \"Добавить\".\n\nПросмотр данных об элементе производится путем нажатия на его плитку в коллекции. Удаление элемента происходит путем выбора его в коллекции и нажатия кнопки со значком мусорки в правой части экрана. Кнопка с символом глаза прячет информацию о выбранном элементе.\n\nДля просмотра увеличенной фотографии элемента, выберите его в коллекции и нажмите на его появившуюся фотографию в правом верхнем углу.\n\nДанные элемента сохраняются в корневую папку приложения."
    }
}
