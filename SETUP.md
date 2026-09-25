# CRM Automation Setup Guide

Complete step-by-step guide to set up your CRM automation system.

---

## Prerequisites

- n8n instance (self-hosted or cloud)
- Airtable account (free tier works)
- Google account (for free Gemini API)
- Gmail account for sending emails
- Twilio account for WhatsApp (optional)

> **100% Free Setup:** This system uses Google Gemini (free tier) instead of paid APIs like OpenAI.

---

## Step 1: Airtable Setup

### 1.1 Create a New Base

1. Go to [airtable.com](https://airtable.com) and sign in
2. Click **"Add a base"** → **"Start from scratch"**
3. Name it: `CRM Automation`

### 1.2 Create the Contacts Table

1. Rename "Table 1" to `Contacts`
2. Add these fields (click **+** to add each column):

| Field Name | Type | Configuration |
|------------|------|---------------|
| Name | Single line text | Primary field |
| Phone | Phone number | - |
| Email | Email | - |
| Source | Single select | Add: `Website Form`, `WhatsApp`, `Facebook`, `Instagram`, `Referral`, `Cold Outreach`, `Other` |
| Status | Single select | Add: `New`, `Contacted`, `Nurturing`, `Qualified`, `Converted`, `Lost`, `Unsubscribed` |
| LeadScore | Number | Integer format |
| Tier | Single select | Add: `Hot`, `Warm`, `Cold` |
| ScoringReason | Long text | - |
| SuggestedAction | Long text | - |
| InteractionCount | Number | Integer, default: 0 |
| LastSeen | Date | Include time |
| CreatedDate | Created time | Automatic |
| AssignedTo | Single line text | - |
| Notes | Long text | Enable rich text |
| Tags | Multiple select | Create as needed |

### 1.3 Create the Interactions Table

1. Click **"Add a table"** → Name it `Interactions`
2. Add these fields:

| Field Name | Type | Configuration |
|------------|------|---------------|
| Contact | Single line text | Enter contact name (must match name in Contacts table) |
| Type | Single select | Add: `Email Sent`, `WhatsApp`, `Call`, `Meeting`, `Note` |
| Direction | Single select | Add: `Inbound`, `Outbound` |
| Summary | Long text | - |
| Timestamp | Date | Include time |
| Outcome | Single select | Add: `Positive`, `Neutral`, `Negative`, `No Response` |

### 1.4 Create the Deals Table

1. Click **"Add a table"** → Name it `Deals`
2. Add these fields:

| Field Name | Type | Configuration |
|------------|------|---------------|
| Contact | Single line text | Enter contact name (must match name in Contacts table) |
| Stage | Single select | Add: `New`, `Qualified`, `Proposal`, `Negotiating`, `Won`, `Lost` |
| Value | Currency | Your currency |
| Product_Service | Single line text | - |
| ExpectedClose | Date | - |
| Notes | Long text | - |
| CreatedDate | Created time | Automatic |

### 1.5 Get Your Airtable Credentials

1. Click your profile icon → **"Developer hub"**
2. Click **"Create new token"**
3. Name: `CRM Automation`
4. Scopes: Select `data.records:read`, `data.records:write`, `schema.bases:read`
5. Access: Select your `CRM Automation` base
6. **Copy the token** → Save as `AIRTABLE_API_KEY`

7. Get your Base ID from the URL:
   ```
   https://airtable.com/appXXXXXXXXXXXXXX/...   
                        └── This is your AIRTABLE_BASE_ID
   ```

---

## Step 2: Google Gemini Setup (FREE)

### 2.1 Get API Key

1. Go to [aistudio.google.com](https://aistudio.google.com)
2. Sign in with your Google account
3. Click **"Get API Key"** in the left sidebar
4. Click **"Create API key"**
5. Select or create a Google Cloud project
6. **Copy the key** → Save as `GEMINI_API_KEY`

### 2.2 Free Tier Limits (No Payment Required)

| Model | Requests/Min | Requests/Day |
|-------|--------------|--------------|
| Gemini 2.0 Flash | 10 | 250 |
| Gemini 2.0 Flash-Lite | 15 | 1,000 |

> **Note:** The free tier is more than enough for most small businesses (250+ leads/day)

---

## Step 3: Gmail OAuth Setup

### 3.1 Google Cloud Console Setup

1. Go to [console.cloud.google.com](https://console.cloud.google.com)
2. Create a new project: `CRM Automation`
3. Enable the **Gmail API**:
   - Go to **"APIs & Services"** → **"Library"**
   - Search for "Gmail API" → Click **"Enable"**

### 3.2 Create OAuth Credentials

1. Go to **"APIs & Services"** → **"Credentials"**
2. Click **"Create Credentials"** → **"OAuth client ID"**
3. If prompted, configure the consent screen:
   - User Type: External (or Internal if using Workspace)
   - App name: `CRM Automation`
   - User support email: Your email
   - Developer contact: Your email
   - Click **"Save and Continue"** through all steps
4. Back to Credentials → **"Create Credentials"** → **"OAuth client ID"**
5. Application type: **"Web application"**
6. Name: `n8n Gmail`
7. Authorized redirect URIs: Add your n8n OAuth callback URL:
   - Cloud: `https://app.n8n.cloud/rest/oauth2-credential/callback`
   - Self-hosted: `https://your-n8n-domain/rest/oauth2-credential/callback`
8. Click **"Create"**
9. **Copy** the Client ID and Client Secret

### 3.3 Add Gmail Credential in n8n

1. In n8n, go to **Credentials** → **Add Credential**
2. Search for **"Gmail OAuth2"**
3. Paste your Client ID and Client Secret
4. Click **"Sign in with Google"** and authorize

---

## Step 4: Twilio WhatsApp Setup (Optional)

### 4.1 Create Twilio Account

1. Go to [twilio.com](https://www.twilio.com) and sign up
2. Complete phone verification

### 4.2 Get WhatsApp Sandbox

1. In Twilio Console, go to **"Messaging"** → **"Try it out"** → **"Send a WhatsApp message"**
2. Follow the instructions to join the sandbox:
   - Send the provided message to the Twilio WhatsApp number
3. Note your sandbox number (format: `+14155238886`)

### 4.3 Get Credentials

1. Go to **"Account"** → **"API keys & tokens"**
2. Copy:
   - Account SID → `TWILIO_ACCOUNT_SID`
   - Auth Token → `TWILIO_AUTH_TOKEN`
3. Your WhatsApp number → `TWILIO_WHATSAPP_NUMBER` (include `+` prefix)

### 4.4 Add Twilio Credential in n8n

1. In n8n, go to **Credentials** → **Add Credential**
2. Search for **"HTTP Basic Auth"** (we use HTTP request for Twilio)
3. Username: Your Account SID
4. Password: Your Auth Token
5. Name it: `Twilio Basic Auth`

---

## Step 5: n8n Workflow Import

### 5.1 Add Credentials First

Before importing workflows, create these credentials in n8n:

1. **Airtable Token API**
   - Credentials → Add → Airtable Token API
   - Paste your API key

2. **Gmail OAuth2**
   - Already set up in Step 3

3. **HTTP Basic Auth** (for Twilio)
   - Already set up in Step 4

> **Note:** Gemini API key is used via environment variable (no n8n credential needed)

### 5.2 Set Environment Variables

In n8n settings, add these environment variables:

```
GEMINI_API_KEY=your_gemini_api_key_here
AIRTABLE_BASE_ID=appXXXXXXXXXXXXXX
OWNER_EMAIL=your@email.com
OWNER_WHATSAPP=+1234567890
BUSINESS_NAME=Your Business Name
TWILIO_ACCOUNT_SID=ACXXXXXXXXXXXXXXXX
TWILIO_WHATSAPP_NUMBER=+14155238886
```

### 5.3 Import Workflows (In Order)

Import workflows in this exact order:

1. **1-lead-intake.json**
   - Go to n8n → Workflows → Import from File
   - Select `workflows/1-lead-intake.json`
   - Update credential references in each HTTP Request node
   - Note the webhook URL (you'll need this for the form)

2. **2-lead-scoring.json**
   - Import and update credentials

3. **3-follow-up-sequences.json**
   - Import and update credentials

4. **4-owner-alerts.json**
   - Import and update credentials

5. **5-daily-report.json**
   - Import and update credentials

### 5.4 Update Workflow References

After importing all workflows:

1. Open each workflow that has "Execute Workflow" nodes
2. Update the workflow references to point to the correct imported workflows

### 5.5 Activate Workflows

Activate in this order:
1. `5 - Daily Report` (has schedule trigger)
2. `4 - Owner Alerts`
3. `3 - Follow-up Sequences`
4. `2 - Lead Scoring`
5. `1 - Lead Intake` (activate last - this starts receiving webhooks)

---

## Step 6: Web Form Setup

### 6.1 Update the Form

1. Open `forms/tally-embed.html`
2. Find this line:
   ```javascript
   const WEBHOOK_URL = 'YOUR_N8N_WEBHOOK_URL/webhook/lead-intake';
   ```
3. Replace with your actual n8n webhook URL from workflow 1

### 6.2 Deploy the Form

Option A: **Simple hosting**
- Upload to Netlify, Vercel, or any static host

Option B: **Embed in existing site**
- Copy the form HTML into your website

Option C: **Use Tally.so instead**
- Create form at tally.so
- Add webhook integration pointing to your n8n webhook

---

## Step 7: Testing

### 7.1 Test Lead Intake

1. Open your web form
2. Submit a test lead with:
   - Name: `Test User`
   - Phone: `+1234567890`
   - Email: `test@example.com`
   - Message: `I want to buy your premium package, how much does it cost?`
   - Source: `Website Form`

### 7.2 Verify Each Step

1. **Check n8n**: Open workflow 1 execution history
   - Should show successful webhook receipt

2. **Check Airtable**: Open Contacts table
   - Should see new contact with Status: "New"

3. **Check Lead Scoring**: Open workflow 2 execution
   - Contact should have LeadScore (likely 8-9 for this message)
   - Tier should be "Hot"

4. **Check Alerts**: If hot lead:
   - Check your WhatsApp for notification
   - Check email for hot lead alert

5. **Check Follow-up**: Open workflow 3 execution
   - For hot leads: email sent immediately
   - For warm/cold: waiting state visible

### 7.3 Test Daily Report

1. Manually trigger workflow 5 in n8n
2. Check your email for the daily report

---

## Step 8: Going Live Checklist

Before going live:

- [ ] All 5 workflows imported and activated
- [ ] All credentials working (test each)
- [ ] Environment variables set correctly
- [ ] Webhook URL updated in web form
- [ ] Web form deployed and accessible
- [ ] Test submission successful end-to-end
- [ ] Hot lead WhatsApp alert received
- [ ] Hot lead email alert received
- [ ] Daily report email works
- [ ] Airtable records updating correctly

### Production Recommendations

1. **Upgrade Twilio** from sandbox to production WhatsApp
2. **Set up error notifications** in n8n
3. **Monitor** workflow executions daily for first week
4. **Backup** your Airtable base regularly

---

## Maintenance

### Weekly Tasks
- Review failed workflow executions in n8n
- Check Airtable for duplicate contacts
- Review lead scoring accuracy

### Monthly Tasks
- Review and optimize AI prompts if needed
- Check API usage and costs
- Update follow-up email templates seasonally

---

## Support

If you encounter issues:
1. Check `docs/TROUBLESHOOTING.md` for common problems
2. Review n8n workflow execution logs
3. Verify all credentials are still valid
4. Check API rate limits haven't been exceeded
