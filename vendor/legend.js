function legend(parent, data) {
    parent.className = 'legend';
    var datas = data.hasOwnProperty('datasets') ? data.datasets : data;

    // remove possible children of the parent
    while(parent.hasChildNodes()) {
        parent.removeChild(parent.lastChild);
    }

    $(parent).after("<div id='legend' style='display:inline-block; vertical-align: top; margin-left:20px;' class='legend-container'><h2 style='font-weight: 200; margin-bottom: 0;'>Legend</h2><hr/></div>");

    datas.forEach(function(d) {
        var title = document.createElement('div');
        title.className = 'title';
        parent.insertBefore(title);

        var colorSample = document.createElement('div');
        colorSample.className = 'color-sample';
        colorSample.style.backgroundColor = d.hasOwnProperty('strokeColor') ? d.strokeColor : d.color;
        colorSample.style.width = '20px';
        colorSample.style.display = 'inline-block';
        colorSample.style.marginRight = '5px';
        colorSample.style.height = '20px';
        colorSample.style.borderColor = d.hasOwnProperty('fillColor') ? d.fillColor : d.color;
        title.appendChild(colorSample);

        var text = document.createTextNode(d.label);
        title.appendChild(text);
        $("#legend").append(title);
    });
}
