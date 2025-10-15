# Demo App Troubleshooting Guide

## Issue: Form doesn't update when typing

### Check Browser Console

Open DevTools (F12) and look for:

```
✅ Reactive form connected!
📍 URL: /calculate
🎯 Target: #results
⏱️  Debounce: 300ms
```

If you DON'T see this, Stimulus isn't loading.

### Check When Typing

You should see:
```
📝 Field changed: principal = 10000
⏰ Debounce complete, updating...
🚀 Sending update to: /calculate
📥 Response status: 200
✅ Updated target: #results
```

### Common Issues

**No "Reactive form connected" message:**
- Check that `/js/app.js` loaded (Network tab)
- Check that `/js/controllers/reactive_form_controller.js` loaded
- Check browser console for JavaScript errors

**"Field changed" but no update:**
- Check that debounce completes (wait 300ms)
- Check Network tab for POST to /calculate
- If 404: endpoint doesn't exist
- If 500: server error (check terminal)

**Update sends but DOM doesn't change:**
- Check that `#results` element exists
- Check that response HTML is valid
- Check console for "Target element not found"

## Issue: Button doesn't work

The "Back to Calculator" button should be a regular link:

```slim
a.btn-secondary href="/" Back to Calculator
```

NOT an action_button (that's for Stimulus actions).

## Debugging Steps

1. **Check Stimulus loads:**
   ```javascript
   console.log(window.Stimulus)  // Should be defined
   ```

2. **Check controller registered:**
   ```javascript
   console.log(window.Stimulus.router.modulesByIdentifier.get("reactive-form"))
   ```

3. **Check form has correct attributes:**
   ```javascript
   document.querySelector('[data-controller="reactive-form"]')
   ```

4. **Manually trigger update:**
   ```javascript
   const controller = document.querySelector('[data-controller="reactive-form"]')
   const stimulus = window.Stimulus.getControllerForElementAndIdentifier(controller, 'reactive-form')
   stimulus.update()
   ```

## Server Logs

When typing, you should see in terminal:

```
📥 POST /calculate received
📊 Request body: {"principal":10000,"rate":7,"years":10}
✅ Parsed JSON: {...}
💰 Calculated:
   Principal: $10000.0
   Rate: 7.0%
   Years: 10
   Final: $19671.51
📤 Sending HTML response (456 bytes)
127.0.0.1 - - [15/Oct/2025:16:30:00] "POST /calculate HTTP/1.1" 200 456
```

If you DON'T see POST requests, the JavaScript isn't firing.

## Quick Test

Open browser console and run:

```javascript
fetch('/calculate', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify({principal: 10000, rate: 7, years: 10})
}).then(r => r.text()).then(html => {
  document.getElementById('results').innerHTML = html
})
```

If this works, the endpoint is fine. Problem is in Stimulus wiring.

**Be as good as bread.** 🍞
