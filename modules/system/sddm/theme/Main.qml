import QtQuick 2.15
import QtQuick.Controls 2.15
import QtGraphicalEffects 1.15
import Sddm 1.0

Rectangle {
    id: root
    width: 1920
    height: 1080
    color: "black"

    // -------------------------------
    // BACKGROUND + BLUR (Hyprlock style)
    // -------------------------------
    Image {
        id: bg
        anchors.fill: parent
        source: "background.jpg"   // Cambialo o symlink allo screenshot
        fillMode: Image.PreserveAspectCrop
    }

    GaussianBlur {
        anchors.fill: bg
        source: bg
        radius: 24    // equivalente ~ blur_passes 3
        samples: 32
    }

    // -------------------------------
    // DATE LABEL
    // -------------------------------
    Text {
        id: dateText
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 + 250
        text: Qt.formatDate(new Date(), "dddd, MMMM dd")
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 25
        color: "#FFFFFFE6"
        horizontalAlignment: Text.AlignHCenter

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: dateText.text =
                Qt.formatDate(new Date(), "dddd, MMMM dd")
        }
    }

    // -------------------------------
    // CLOCK LABEL (BIG)
    // -------------------------------
    Text {
        id: clockText
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 + 150
        text: Qt.formatTime(new Date(), "hh:mm")
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 120
        color: "#FFFFFFE6"
        horizontalAlignment: Text.AlignHCenter

        Timer {
            interval: 1000
            running: true
            repeat: true
            onTriggered: clockText.text =
                Qt.formatTime(new Date(), "hh:mm")
        }
    }

    // -------------------------------
    // OUTER ROUNDED BOX (Top)
    // -------------------------------
    Rectangle {
        width: 600
        height: 300
        radius: 40
        border.width: 2
        border.color: "white"
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 + 175
    }

    // -------------------------------
    // USER BOX
    // -------------------------------
    Rectangle {
        width: 450
        height: 175
        radius: 30
        border.width: 2
        border.color: "#FFFFFFCC"
        color: "transparent"
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - 85

        Column {
            anchors.centerIn: parent

            Text {
                id: userLabel
                text: "\uf007  " + sddm.user
                font.family: "JetBrainsMono Nerd Font"
                font.pixelSize: 35
                color: "#FFFFFF"
                horizontalAlignment: Text.AlignHCenter
            }
        }
    }

    // -------------------------------
    // PASSWORD FIELD
    // -------------------------------
    Rectangle {
        width: 300
        height: 50
        anchors.horizontalCenter: parent.horizontalCenter
        y: parent.height / 2 - 125
        radius: 8
        color: "#FFFFFF1A"
        border.width: 2
        border.color: "transparent"

        TextInput {
            id: passwordField
            anchors.fill: parent
            anchors.margins: 10
            echoMode: TextInput.Password
            font.pixelSize: 22
            font.family: "JetBrainsMono Nerd Font"
            color: "#C8C8C8"
            placeholderText: "Enter Pass"
            focus: true

            Keys.onReturnPressed: {
                sddm.login(sddm.user, passwordField.text)
            }
        }
    }

    // -------------------------------
    // LOGIN BUTTON (INVISIBLE, PRESS ENTER)
    // -------------------------------
}
