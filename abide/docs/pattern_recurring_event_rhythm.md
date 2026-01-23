# Recurring Event Rhythm

**Context**
In any system that models human life—whether it be finance, habit tracking, or social calendaring—there is a need to project the future. We are not merely existing in the present; we are constantly anticipating regularly occurring events: paychecks, rent, birthdays, and quarterly reviews. These events do not float in a vacuum but are anchored to the irregular, historically constructed scaffolding of the Gregorian calendar.

...

**Problem**
**Computer systems naturally model time as a linear, continuous stream (delta-t), but human time is cyclic, irregular, and culturally determined. Mapping the rigid mathematical certainty of a CPU's clock to the messy, "business day" reality of human schedules creates a brittle impedance mismatch.**

Ideally, we want to simply say, "This happens every month on the 3rd." But the calendar fights us. What if the 3rd is a Sunday? What if the month is February and has only 28 days? What if we want the "last Friday" of a month?

If we model these rules using simple intervals (`Time.now + 30.days`), the schedule drifts. If we use rigid cron expressions, we lose the semantic richness and the ability to easily query "Is this *that* kind of event?" We are torn between the precision of timestamps and the vagueness of "next month."

Crucially, **the logic of *when* something happens must be decoupled from the logic of *what* happens.** If we mix them, we end up with conditional soup scattered across our domain models, making the system opaque and resistant to change.

...

**Solution**
**Reify the schedule into a first-class `Frequency` value object. This object does not represent a specific point in time, but rather the *rule* by which time is divided.**

Therefore:
Create a `Frequency` class that acts as a declarative language for time. It should capture the **Period** (the drumbeat: daily, weekly, monthly), the **Interval** (the tempo: every 2 weeks), and the **Anchors** (the specific notes: on Monday, on the 5th).

This object must be able to answer two fundamental questions without hesitation:
1.  **Predicate**: "Does date X fall on this frequency?"
2.  **Projection**: "Given date X, when is the next occurrence?"

By encapsulating the messiness of the calendar (leap years, varying month lengths) inside this object, the rest of the system can remain pure and linear. The `Frequency` acts as a translation layer between the irregular human world and the linear machine world.

```ruby
# The elegance of the solution lies in its declarativeness
payday = Frequency.monthly(on: 15)
meeting = Frequency.weekly(on: :tuesday)
quarterly_review = Frequency.quarterly(on: 1, months: [:jan, :apr, :jul, :oct])
```

The `Frequency` object becomes a stable center in the code, a place where the difficult negotiations with the calendar are settled once and for all.
