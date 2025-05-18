import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["canvas"]

    connect() {
        console.log("Quadrant chart controller connected")
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
            console.log("Initializing quadrant chart...")
            const ctx = this.canvasTarget.getContext('2d')

            // Get data from data attribute
            let points;
            try {
                points = JSON.parse(this.canvasTarget.dataset.points || '[]');
                console.log("Points data:", points);
            } catch (error) {
                console.error("Error parsing points data:", error);
                points = []; // Empty array if parsing fails
            }

            // Convert points to dataset format
            const datasets = [{
                label: 'Data Points',
                data: points,
                backgroundColor: 'rgba(54, 162, 235, 0.8)',
                pointRadius: 8,
                pointHoverRadius: 10
            }];

            // Create a plugin to draw crosshairs at x=0 and y=0
            const crosshairPlugin = {
                id: 'crosshair',
                beforeDraw: (chart) => {
                    const ctx = chart.ctx;
                    const xAxis = chart.scales.x;
                    const yAxis = chart.scales.y;

                    // Get the zero positions
                    const xZero = xAxis.getPixelForValue(0);
                    const yZero = yAxis.getPixelForValue(0);

                    // Set styles for axes
                    ctx.save();
                    ctx.lineWidth = 2;
                    ctx.strokeStyle = '#666';

                    // Draw x-axis line
                    ctx.beginPath();
                    ctx.moveTo(xAxis.left, yZero);
                    ctx.lineTo(xAxis.right, yZero);
                    ctx.stroke();

                    // Draw y-axis line
                    ctx.beginPath();
                    ctx.moveTo(xZero, yAxis.top);
                    ctx.lineTo(xZero, yAxis.bottom);
                    ctx.stroke();

                    // Add quadrant labels
                    ctx.font = '16px Arial';
                    ctx.fillStyle = '#333';
                    ctx.textAlign = 'center';

                    // Q1 - top right
                    ctx.fillText('Joy/Excitement', (xAxis.right + xZero) / 2, (yAxis.top + yZero) / 2);

                    // Q2 - top left
                    ctx.fillText('Anger/Fear', (xAxis.left + xZero) / 2, (yAxis.top + yZero) / 2);

                    // Q3 - bottom left
                    ctx.fillText('Sadness/Depression', (xAxis.left + xZero) / 2, (yAxis.bottom + yZero) / 2);

                    // Q4 - bottom right
                    ctx.fillText('Peace/Relaxation', (xAxis.right + xZero) / 2, (yAxis.bottom + yZero) / 2);

                    ctx.restore();
                }
            };

            // Create the chart
            this.chart = new window.Chart(ctx, {
                type: 'scatter',
                plugins: [crosshairPlugin],
                data: {
                    datasets: datasets
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    aspectRatio: 1,  // Make it square
                    scales: {
                        x: {
                            min: -10,
                            max: 10,
                            title: {
                                display: true,
                                text: 'Walencja (Nieprzyjemne → Przyjemne)'
                            }
                        },

                        y: {
                            min: -10,
                            max: 10,
                            title: {
                                display: true,
                                text: 'Pobudzenie (Spokojne → Energiczne)'
                            }
                        }
                    },
                    plugins: {
                        tooltip: {
                            callbacks: {
                                label: function(context) {
                                    const point = context.raw;
                                    return `${point.label}: (${point.x}, ${point.y})`;
                                }
                            }
                        },
                        title: {
                            display: true,
                            text: 'Quadrant Chart',
                            font: {
                                size: 18
                            }
                        },
                        legend: {
                            display: false  // Hide the legend
                        }
                    }
                }
            });

            console.log("Quadrant chart created successfully");
        } catch (error) {
            console.error("Error creating quadrant chart:", error);
        }
    }

    disconnect() {
        if (this.chart) {
            this.chart.destroy();
        }
    }
}