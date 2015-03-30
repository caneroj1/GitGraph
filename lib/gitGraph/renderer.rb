require 'erb'

module GitGraph
  class Renderer
    class << self
      def render(graphable_object, label)
        if graphable_object.changed
          graphable_object.stringify

          make_file(graphable_object.chart_string,
                    label,
                    graphable_object.chart_type_to_string,
                    graphable_object.title)

          graphable_object.changed = false
        end
      end

      def make_file(html, id, chart_type, title)
        output =
        <<-HTML
<html style='background-color: whitesmoke;'>
  <body style='font-family:Helvetica Neue; font-weight: 200;'>
    <div class='container'>
      <h1 style='font-family:Helvetica Neue; font-weight: 200; margin-bottom: 0; text-align: center;'>#{title}</h1>
      <canvas id="#{id}" width="700px" height="700px" style='display: inline-block;'></canvas>
    </div>
    <script>
    #{html}
    </script>
    <script src="Chart2.min.js"></script>
    <script src="jquery-1.10.1.min.js"></script>
    <script src="legend.js"></script>
  </body>
  <script>
    var chartContext = document.getElementById("#{id}").getContext("2d");
    var #{id}Chart = new Chart(chartContext).#{chart_type}(data, options);
    legend(document.getElementById('#{id}'), data);
  </script>
</html>
        HTML

        File.open("/Users/joecanero/Desktop/#{id}.html", "w") { |f| f.write(ERB.new(output).result(binding)) }
      end
    end
  end
end
