import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes


Shape {
    id: advancedShape
    implicitWidth: 0; implicitHeight: 0
    layer.enabled: true
    layer.samples: 4
    layer.smooth: true
    antialiasing: true

    property real shape_width: 0.0
    property real shape_height: 0.0

    // set following properties to specify radius
    property real tlRadius: advancedShape.height / 2
    property real trRadius: 15.0
    property real brRadius: 0.0
    property real blRadius: advancedShape.height / 2

    property string fill_color: 'red'

    ShapePath {
        id: shape_path
        strokeColor: "transparent"
        fillColor: fill_color

        startX: 0; startY: advancedShape.tlRadius
        PathArc {
            x: advancedShape.tlRadius; y: 0
            radiusX: advancedShape.tlRadius; radiusY: advancedShape.tlRadius
            useLargeArc: false
        }
        PathLine {
            x: advancedShape.width - advancedShape.trRadius; y: 0
        }
        PathArc {
            x: advancedShape.width; y: advancedShape.trRadius
            radiusX: advancedShape.trRadius; radiusY: advancedShape.trRadius
            useLargeArc: false
        }
        PathLine {
            x: advancedShape.width; y: advancedShape.height - advancedShape.brRadius
        }
        PathArc {
            x: advancedShape.width - advancedShape.brRadius; y: advancedShape.height
            radiusX: advancedShape.brRadius; radiusY: advancedShape.brRadius
            useLargeArc: false
        }
        PathLine {
            x: advancedShape.blRadius; y: advancedShape.height
        }
        PathArc {
            x: 0; y: advancedShape.height - advancedShape.blRadius
            radiusX: advancedShape.blRadius; radiusY: advancedShape.blRadius
            useLargeArc: false
        }
        PathLine {
           x: 0; y: advancedShape.tlRadius
        }
    }
}

