import QtQuick
import QtQuick.Controls
import QtCharts
import QtQuick.Layouts
import '../../my_components'

Rectangle{
    id: main_flow_page
    gradient: Gradient{
        GradientStop{position: 0.0; color: '#5cdb95'}
        GradientStop{position: 0.7; color: '#379683'}
    }

    Title_bar{
        id: titleBar
    }

    // from MainDrawer.qml
    MainDrawer {
        id: drawer
        z: 1
    }

    FontLoader {
        id: montserrat
        source: '../../fonts/Montserrat-Medium.ttf'
    }

    ColumnLayout {
        x: (main_flow_page.width - drawer.drawerWidthIfNotDrawn - width) / 2 + drawer.drawerWidthIfNotDrawn
        anchors.verticalCenter: parent.verticalCenter
        spacing: 20

        Text {
            text: "Your screen time past week"
            Layout.alignment: Qt.AlignHCenter
            color: '#1B1212'
            font {
                family: montserrat.font.family
                pixelSize: Math.min(window.width / 25, window.height / 25)
            }
        }

        Rectangle {
            id: chartHolder
            implicitWidth: main_flow_page.width * 0.75
            implicitHeight: main_flow_page.height * 0.65

            antialiasing: true

            color: '#f9efc9'
            border.color: '#36454F'
            border.width: 2
            radius: 20

            ChartView {
                id: chartView
                anchors.fill: parent
                legend.visible: false
                antialiasing: false
                backgroundColor: 'transparent'

                function toolTipText(value) {
                    let hours = Math.floor(value);
                    let minutes = Math.floor((value - hours) * 60);
                    if (hours === 1) {
                        if (minutes > 1) {
                            return `You spent: \n${hours} hour \n${minutes} minutes`
                        } else if (minutes === 1) {
                            return `You spent: \n${hours} hour \n${minutes} minute`
                        } else {
                            return `You spent: \n${hours} hour`
                        }
                    } else if (hours > 1) {
                        if (minutes > 1) {
                            return `You spent: \n${hours} hours \n${minutes} minutes`
                        } else if (minutes === 1) {
                            return `You spent: \n${hours} hours \n${minutes} minute`
                        } else {
                            return `You spent: \n${hours} hours`
                        }
                    } else {
                        if (minutes > 1) {
                            return `You spent: \n${minutes} minutes`
                        } else if (minutes === 1) {
                            return `You spent: \n${minutes} minute`
                        }
                    }
                }


                BarSeries {
                    id: mySeries

                    axisX: BarCategoryAxis {
                        categories: chart.categories
                        gridLineColor: '#36454F'
                        // gridVisible: false
                        color: 'black'
                    }
                    axisY: ValueAxis {
                        gridLineColor: '#36454F'
                        color: 'black'
                        tickCount: 2
                        min: 0
                        max: 24
                    }
                    BarSet { label: "Bob"; values: chart.values; color: '#5cdb95'}

                    onHovered: {
                        var category = mySeries.axisX.categories[index]
                        var value = barset.values[index]

                        // coordinates_area.z = status === true ? 10 : 0

                        toolTip.visible = status;
                        toolTip.text = chartView.toolTipText(value);
                        var p = chartView.mapToPosition(Qt.point(index, value), mySeries);
                        toolTip.x = p.x - (chartView.plotArea.width / mySeries.axisX.categories.length * mySeries.barWidth);
                        toolTip.y = p.y - toolTip.height - 5;
                    }
                }
            }
            ToolTip {
                id: toolTip
                width: (chartView.plotArea.width / mySeries.axisX.categories.length)

                font.pixelSize: chartView.plotArea.width / 50

                background: Rectangle {
                    border.width: 1
                    border.color: '#36454F'
                    radius: toolTip.width / 10
                }
            }

        }
    }

}