require 'erb'

module GitGraph
  class Renderer
    class << self
      def render(graphable_object, label)
        if graphable_object.changed
          graphable_object.stringify
          make_file(graphable_object.chart_string,
                    label,
                    graphable_object.chart_type_to_string)
          graphable_object.changed = false
        end
      end

      def make_file(html, id, chart_type)
        output =
        <<-HTML
<canvas id="#{id}" width="800" height="800"></canvas>
<script src="Chart.js"></script>
<script>
#{html}
var ctx = document.getElementById("#{id}").getContext("2d");
var myNewChart = new Chart(ctx).#{chart_type}(data);
</script>
        HTML

        File.open("/Users/joecanero/Desktop/#{id}.html", "w") { |f| f.write(ERB.new(output).result(binding)) }
      end
    end
  end
end
