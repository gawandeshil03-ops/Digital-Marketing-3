# CRM Automation System

A complete, standalone CRM automation system built with n8n and Airtable. Automatically captures leads, scores them with AI, routes follow-ups, and sends real-time alerts to business owners.

## What It Does

- **Captures leads** from web forms (4 source types supported)
- **AI-powered scoring** rates each lead 1-10 automatically
- **Smart routing** sends hot leads to immediate follow-up, warm/cold to nurture sequences
- **Automated emails** personalized by AI, sent at the right time
- **Real-time alerts** via WhatsApp and email for hot leads
- **Daily reports** with metrics and AI-generated insights

**Zero manual work required.**

## Stack

| Component | Purpose |
|-----------|---------|
| **n8n** | Workflow automation |
| **Airtable** | CRM database |
| **Google Gemini** | Lead scoring + email writing (FREE) |
| **Gmail** | Email notifications + follow-ups |
| **Twilio** | WhatsApp alerts |
| **Tally.so** | Web form (optional) |

## Quick Start

1. Clone this repository
2. Copy `.env.example` to `.env` and fill in your credentials
3. Follow `SETUP.md` for complete setup instructions
4. Import workflows into n8n in order (1-6)
5. **IMPORTANT:** After importing workflows, replace placeholder values:
   - `YOUR_AIRTABLE_BASE_ID` → Your actual Airtable Base ID
   - `YOUR_TWILIO_ACCOUNT_SID` → Your Twilio Account SID
   - Update credential references in each workflow node
6. Deploy the web form
7. Submit a test lead

## File Structure

```
/crm-automation/
  /workflows/
    1-lead-intake.json      # Captures and deduplicates leads
    2-lead-scoring.json     # AI scores leads 1-10
    3-follow-up-sequences.json  # Tier-based email sequences
    4-owner-alerts.json     # WhatsApp + email notifications
    5-daily-report.json     # Scheduled daily summary
    6-auto-deals.json       # Auto-creates deals for converted leads
  /airtable/
    schema.md               # Database schema specification
  /forms/
    tally-embed.html        # Lead capture form
    serve.bat               # Local server for testing form
  SETUP.md                  # Step-by-step setup guide
  .env.example              # Environment variables template
  LICENSE                   # MIT License
  .gitignore                # Git ignore rules
  README.md                 # This file
```

## Workflows Overview

### 1. Lead Intake
Receives form submissions via webhook, normalizes data, checks for duplicates, creates/updates Airtable record, triggers scoring.

### 2. Lead Scoring
Uses Google Gemini to analyze lead data and score 1-10 based on:
- Contact info completeness (+2 phone, +1 email)
- Buying intent keywords (+3)
- Message specificity (+2)
- Returning visitor (+1)
- Message length (+1)

### 3. Follow-up Sequences
Routes leads by tier:
- **Hot (8-10)**: Immediate personalized email
- **Warm (5-7)**: Email after 24h, follow-up after 48h
- **Cold (1-4)**: Re-engagement email after 72h

### 4. Owner Alerts
- Hot lead: Instant WhatsApp + email
- Daily summary: Stats + AI insights at 8 PM
- Weekly report: Comprehensive metrics

### 5. Daily Report
Scheduled 8 PM daily email with:
- Today's lead count by tier
- Contact rate
- Top source
- AI-generated insights

### 6. Auto Deal Creation
Checks every 5 minutes for contacts marked as "Converted" and automatically:
- Creates deal records in the Deals table
- Links them to the contact
- Sets initial stage and value
- Marks contact as having a deal to prevent duplicates

## Lead Scoring Logic

```
Score 8-10 = HOT   → Immediate action
Score 5-7  = WARM  → Nurture sequence
Score 1-4  = COLD  → Light touch
```

## Requirements

- n8n (self-hosted or cloud)
- Airtable account (free tier works — no paid plan required)
- Google Gemini API key (FREE at [aistudio.google.com](https://aistudio.google.com))
- Gmail account with OAuth
- Twilio account (optional, for WhatsApp)

> **Note:** This system is 100% free to run:
> - Uses **Google Gemini** (free tier: 250+ requests/day) instead of OpenAI
> - Uses **text fields** for Contact references instead of "Link to record" (works with Airtable free plan)
> - The n8n workflows match records by contact name

## Setup

See `SETUP.md` for complete instructions covering:
- Airtable table creation
- API credential setup
- n8n workflow import
- Gmail OAuth configuration
- Twilio WhatsApp sandbox
- Testing procedures

## Customization

### Change scoring criteria
Edit the Gemini prompt in `2-lead-scoring.json`

### Adjust follow-up timing
Edit Wait node durations in `3-follow-up-sequences.json`

### Modify email templates
Edit Gemini prompts in follow-up and alert workflows

### Add lead sources
Update the Source field options in Airtable and form



