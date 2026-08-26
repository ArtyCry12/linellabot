# WBS — {title}

- **id:** P
- **status:** pending
- **DoD:** 
- **Out of scope:** 
- **File:** `docs/wbs/{slug}.md`

Skip any level that would be a dummy. Detail the current epic; later epics may stay as titles.

## E1. {epic title}

- **parent:** P
- **status:** pending
- **IN:** 
- **OUT:** 

### E1.S1. {story title}

- **parent:** E1
- **status:** pending
- **AC:**
  - [ ] 
  - [ ] 

#### E1.S1.T1. {task title}

- **parent:** E1.S1
- **status:** pending
- **files:** 
- **risk:** low | medium | high
- **deps:** 

##### E1.S1.T1.W1. {package title}

- **parent:** E1.S1.T1
- **status:** pending
- **change:** one concrete edit
- **verify:** one real check (test / lint / snapshot / audit output / dry-run / Boss report)
