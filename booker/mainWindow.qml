import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4
import QtQml.StateMachine 1.11 as FSM

Item {
    id: root
    property int columnsLeftMarg: width * 0.055
    property int columnsTopMarg: height * 0.045 //22
    property int columnsBotMarg: height * 0.04
    property int columnsRightMarg: width * 0.02

    Item {
        id: rootToMakeUnabled
        anchors.fill: parent


    Image {
        anchors.fill: parent
        source: "img/book_fon.png"
    }

    signal startReading
    signal startSelecting

    Rectangle {
        id: leftSide
        color: "transparent"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width / 2

        ColumnLayout {
            id: leftSideColumn
            spacing: 12
            anchors.fill: parent
            anchors.leftMargin: root.columnsLeftMarg
            anchors.topMargin: root.columnsTopMarg
            anchors.bottomMargin: root.columnsBotMarg
            anchors.rightMargin: root.columnsRightMarg

            Rectangle {
                color: "#30dedede"
                Layout.fillHeight: true
                border.color: "#40000000"
                border.width: 2
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true

                GridView {
                    id: gridView
                    //flow: GridView.TopToBottom
                    anchors.fill: parent
                    anchors.margins: 10
                    cellWidth: settingscontroller.tileSize.value
                    cellHeight: cellWidth
                    model: bookcontroller.model

                    //создаем соединение вручную, т.к. получить сигнал из структуры при изменении в ней данных не получается
                    Connections {
                        target: settingscontroller
                        onSettingsChanged: {
                            gridView.cellWidth = settingscontroller.tileSize.value
                        }
                    }

                    add: Transition {
                        SequentialAnimation {
                            NumberAnimation {properties: "scale"; from: 0.0; to: 1.85; duration: 280 }
                            NumberAnimation {properties: "scale"; to: 1.0; duration: 220 }
                        }
                    }

                    delegate: Item
                    {
                        id: itemDelegate
                        width: gridView.cellWidth
                        height: gridView.cellHeight

                        MemberTile {
                            anchors.centerIn: parent
                            id: memberTile
                            size: gridView.cellWidth - 5
                            nameText: mName
                            logoPath: mLogo

                            onSignalClicked: {
                                logoImg.imgSource = logoFullPath;
                                textName.text = mName;
                                textDate.text = mDate;
                                textBio.text = mBio;
                                statecontroller.startReadingEvent();
                                logoImg.chosenIndex = index
                            }

                            onSignalMouseUp: {
                                for(var i = 0; i < gridView.count; i++)
                                {
                                    gridView.currentIndex = i;
                                    gridView.currentItem.z = i;
                                }
                                gridView.currentIndex = index;
                                gridView.currentItem.z = gridView.count;
                            }
                        }

                        GridView.onRemove: SequentialAnimation {
                            PropertyAction { target: itemDelegate; property: "GridView.delayRemove"; value: true }
                            ParallelAnimation {
                                NumberAnimation { target: itemDelegate;  properties: "scale"; to: 0; duration: 200 }
                            }
                            PropertyAction { target: itemDelegate; property: "GridView.delayRemove"; value: false }
                        }
                    }
                }
            }

            Rectangle {
                color: "#30dedede"
                Layout.alignment: Qt.AlignLeft | Qt.AlignBottom
                border.color: "#40000000"
                border.width: 2
                height: 68
                Layout.fillWidth: true

                RowLayout {
                    id: rowAddAndSettings
                    anchors.fill: parent
                    anchors.topMargin: 5
                    anchors.bottomMargin: 5
                    anchors.leftMargin: 8
                    anchors.rightMargin: 8
                    spacing: 7

                    MyButton {
                        id: btnAdd
                        imgSource: "img/add.png"
                        Layout.fillHeight: true
                        Layout.fillWidth: true
                        onButtonClickedSignal: {
                            statecontroller.startAddingEvent();
                            statecontroller.openAddWindow();
                        }
                    }

                    MyButton {
                        id: btnSettings
                        Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                        imgSource: "img/settings.png"
                        Layout.fillHeight: true
                        width: 140

                        onButtonClickedSignal: {
                            statecontroller.startSettingsEvent();
                            statecontroller.openSettingsWindow();
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: rightSide
        color: "transparent"
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: parent.width / 2

        ColumnLayout {
            id: rightSideColumn
            spacing: 12
            Layout.alignment: Qt.AlignLeft | Qt.AlignTop
            anchors.fill: parent
            anchors.leftMargin: root.columnsRightMarg
            anchors.topMargin: root.columnsTopMarg
            anchors.bottomMargin: root.columnsBotMarg
            anchors.rightMargin: root.columnsLeftMarg
            opacity: 0
            visible: opacity == 0 ? false : true

            Behavior on opacity {
                NumberAnimation {
                    duration: 200
                }
            }

            Rectangle {
                id: infoRect
                color: "#30dedede"
                border.color: "#40000000"
                border.width: 2
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                height: 130

                Rectangle {
                    id: logoImgFon
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.right: parent.right
                    anchors.margins: 5
                    width: height
                    color: "transparent"
                    border.color: "black"
                    border.width: 2

                    PhotoCard {
                        id: logoImg
                        anchors.fill: parent
                        anchors.margins: 2
                        imgSource: "img/error.png"
                        chosenIndex: -1

                        onButtonClicked: {
                            photoView.imgSource = imgSource
                            photoView.visible = true
                            statecontroller.startCardViewEvent()
                        }
                    }
                }

                Text {
                    id: textName
                    font.pixelSize: 22
                    font.family: "Times New Roman"
                    text: "Name"
                    wrapMode: Text.WordWrap
                    horizontalAlignment: Text.AlignRight
                    anchors.right: logoImgFon.left
                    anchors.margins: 10
                    anchors.left: parent.left
                    y: 15
                }

                Text {
                    id: textDate
                    font.pixelSize: 15
                    font.family: "Palatino Linotype"
                    text: "01.01.0001"
                    horizontalAlignment: Text.AlignRight
                    anchors.right: logoImgFon.left
                    y: textName.y + textName.height + 5
                    anchors.left: parent.left
                    anchors.margins: 10
                }
            }

            Rectangle {
                id: bioFon
                color: "#30dedede"
                border.color: "#40000000"
                border.width: 2
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                Layout.fillWidth: true
                //height: 50

                ColumnLayout {
                    id: bioColumnLayout
                    anchors.fill: parent
                    spacing: 12

                    TextArea {
                        id: textBio
                        Layout.alignment: Qt.AlignLeft | Qt.AlignTop
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.margins: 4
                        readOnly: true
                        backgroundVisible: false
                        font.pixelSize: settingscontroller.fontSize.value

                        Connections {
                            target: settingscontroller
                            onSettingsChanged: {
                                textBio.font.pixelSize = settingscontroller.fontSize.value
                            }
                        }
                    }

                    Rectangle {
                        height: 68
                        color: "transparent"
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignLeft | Qt.AlignBottom

                        RowLayout {
                            id: rowDelFon
                            anchors.fill: parent
                            anchors.topMargin: 5
                            anchors.bottomMargin: 5
                            anchors.leftMargin: 8
                            anchors.rightMargin: 8
                            spacing: 7

                            MyButton {
                                id: btnDelete
                                imgSource: "img/delete.png"
                                height: rowDelFon.height
                                Layout.fillWidth: true

                                onButtonClickedSignal: {
                                    bookcontroller.remove(logoImg.chosenIndex);
                                    statecontroller.startSelectingEvent();
                                }
                            }

                            MyButton {
                                id: btnHide
                                imgSource: "img/hide.png"
                                height: rowDelFon.height
                                Layout.fillWidth: true

                                onButtonClickedSignal: {
                                    statecontroller.startSelectingEvent();
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle {
        id: blackFrame
        color: "#9A000000"
        visible: opacity==0?false:true
        opacity: 0
        anchors.fill: parent
    }

    //состояние selecting - выбираем плитку, reading - читаем текст
    //sleeping - открывается другое окно и текущее теряет фокус
    //после sleeping мы возвращаемся к selecting или reading с пом. historystate
    FSM.StateMachine {
        id: machine
        running: true
        initialState: parentState

        FSM.State {
            id: parentState
            initialState: selectingState

            FSM.State {
                id: selectingState
                onEntered: { console.debug("selecting") }
            }

            FSM.State {
                id: readingState
                onEntered: { console.debug("reading") }
            }

            FSM.SignalTransition {
                targetState: selectingState
                signal: statecontroller.signalSelectingStarted
            }

            FSM.SignalTransition {
                targetState: readingState
                signal: statecontroller.signalReadingStarted
            }

            FSM.State {
                id: sleepingState
                onEntered: { console.debug("sleeping") }
            }

            FSM.HistoryState {
                id: beforeSleepingHistory
                defaultState: selectingState
            }

            FSM.SignalTransition {
                targetState: sleepingState
                signal: statecontroller.signalSleep
            }

            FSM.SignalTransition {
                targetState: beforeSleepingHistory
                signal: statecontroller.signalSleepStop
            }
        }
    }

    state: "selectingState1"

    states: [
        State {
            name: "selectingState1"
            when: selectingState.active

            PropertyChanges {
                target: rightSideColumn
                opacity: 0
            }
        },
        State {
            name: "readingState1"
            when: readingState.active

            PropertyChanges {
                target: rightSideColumn
                opacity: 1
            }
        },
        State {
            name: "sleepingState1"
            when: sleepingState.active

            PropertyChanges {
                target: rootToMakeUnabled
                enabled: false
            }
            PropertyChanges {
                target: blackFrame
                opacity: 1
            }
        }
    ]

    transitions: Transition {
            NumberAnimation {
                targets: blackFrame
                properties: "opacity"
                duration: 250
            }
        }
}

    PhotoView {
        id: photoView
        visible: false
        anchors.fill: parent

        onButtonClicked: {
            visible = false
            statecontroller.endCardViewEvent()
        }
    }
}
