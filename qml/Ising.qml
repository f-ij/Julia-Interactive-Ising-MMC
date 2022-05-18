// import QtQuick 2.1
// import QtQuick.Controls 1.0
// import QtQuick.Layouts 1.0
// import org.julialang 1.0
// import Qt.labs.platform 1.1

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.julialang
import Qt.labs.platform
import QtQuick.Window


ApplicationWindow {
  title: "Ising Simulation"
  width: 800
  height: 800
  visible: true

  // Main Layout
  //                  || SIM BUTTONS    ||
  // BRUSH BUTTONS    || SCREEN         || TEMPERATURE
  //                  || MAGNETIZATION  ||
  RowLayout{
    anchors.centerIn: parent
    spacing: 32
    // Brush Buttons and radius slider
    RowLayout{

      ColumnLayout{
        Text{
          Layout.alignment: Qt.AlignHCenter
          text: "Type"
        }
        Layout.alignment: Qt.AlignCenter

        Button{
          id: brushButton
          text: "1"
          onClicked: {
            obs.brush = 1
          }
        }
        Button{
          Layout.preferredWidth: brushButton.width
          text: "0"
          onClicked: {
            obs.brush = 0
          }
        }
        Button{
          Layout.preferredWidth: brushButton.width
          text: "-1"
          onClicked: {
            obs.brush = -1
          }
        }

      }
      // Radius Slider
      ColumnLayout{
        Text{
          text: "Radius \n" + obs.brushR
        }
        Slider{
          value: obs.brushR
          orientation: Qt.Vertical
          // minimumValue: 1
          // maximumValue: 100
          from: 1
          to: 100
          stepSize: 1
          onValueChanged: {
            obs.brushR = value
          }
        }
      }
    }

    // Central Column
    // Sim buttons
    // Screen
    // Buttons/text under screen
    ColumnLayout{
      Layout.alignment: Qt.AlignCenter

      spacing: 32
      // Buttons at top of window
      Item{
        Layout.alignment: Qt.AlignHCenter
        width: childrenRect.width
        height: childrenRect.height

        ColumnLayout{
          spacing: 2
          // Init Graph Button
          Button {
            Layout.alignment: Qt.AlignCenter
            text: "Initialize Graph"
            onClicked: Julia.initIsing()
          }
          // Pause Simulation Button
          Button{
            Layout.alignment: Qt.AlignCenter
            text: {
              if(obs.isPaused)
              {
                "Paused"
              }
              else{
                "Running"
              }
            }
            onClicked: {
              obs.isPaused = !obs.isPaused
            }
          }
        }
      }

      // Screen
      JuliaCanvas{
        Layout.alignment: Qt.AlignCenter
        id: canvas
        width: 512
        height: 512
        paintFunction: showlatest

        MouseArea{
          anchors.fill: parent
          onClicked: {
            Julia.circleToStateQML(mouseY, mouseX)
          }
        }

      }

      // Panels under plot
      // Magnetization
      // Inserting Defects
      ColumnLayout{
        width: canvas.width
        Layout.alignment: Qt.AlignHCenter
        spacing: 8

        // Magnetization Text
        Rectangle{
          Layout.alignment: Qt.AlignHCenter

          width: canvas.width/2
          height: childrenRect.height
          color: "transparent"

          ColumnLayout{
            spacing: 2
            anchors.centerIn: parent

            Text{
              Layout.alignment: Qt.AlignHCenter
              text: "Magnetization: "
            }
            Text{
              Layout.alignment: Qt.AlignHCenter
              text: obs.M.toFixed(1)
            }
          }
        }




        // Defects textfield & Button
        Item{
          Layout.alignment: Qt.AlignCenter

          width: childrenRect.width
          height: childrenRect.height

          ColumnLayout{
            spacing: 2
            Layout.alignment: Qt.AlignHCenter

            TextField{
              Layout.alignment: Qt.AlignHCenter
              text: obs.pDefects
              onTextChanged: {
                obs.pDefects = parseInt(text)
                if(obs.pDefects > 100)
                {
                  obs.pDefects = 100
                }
                if(obs.pDefects < 0)
                {
                  obs.pDefects = 0
                }
                Julia.println(obs.pDefects)
              }
            }

            Button{
              Layout.alignment: Qt.AlignHCenter
              text: "Insert Defects"
              onClicked: {
                Julia.addRandomDefectsQML()
              }
            }
          }
        }

        // Initiate Temperature sweep
        Item{
          Layout.alignment: Qt.AlignCenter
          width: childrenRect.width
          height: childrenRect.height

          Button{
            Layout.alignment: Qt.AlignCenter
            text: "T Sweep"
            onClicked: {
              Julia.tempSweepQML()
            }
          }

        }


      }

    }

    //  Temperature Slider
    Item{
      Layout.alignment: Qt.AlignCenter
      width: childrenRect.width
      height: childrenRect.height
      RowLayout{
        spacing: 2
        // Temp Slider
        Slider{
          value: obs.TIs
          orientation: Qt.Vertical
          // minimumValue: 0.0
          // maximumValue: 20
          from: 0.0
          to: 20.
          stepSize: 0.01
          onValueChanged: {
            obs.TIs = value
          }
        }
        // Temperature text
        Item{
          width: 32
          Text{
            Layout.alignment: Qt.AlignCenter
            text: qsTr("T=\n") + obs.TIs.toFixed(2)
          }
        }
      }
    }
  }


  // Timer for display
  Timer {
    // Set interval in ms:
    interval: 1/60*1000; running: true; repeat: true
    onTriggered: {
      canvas.update();
    }
  }
}
