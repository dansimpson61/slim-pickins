import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["canvas"]

    async connect() {
        const ctx = this.canvasTarget.getContext('2d')
        const data = await this.fetchData()

        // Gradients
        const gradientFill = ctx.createLinearGradient(0, 0, 0, 400);
        gradientFill.addColorStop(0, 'rgba(47, 133, 90, 0.4)'); // Sage Green
        gradientFill.addColorStop(1, 'rgba(255, 255, 255, 0)');

        new Chart(ctx, {
            type: 'line',
            data: {
                labels: data.map(d => d.label),
                datasets: [{
                    label: 'Projected Balance',
                    data: data.map(d => d.balance),
                    borderColor: '#2F855A',
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
                        backgroundColor: 'white',
                        titleColor: '#2D3748',
                        bodyColor: '#2D3748',
                        borderColor: '#E2E8F0',
                        borderWidth: 1,
                        padding: 12,
                        displayColors: false,
                        callbacks: {
                            label: (context) => {
                                return '$' + context.parsed.y.toLocaleString();
                            }
                        }
                    }
                },
                scales: {
                    x: {
                        grid: { display: false },
                        ticks: { font: { family: 'Inter' } }
                    },
                    y: {
                        grid: { borderDash: [4, 4], color: '#EDF2F7' },
                        ticks: {
                            font: { family: 'Inter' },
                            callback: function (value) { return '$' + value / 1000 + 'k'; }
                        }
                    }
                }
            }
        });
    }

    async fetchData() {
        const response = await fetch('/api/projection')
        return await response.json()
    }
}
