# False positive filter (hard rules)

Adapted from [anthropics/claude-code-security-review](https://github.com/anthropics/claude-code-security-review) `findings_filter.py` HardExclusionRules. Apply **before** presenting findings to the user.

## Drop finding if

| Rule | Match (title + description) |
|------|-----------------------------|
| Markdown file | `file` ends with `.md` |
| DoS / exhaustion | denial of service, resource exhaustion, overwhelm memory/cpu, infinite loop as “attack” |
| Rate limiting | missing/lack of rate limit, unlimited requests |
| Resource leak | resource/memory/file leak, unclosed connection (unless clearly security-sensitive) |
| Open redirect | open redirect, unvalidated redirect |
| Regex injection / ReDoS | regex injection, regex DoS |
| Memory safety outside C/C++ | buffer overflow / UAF / OOB when file is not `.c/.cc/.cpp/.h` |
| SSRF in HTML only | SSRF when file is `.html` |

## Keep

Injection, auth bypass, XSS with clear sink, unsafe deserialization, hardcoded secrets **in executable code** (still prefer gitleaks for credential strings), crypto misuse with exploit path.

## After filter

Recompute summary counts. If nothing remains: say so in one line.
