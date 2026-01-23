# Pattern: Temporal Movements

**Context**
In a financial system, we must handle two distinct types of time: the **Past**, which is immutable and factual, and the **Future**, which is speculative and generative. Users want to see a unified view: "My balance was $X yesterday, is $Y today, and will be $Z next month."

**Problem**
**How do we model standard transactions alongside recurring obligations without confusing what *did* happen with what *might* happen?**

If we store "Rent due next month" in the same database table as "Grocery run yesterday", we risk polluting our historical ledger with phantom data. If we keep them entirely separate, we struggle to generate a continuous balance graph.

Furthermore, how do we handle the "Mutation of the Present"? A planned recurring payment of $100 might actually clear as $102.50 due to fees. The Rule said $100; the Reality was $102.50. We need to gracefully accept this collapse of probability into fact.

**Forces**
*   **Immutability**: The past cannot change. A ledger entry is a fact.
*   **Generativity**: The future is rule-based. "Monthly on the 1st" produces an infinite stream of potential events.
*   **Boundedness**: Recurring events are rarely eternal. A Mortgage lasts 30 years. Social Security starts at 67. Childcare ends at 18.
*   **One-Off Speculation**: Future events aren't always recurring. A "Roof Repair" is a known future liability that happens once.
*   **Morphology**: A potential future movement looks exactly like a past movement (Amount, Date, Description), they just differ in *certainty*.
*   **Reconciliation**: When a predicted event happens, it becomes a ledger entry. The prediction typically vanishes or is "satisfied."

**Solution**
**Adopt a Source-Stream-Sink morphology.**

1.  **The Source (Recurring Rules)**:
    These are the *generators*. They hold a `Frequency` and a template for the movement.
    *   *Class*: `RecurringMovement`
    *   **Lifespan**: Each Rule has an `ActiveWindow` (Start Date, Optional End Date). The Generator only emits events that fall within this window and match the Frequency.
    *   **One-Offs**: A "One-Off" is simply a `RecurringMovement` with a `Frequency` of **Once**.

2.  **The Sink (The Ledger)**:
    This is the repository of *facts*. These are `Movements` that have occurred. They are static.
    *   *Class*: `LedgerEntry` (or just `Movement`)

3.  **The Stream (The Projection)**:
    This is a calculated view. We do not store "Next Month's Rent" in the database. Instead, we *project* it on demand.
    
    `Projection = Ledger + (RecurringRules * Time)`

**Refined Morphology**
We define a shared interface or value object, `CashFlow`, which encapsulates `{ amount, date, description }`.

*   **LedgerEntry** *is a* `CashFlow` that is **realized**.
*   **ProjectedEntry** *is a* `CashFlow` that is **virtual**.

The app's "Balance Sheet" is simply the integration (sum) of the Ledger (0 to Now) + The Projection (Now to T).

**Handling the Link**:
When a `ProjectedEntry` becomes a `LedgerEntry`, we don't "convert" it in place. We record the Fact in the Ledger. The Projection automatically updates because the Rule now generates its *next* occurrence starting *after* the latest Fact.
