# encoding: utf-8

class DealsOverview
  class BaseChart
    TEXT_COLOR = "#a0a2a5"
    GRAY_COLOR = "#efeff0"

    def initialize(series)
      @series = series
    end

    def options
      base_options.deep_merge(extra_options)
    end

    private

    def axis_options
      { gridlines: { color: "#fff" }, baselineColor: GRAY_COLOR }.merge(text(10))
    end

    def base_options
      {
        chartArea:      { width: "100%", height: "80%" },
        colors:         [ GRAY_COLOR, "#b7554a" ],
        fontName:       "PT Sans",
        hAxis:          axis_options,
        legend:         { position: "bottom", alignment: "start"}.merge(text(12)),
        titlePosition:  "none",
        vAxis:          axis_options,
      }
    end

    def hidden_axis
      { textPosition: "none" }
    end

    def text(px)
      { textStyle: { color: TEXT_COLOR, fontSize: "#{px}px" } }
    end

    def with_line
      { 1 => { type: "line", pointSize: 6 } }
    end
  end
end
