import os
from . AWS import AWS

class Graph:
    def sizeToScale(self, name):
        sizes = []
        sizes.append({"name":"t2.nano","scale":1})
        sizes.append({"name":"t2.micro","scale":2})
        sizes.append({"name":"t2.small","scale":3})
        sizes.append({"name":"t2.medium","scale":4})
        sizes.append({"name":"t2.large","scale":6})
        sizes.append({"name":"t2.xlarge","scale":8})
        sizes.append({"name":"t2.2xlarge","scale":10})

        retscale = 1
        for s in sizes:
            if s["name"] == name:
                retscale = s["scale"]
        return retscale

    def buildChart(self, path, reservation):
        f = open(path,"w")
        ct = 0
        html = """<html><head><script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">
      google.charts.load('current', {'packages':['corechart']});
      google.charts.setOnLoadCallback(drawSeriesChart);

    function drawSeriesChart() {
      var options = {title: 'Your deployed instances'};
      var data = google.visualization.arrayToDataTable([
        ["ID","X","Y","Blueprint","Size"]"""

        for r in reservation:
            for i in r["Instances"]:
                ct = ct + 1
                did=""
                name=""
                expire=""
                bpn=""
                pubdns=""
                pubip=""
                privip=""
                size = str(self.sizeToScale(i["InstanceType"]))
                for tag in i["Tags"]:
                    if tag["Key"] == "use-group":
                        did=tag["Value"]
                    if tag["Key"] == "blueprint-name":
                        bpn=tag["Value"]
                    if tag["Key"] == "Name":
                        name=tag["Value"]
                    if tag["Key"] == "expire-on":
                        expire=tag["Value"]
                html = html +",['"+name+"',"+str(ct*10)+","+str(5)+",'"+bpn+"',"+size+"]"

        html = html + """]);
        var chart = new google.visualization.BubbleChart(document.getElementById('series_chart_div'));
      chart.draw(data, options);
    }
    </script>
  </head>
  <body>
    <div id="series_chart_div" style="width: 1000px; height: 600px;"></div>
  </body>
</html>"""
        f.write(html)