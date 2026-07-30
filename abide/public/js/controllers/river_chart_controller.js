import { Controller } from "@hotwired/stimulus"

// connect() is async, so anything that throws in here becomes an unhandled
// rejection that Stimulus swallows: the chart simply never appears and the
// console says nothing. Every failure below is caught and shown in the space
// the chart would have occupied, so a blank chart can always be explained.
export default class extends Controller {
    static targets = ["canvas"]

    async connect() {
        try {
            if (typeof Chart === "undefined") {
                throw new Error("Chart.js did not load — check /js/vendor/chart.umd.js")
            }

            const data = await this.fetchData()
            if (!Array.isArray(data) || data.length === 0) {
                throw new Error(`/api/projection returned no points (${JSON.stringify(data).slice(0, 80)})`)
            }

            this.draw(data)
        } catch (error) {
            this.explain(error)
        }
    }

    disconnect() {
        this.chart?.destroy()
        this.chart = null
    }

    async fetchData() {
        const response = await fetch("/api/projection")
        if (!response.ok) {
            throw new Error(`/api/projection responded ${response.status}`)
        }
        return response.json()
    }

    // Says what went wrong where the chart should be, rather than leaving a
    // blank rectangle and no explanation.
    explain(error) {
        console.error("river-chart:", error)
        this.canvasTarget.hidden = true

        const note = document.createElement("p")
        note.className = "sp-text-sm sp-text-muted"
        note.dataset.riverChartError = "true"
        note.textContent = `The projection chart could not be drawn: ${error.message}`
        this.element.appendChild(note)
    }

    draw(data) {
        const ctx = this.canvasTarget.getContext("2d")

        const gradientFill = ctx.createLinearGradient(0, 0, 0, 400)
        gradientFill.addColorStop(0, "rgba(47, 133, 90, 0.4)") // Sage Green
        gradientFill.addColorStop(1, "rgba(255, 255, 255, 0)")

        this.chart = new Chart(ctx, {
            type: "line",
            data: {
                labels: data.map(d => d.label),
                datasets: [{
                    label: "Projected Balance",
                    data: data.map(d => d.balance),
                    borderColor: "#2F855A",
                    backgroundColor: gradientFill,
                    borderWidth: 2,
                    pointRadius: 0,
                    pointHoverRadius: 6,
                    fill: true,
                    tension: 0.4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { display: false },
                    tooltip: {
                        backgroundColor: "white",
                        titleColor: "#2D3748",
                        bodyColor: "#2D3748",
                        borderColor: "#E2E8F0",
                        borderWidth: 1,
                        padding: 12,
                        displayColors: false,
                        callbacks: {
                            label: (context) => "$" + context.parsed.y.toLocaleString()
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { font: { family: "Inter" } }
                    },
                    y: {
                        grid: { borderDash: [4, 4], color: "#EDF2F7" },
                        ticks: {
                            font: { family: "Inter" },
                            callback: (value) => "$" + value / 1000 + "k"
                        }
                    }
                }
            }
        })
    }
}
