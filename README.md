# LFB Sales Leads Portal

A password-protected sales leads dashboard for Lazar Family Bakehouse. Track leads across three pipeline stages (Scouting, Hot Lead, Converted), with full search, filtering, and real-time sync.

---

## Architecture Overview

| Layer     | Technology              | Purpose                                  |
|-----------|-------------------------|------------------------------------------|
| Frontend  | HTML/CSS/JS (single file) | Portal UI, lead management             |
| Hosting   | GitHub Pages            | Auto-deploys from main branch            |
| Database  | Supabase (PostgreSQL)   | Leads table with RLS                     |
| Auth      | Supabase Auth           | Email/password login                     |
| Real-time | Supabase Realtime       | Live sync across browsers/devices        |

---

## Repository Structure

lfb-sales-portal/
- index.html              # Main portal (all HTML/CSS/JS in one file)
- PUSH_TO_SALES_LIVE.bat  # Double-click to deploy changes
- SETUP_AUTOPUSH.bat      # Run once to enable auto-push on file changes
- autopush_watcher.ps1    # Background file watcher (auto-push)
- setup.sql               # Supabase database schema (reference)
- README.md               # This file
- docs/CHANGELOG.md       # Change log of all updates

---

## Quick-Start: Making Changes

1. Edit index.html locally
2. Double-click PUSH_TO_SALES_LIVE.bat (or use git push)
3. GitHub Pages rebuilds within 1-2 minutes

---

## Deployment

- Method: GitHub Pages (auto-deploys from main branch)
- Push script: PUSH_TO_SALES_LIVE.bat
- Auto-push: SETUP_AUTOPUSH.bat (run once to install)
