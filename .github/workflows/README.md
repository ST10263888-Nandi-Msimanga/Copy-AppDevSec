# GitHub Actions Workflows

This directory contains CI/CD workflows with security-hardened configurations following the principle of least privilege.

## Workflows

### 1. CodeQL Security Analysis (`codeql-analysis.yml`)
**Purpose:** Automated security scanning for vulnerabilities

**Permissions:**
- `actions: read` - Read workflow run data
- `contents: read` - Read repository code
- `security-events: write` - Upload security findings to GitHub Security tab

**Triggers:**
- Push to main/master/develop branches
- Pull requests
- Weekly schedule (Mondays at midnight)

### 2. CI - Build and Test (`ci.yml`)
**Purpose:** Continuous integration testing for both portals

**Permissions:**
- `contents: read` - Read repository code only (minimal access)

**Jobs:**
- Backend tests (employee-portal & payments-portal)
- Frontend tests (employee-portal & payments-portal)
- Linting

### 3. Dependency Review (`dependency-review.yml`)
**Purpose:** Review dependencies for security issues and license compliance

**Permissions:**
- `contents: read` - Read repository code
- `pull-requests: write` - Comment on PRs with findings

**Triggers:**
- Pull requests to main/master

**Security Features:**
- Fails on HIGH severity vulnerabilities
- Blocks GPL-2.0 and GPL-3.0 licenses

## Security Best Practices

### Principle of Least Privilege
All workflows follow the principle of least privilege by:
1. Setting explicit `permissions` at the workflow level
2. Setting explicit `permissions` at the job level (most restrictive)
3. Only granting the minimum permissions required for each job

### Default Permissions
Without explicit permissions, GitHub Actions workflows receive broad permissions including:
- `contents: write` (can modify code)
- `issues: write` (can modify issues)
- `pull-requests: write` (can modify PRs)
- And many more...

By explicitly defining permissions, we prevent:
- Unauthorized code modifications
- Token theft/exfiltration attacks
- Privilege escalation
- Supply chain attacks through compromised actions

## References

- [GitHub Actions Security Best Practices](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions)
- [OWASP Top 10 CI/CD Security Risks](https://owasp.org/www-project-top-10-ci-cd-security-risks/)
- [OpenSSF Scorecards](https://github.com/ossf/scorecard)

## Token Permissions Reference

| Permission | Read | Write | Description |
|------------|------|-------|-------------|
| `actions` | ✅ | ❌ | View workflow runs |
| `contents` | ✅ | ❌ | Read repository code |
| `security-events` | ❌ | ✅ | Upload security findings |
| `pull-requests` | ❌ | ✅ | Comment on PRs (dependency review only) |

## Updating Workflows

When modifying workflows:
1. Always specify explicit permissions
2. Use the minimum permissions required
3. Prefer job-level over workflow-level permissions
4. Test changes in a feature branch first
5. Review security implications before merging
