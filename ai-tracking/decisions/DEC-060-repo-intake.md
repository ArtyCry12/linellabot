# DEC-060 — Repo Intake (drop repo, get menu)

**Status:** Accepted  
**Date:** 2026-07-10

## Problem

User tired of specifying what to do with each repository.

## Decision

Hook detects GitHub/path/zip → inject REPO INTAKE → skill runs scout → menu A/B/C → wait for pick.

## Files

- `skills/repo-intake/SKILL.md`
- `hooks/repo-intake.ps1`
- `commands/repo.md`
- `templates/repo-intake/MENU-TEMPLATE.md`
