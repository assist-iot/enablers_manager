<template>
	<div class="hello" ref="chartdiv">
	</div>
</template>
<script>

import * as am4core from "@amcharts/amcharts4/core";
import * as am4charts from "@amcharts/amcharts4/charts";
import am4themes_animated from "@amcharts/amcharts4/themes/animated";

am4core.useTheme(am4themes_animated);

export default {
	name: 'HistogramFigure',
	props: ['iseHistogram','xLabel'],
	data: () => ({
		chartData: [],
		label: "NOx_mg_km_isc"
	}),

	watch: {
		iseHistogram: function (newData) {
			// Watch for changes in iseEmissions prop and update the chartData
			if (this.chart) {
				this.chart.data = newData;
			}
		},
		xLabel: function (newData) {
			// Watch for changes in iseEmissions prop and update the chartData
			this.label = newData;
		}
	},

	mounted() {
		let chart = am4core.create(this.$refs.chartdiv, am4charts.XYChart);
		chart.paddingRight = 20;
		//		let maxCols = 10;
		//		let histogramData = this.getHistogramData(this.iseEmissions, maxCols);
		//		chart.data = histogramData[0];
		//		chart.data = this.$store.state.pilot3a.histogram;
		chart.data = this.chartData;

		// Create axes
		let categoryAxis = chart.xAxes.push(new am4charts.CategoryAxis());
		categoryAxis.dataFields.category = "from";
		categoryAxis.title.text = this.label;
		categoryAxis.title.fontWeight = "bold";
		categoryAxis.renderer.grid.template.location = 0;
		categoryAxis.renderer.minGridDistance = 30;

		let valueAxis = chart.yAxes.push(new am4charts.ValueAxis());
		valueAxis.title.text = "OBM entries";
		valueAxis.title.fontWeight = "bold";

		// Create series
		var series = chart.series.push(new am4charts.ColumnSeries());
		series.dataFields.valueY = "count";
		series.dataFields.categoryX = "from";
		series.columns.template.tooltipText = "[bold]Cars: {count}[/]";
		series.columns.template.fillOpacity = .8;

		var columnTemplate = series.columns.template;
		columnTemplate.strokeWidth = 2;
		columnTemplate.strokeOpacity = 1;
		columnTemplate.stroke = am4core.color("#FFFFFF");

		columnTemplate.adapter.add("fill", function (fill, target) {
			return chart.colors.getIndex(target.dataItem.index);
		})

		columnTemplate.adapter.add("stroke", function (stroke, target) {
			return chart.colors.getIndex(target.dataItem.index);
		})

		this.chart = chart;
	},


	beforeDestroy() {
		if (this.chart) {
			this.chart.dispose();
		}
	},

	methods: {
		getHistogramData: function (source, maxCols) { //Unneeded
			// Init
			var data = [];
			var min = Math.min.apply(null, source);
			var max = Math.max.apply(null, source);
			var range = max - min;
			var step = range / maxCols;

			// Create items
			for (let i = 0; i < maxCols; i++) {
				var from = min + i * step;
				var to = min + (i + 1) * step;
				data.push({
					from: from,
					to: to,
					count: 0
				});
			}

			// Calculate range of the values
			for (let i = 0; i < source.length; i++) {
				var value = source[i];
				var item = data.find(function (el) {
					return (value >= el.from) && (value <= el.to);
				});
				item.count++;
			}

			return [data];
		}
	}
}

</script>

<style scoped>
.hello {
	width: 100%;
	height: 250px;
}
</style>
