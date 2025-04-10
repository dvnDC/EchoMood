import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["canvas"]

    connect() {
        console.log("Chart controller connected")
        this.loadChartJs().then(() => {
            if (this.hasCanvasTarget) {
                this.initializeChart()
            }
        })
    }

    loadChartJs() {
        return new Promise((resolve) => {
            if (window.Chart) {
                resolve()
                return
            }

            import("chart.js").then(() => {
                console.log("Chart.js loaded successfully")
                resolve()
            }).catch(error => {
                console.error("Failed to load Chart.js:", error)
            })
        })
    }

    initializeChart() {
        try {
            console.log("Initializing chart...")
            const ctx = this.canvasTarget.getContext('2d')

            // Get data from data attributes
            let labels, datasets
            try {
                labels = JSON.parse(this.canvasTarget.dataset.labels || '[]')
                datasets = JSON.parse(this.canvasTarget.dataset.datasets || '[]')
                console.log("Chart data:", { labels, datasets })
            } catch (error) {
                console.error("Error parsing chart data:", error)
                labels = ['Jan', 'Feb', 'Mar']
                datasets = [{
                    label: 'Test Data',
                    data: [3, 4, 2],
                    borderColor: '#3e95cd',
                    backgroundColor: 'rgba(62, 149, 205, 0.2)',
                    fill: true
                }]
            }

            // Create the chart using the global Chart object
            this.chart = new window.Chart(ctx, {
                type: this.canvasTarget.dataset.type || 'line',
                data: {
                    labels: labels,
                    datasets: datasets
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    scales: {
                        y: {
                            min: 1,
                            max: 5,
                            ticks: {
                                stepSize: 1
                            },
                            title: {
                                display: true,
                                text: 'Mood Level'
                            }
                        }
                    }
                }
            })
            console.log("Chart created successfully")
        } catch (error) {
            console.error("Error creating chart:", error)
        }
    }

    disconnect() {
        if (this.chart) {
            this.chart.destroy()
        }
    }
}