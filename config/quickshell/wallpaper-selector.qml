import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ShellRoot {
    id: root
    
    property string currentRice: ""
    property string wallDir: ""
    property string cacheDir: ""
    property var wallpapers: []
    property string currentWallpaper: ""
    
    Component.onCompleted: {
        // Read current rice
        var rice = Quickshell.readFile(Quickshell.env("HOME") + "/.config/dots/.rice").trim()
        currentRice = rice
        wallDir = Quickshell.env("HOME") + "/.config/dots/rices/" + rice + "/walls"
        cacheDir = Quickshell.env("HOME") + "/.cache/" + Quickshell.env("USER") + "/" + rice
        
        // Read current wallpaper
        var wallPath = Quickshell.readFile(Quickshell.env("HOME") + "/.config/dots/rices/.wall").trim()
        currentWallpaper = wallPath.split('/').pop()
        
        // Load wallpapers
        loadWallpapers()
    }
    
    function loadWallpapers() {
        var process = new Process()
        process.command = ["bash", "-c", `find "${wallDir}" -type f \\( -name "*.jpg" -o -name "*.png" -o -name "*.webp" \\) -exec basename {} \\;`]
        process.running = true
        process.onFinished.connect(() => {
            wallpapers = process.stdout.trim().split('\n').filter(w => w.length > 0)
            selector.model = wallpapers
        })
    }
    
    // function setWallpaper(wallName) {
    //     var fullPath = wallDir + "/" + wallName
    //     Quickshell.writeFile(Quickshell.env("HOME") + "/.config/dots/rices/.wall", fullPath)
    //
    //     // Run WallColor script
    //     var process = new Process()
    //     process.command = ["WallColor"]
    //     process.running = true
    //
    //     Qt.quit()
    // }

    PanelWindow {
        id: window
        anchors {
            top: true
            // horizontalCenter: true
        }
        margins {
            top: 200
        }
        width: 1200
        height: 400
        color: "#ee1e1e2e"
        
        Rectangle {
            anchors.fill: parent
            color: "#1e1e2e"
            radius: 20
            
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 15
                
                Text {
                    text: "Select Wallpaper"
                    font.pixelSize: 24
                    font.bold: true
                    color: "#cdd6f4"
                    Layout.alignment: Qt.AlignHCenter
                }
                
                GridView {
                    id: selector
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    cellWidth: 180
                    cellHeight: 180
                    clip: true
                    
                    delegate: Item {
                        width: 170
                        height: 170
                        
                        Rectangle {
                            anchors.fill: parent
                            anchors.margins: 5
                            color: modelData === currentWallpaper ? "#89b4fa" : "#313244"
                            radius: 15
                            border.width: modelData === currentWallpaper ? 3 : 0
                            border.color: "#89dceb"
                            
                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 5
                                
                                Image {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    source: "file://" + cacheDir + "/" + modelData
                                    fillMode: Image.PreserveAspectCrop
                                    smooth: true
                                    asynchronous: true
                                    cache: false
                                    
                                    Rectangle {
                                        anchors.fill: parent
                                        color: "transparent"
                                        radius: 10
                                        border.width: 1
                                        border.color: "#45475a"
                                    }
                                }
                                
                                Text {
                                    text: modelData.replace(/\.(jpg|png|webp)$/, '')
                                    font.pixelSize: 12
                                    color: "#cdd6f4"
                                    Layout.alignment: Qt.AlignHCenter
                                    elide: Text.ElideMiddle
                                    Layout.maximumWidth: parent.width - 10
                                    horizontalAlignment: Text.AlignHCenter
                                }
                            }
                            
                            MouseArea {
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                
                                onEntered: parent.color = modelData === currentWallpaper ? "#89b4fa" : "#45475a"
                                onExited: parent.color = modelData === currentWallpaper ? "#89b4fa" : "#313244"
                                // onClicked: setWallpaper(modelData)
                            }
                        }
                    }
                }
                
                Button {
                    text: "Cancel"
                    Layout.alignment: Qt.AlignHCenter
                    onClicked: Qt.quit()
                    
                    background: Rectangle {
                        color: parent.hovered ? "#45475a" : "#313244"
                        radius: 8
                    }
                    
                    contentItem: Text {
                        text: parent.text
                        color: "#cdd6f4"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }
        }
    }
}
