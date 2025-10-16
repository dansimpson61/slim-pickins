# Slim Syntax Guide for Slim-Pickins

## Passing Hashes to Helpers

### ❌ Wrong (causes parser error)
```slim
== results_table({
  "Final Amount": @calc.final_amount,
  "Interest Earned": @calc.interest
})
```

### ✅ Right (multi-line Ruby)
```slim
- data = { \
    "Final Amount": @calc.final_amount, \
    "Interest Earned": @calc.interest \
  }
== results_table(data)
```

### ✅ Right (inline - works for short hashes)
```slim
== results_table({"Final Amount": @calc.final_amount, "Interest": @calc.interest})
```

### ✅ Right (build table manually)
```slim
table.results-table
  tbody
    tr
      td Final Amount
      td.numeric = "$%.2f" % @calc.final_amount
    tr
      td Interest Earned
      td.numeric = "$%.2f" % @calc.interest
```

## Helper Patterns

### Pattern 1: Multi-line hash (most readable)
```slim
- data = { \
    "Label 1": value1, \
    "Label 2": value2 \
  }
== helper_method(data)
```

### Pattern 2: Inline (for simple cases)
```slim
== helper_method({key: value})
```

### Pattern 3: Direct HTML (full control)
```slim
table
  tbody
    == result_row("Label", value)
    == result_row("Label 2", value2)
```

## Line Continuation in Slim

Use backslash `\` for multi-line Ruby:

```slim
- hash = { \
    key1: "value1", \
    key2: "value2", \
    key3: "value3" \
  }
```

## Common Pitfalls

### ❌ This won't work
```slim
== method({
  key: value
})
```
**Error:** Slim sees `{` on its own line

### ✅ This works
```slim
== method({ key: value })
```

### ✅ Or this
```slim
- hash = { key: value }
== method(hash)
```

## Best Practices for Slim-Pickins

1. **Simple data** → inline hash
2. **Complex data** → multi-line variable first
3. **Need formatting** → use helpers 

**Be as good as bread.** 🍞
