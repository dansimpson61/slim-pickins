import { Controller } from "https://unpkg.com/@hotwired/stimulus/dist/stimulus.js"

export default class extends Controller {
    static targets = ["createForm", "assignForm", "createInput", "assignSelect", "accountCheckboxes"]

    async create(event) {
        event.preventDefault()

        const name = this.createInputTarget.value
        if (!name) return

        try {
            const response = await fetch('/portfolios', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ name: name })
            })

            const result = await response.json()
            if (result.status === 'success') {
                window.location.reload()
            } else {
                alert("Error creating portfolio")
            }
        } catch (e) {
            console.error(e)
        }
    }

    toggleAssign(event) {
        // Show/Hide assignment section for a specific portfolio?
        // For MVP, we might simple reload the page with ?manage_id=X or just use a modal.
        // Let's go with a simple expansion or selection.
    }

    async addAccount(event) {
        const portfolioId = event.target.dataset.portfolioId
        const accountId = event.target.value
        const isChecked = event.target.checked

        // We only support ADDING via API currently? 
        // ledger.add_account_to_portfolio is INSERT OR IGNORE.
        // Removing accounts isn't in the API yet.
        // For now, let's just support Adding.

        if (isChecked) {
            try {
                await fetch(`/portfolios/${portfolioId}/accounts`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: `account_id=${accountId}`
                })
                // No need to reload if we assume success, UI matches state
            } catch (e) {
                console.error(e)
                event.preventDefault() // Revert check
            }
        } else {
            alert("Removing accounts not yet supported in this UI.")
            event.preventDefault()
        }
    }
}
