# Airtable CRM Schema

This document defines the exact column specifications for your CRM Airtable base.

## Base Name: `CRM Automation`

---

## Table 1: Contacts

The main table storing all leads and contacts.

| Field Name | Field Type | Options/Configuration | Required |
|------------|------------|----------------------|----------|
| Name | Single line text | - | ✅ Yes |
| Phone | Phone number | - | No |
| Email | Email | - | No |
| Source | Single select | `Website Form`, `WhatsApp`, `Facebook`, `Instagram`, `Referral`, `Cold Outreach`, `Other` | No |
| Status | Single select | `New`, `Contacted`, `Nurturing`, `Qualified`, `Converted`, `Lost`, `Unsubscribed` | No |
| LeadScore | Number | Integer, 0-10 | No |
| Tier | Single select | `Hot`, `Warm`, `Cold` | No |
| ScoringReason | Long text | Enable rich text formatting | No |
| SuggestedAction | Long text | Enable rich text formatting | No |
| InteractionCount | Number | Integer, default: 0 | No |
| LastSeen | Date | Include time field | No |
| CreatedDate | Created time | - | Auto |
| AssignedTo | Single line text | - | No |
| Notes | Long text | Enable rich text formatting | No |
| Tags | Multiple select | Create tags as needed (e.g., `VIP`, `Follow-up`, `Priority`, `Unresponsive`) | No |
| DealCreated | Checkbox | Used by auto-deal workflow to prevent duplicate deals | No |

### Primary Field
- **Name** is the primary field

### Default View
Create a view called "All Contacts" sorted by `CreatedDate` descending.

### Recommended Views
1. **Hot Leads** - Filter: `Tier` = `Hot` AND `Status` = `New` or `Contacted`
2. **Needs Follow-up** - Filter: `Status` = `Contacted` AND `LastSeen` < 3 days ago
3. **This Week** - Filter: `CreatedDate` is within the past 7 days

---

## Table 2: Interactions

Tracks all communications and touchpoints with contacts.

| Field Name | Field Type | Options/Configuration | Required |
|------------|------------|----------------------|----------|
| Contact | Single line text | Enter contact name (matches Contacts.Name) | ✅ Yes |
| Type | Single select | `Email Sent`, `WhatsApp`, `Call`, `Meeting`, `Note`, `Form Submission`, `Alert Sent`, `Deal Created` | ✅ Yes |
| Direction | Single select | `Inbound`, `Outbound` | No |
| Summary | Long text | Enable rich text formatting | No |
| Timestamp | Date | Include time field | ✅ Yes |
| Outcome | Single select | `Positive`, `Neutral`, `Negative`, `No Response` | No |

### Primary Field
- Create a formula field as primary: `{Type} - {Timestamp}`

### Default View
Create a view called "All Interactions" sorted by `Timestamp` descending.

### Recommended Views
1. **Recent Activity** - Filter: `Timestamp` is within the past 24 hours
2. **Pending Responses** - Filter: `Outcome` = `No Response`

---

## Table 3: Deals

Tracks sales opportunities and pipeline.

| Field Name | Field Type | Options/Configuration | Required |
|------------|------------|----------------------|----------|
| Contact | Single line text | Enter contact name (matches Contacts.Name) | ✅ Yes |
| Stage | Single select | `New`, `Qualified`, `Proposal`, `Negotiating`, `Won`, `Lost` | No |
| Value | Currency | Use your local currency | No |
| Product_Service | Single line text | - | No |
| ExpectedClose | Date | - | No |
| Notes | Long text | Enable rich text formatting | No |
| CreatedDate | Created time | - | Auto |

### Primary Field
- Create a formula field as primary: Link to Contact name + Stage

### Default View
Create a view called "Pipeline" sorted by `Stage` then `ExpectedClose`.

### Recommended Views
1. **Active Deals** - Filter: `Stage` is not `Won` and is not `Lost`
2. **Won This Month** - Filter: `Stage` = `Won` AND `CreatedDate` is within this month
3. **Closing Soon** - Filter: `ExpectedClose` is within the next 7 days

---

## Setup Instructions

1. Create a new Airtable base named "CRM Automation"
2. Create each table with the exact field names and types above
3. For Single select fields, add all options before importing data
4. Set up the recommended views for each table
5. Copy your Base ID from the URL (starts with `app`)
6. Generate a Personal Access Token with read/write permissions

### Finding Your Base ID
Your Base ID is in the Airtable URL:
```
https://airtable.com/appXXXXXXXXXXXXXX/tblYYYYYYYYYYYYYY
                     ↑ This is your Base ID
```

### API Token Permissions
When creating your Personal Access Token, ensure these scopes:
- `data.records:read`
- `data.records:write`
- `schema.bases:read`
