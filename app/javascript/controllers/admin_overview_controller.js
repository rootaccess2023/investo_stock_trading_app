import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["lineChart", "barChart", "lineChartTwo", "lineChartThree", "activeTraders", "numberOfTrades", "totalRevenue", "tradeValue"]

    connect() {
        this.activeTradersTarget.addEventListener("click", () => this.showTradersLineChart())
        this.numberOfTradesTarget.addEventListener("click", () => this.showTradesBarChart())
        this.totalRevenueTarget.addEventListener("click", () => this.showRevenueLineChart())
        this.tradeValueTarget.addEventListener("click", () => this.showCombinedLineChart())
    }

    showTradersLineChart() {
        this.toggleChart("lineChart")
    }

    showTradesBarChart() {
        this.toggleChart("barChart")
    }

    showRevenueLineChart() {
        this.toggleChart("lineChartTwo")
    }

    showCombinedLineChart() {
        this.toggleChart("lineChartThree")
    }

    toggleChart(chartName) {
        this.lineChartTargets.forEach(chart => {
            chart.style.display = (chart.getAttribute("data-admin-overview-target") === chartName) ? "block" : "none"
        })
        this.barChartTargets.forEach(chart => {
            chart.style.display = (chart.getAttribute("data-admin-overview-target") === chartName) ? "block" : "none"
        })
        this.lineChartTwoTargets.forEach(chart => {
            chart.style.display = (chart.getAttribute("data-admin-overview-target") === chartName) ? "block" : "none"
        })
        this.lineChartThreeTargets.forEach(chart => {
            chart.style.display = (chart.getAttribute("data-admin-overview-target") === chartName) ? "block" : "none"
        })
    }
}
