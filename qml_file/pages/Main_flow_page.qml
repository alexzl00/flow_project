import QtQuick
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts
import '../../my_components'

Rectangle{
    id: main_flow_page
    anchors.fill: parent
    implicitWidth: parent
    implicitHeight: parent
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    Title_bar{
        id: titleBar
    }


    Rectangle {
        implicitWidth: parent.width * 0.7
        implicitHeight: parent.height * 0.7
        anchors.centerIn: parent
        color: 'transparent'

        ChartView {
            anchors.fill: parent
            legend.visible: false
            antialiasing: true
            backgroundColor: 'transparent'
            title: "Your screen time past week"
            titleFont.family: Arial
            titleFont.pointSize: 24
            titleColor: 'black'


            BarSeries {
                id: mySeries

                axisX: BarCategoryAxis {
                    categories: chart.categories
                    // gridLineColor: 'transparent'
                    // gridVisible: false
                }
                axisY: ValueAxis {
                    tickCount: 2
                    min: 0
                    max: 24
                }
                BarSet { label: "Bob"; values: chart.values; color: '#ECFFDC'}
            }
        }

    }

    // from MainDrawer.qml
    MainDrawer {
        id: drawer
    }

}