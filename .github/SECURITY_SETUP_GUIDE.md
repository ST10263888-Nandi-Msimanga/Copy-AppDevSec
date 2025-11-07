# 🔐 Security Workflow Setup Guide

This guide will help you set up and configure the automated security scanning workflow for your project.

## Quick Start (5 Minutes)

### Step 1: Enable GitHub Actions
1. Go to your repository on GitHub
2. Click **Settings** → **Actions** → **General**
3. Under "Actions permissions", select **Allow all actions and reusable workflows**
4. Click **Save**

### Step 2: Enable Code Scanning
1. Go to **Settings** → **Code security and analysis**
2. Enable the following:
   - ✅ **Dependency graph** (usually enabled by default)
   - ✅ **Dependabot alerts**
   - ✅ **Dependabot security updates**
   - ✅ **Code scanning** (CodeQL analysis)
   - ✅ **Secret scanning** (available for public repos, or private with GitHub Advanced Security)

### Step 3: Commit and Push
```bash
git add .github/
git add SECURITY.md
git commit -m "Add security scanning workflow"
git push origin main
```

The workflow will automatically run on this push!

---

## Complete Setup (15 Minutes)

### 1. Configure Snyk Integration (Recommended)

Snyk provides advanced vulnerability detection for dependencies.

**Steps:**
1. Go to [snyk.io](https://snyk.io) and sign up (free for open source)
2. Click your profile → **Account Settings**
3. Copy your **API Token**
4. In GitHub:
   - Go to **Settings** → **Secrets and variables** → **Actions**
   - Click **New repository secret**
   - Name: `SNYK_TOKEN`
   - Value: [paste your token]
   - Click **Add secret**

### 2. Configure SonarQube (Optional)

If you're already using SonarQube:

**Steps:**
1. Get your SonarQube token from your instance
2. Add these GitHub secrets:
   - `SONAR_TOKEN`: Your authentication token
   - `SONAR_HOST_URL`: Your SonarQube URL (e.g., `https://sonarcloud.io`)

**For SonarCloud:**
1. Go to [sonarcloud.io](https://sonarcloud.io)
2. Sign in with GitHub
3. Import your repository
4. Get your token from **My Account** → **Security**
5. Add as GitHub secret

### 3. Customize Dependabot Settings

The included `dependabot.yml` will:
- Check for updates weekly (every Monday)
- Create PRs for security updates
- Group security patches together
- Ignore major version updates by default

**To customize:**
- Edit `.github/dependabot.yml`
- Change schedule, reviewers, or ignore rules
- See [Dependabot documentation](https://docs.github.com/en/code-security/dependabot)

### 4. Set Up Notifications

Get notified about security issues:

1. Go to **Settings** → **Notifications** (your personal settings)
2. Under "Dependabot alerts":
   - ✅ Enable email notifications
   - ✅ Enable web notifications
3. In repository **Settings** → **Code security and analysis**:
   - Configure notification preferences for alerts

---

## Testing Your Setup

### Test the Workflow Manually

1. Go to **Actions** tab in your repository
2. Click **Security Scan** workflow
3. Click **Run workflow** → **Run workflow**
4. Wait for completion (2-5 minutes)

### Check Results

1. **Actions Tab**: View detailed logs and artifacts
2. **Security Tab**: 
   - **Code scanning alerts**: CodeQL findings
   - **Dependabot alerts**: Dependency vulnerabilities
   - **Secret scanning alerts**: Detected secrets (if enabled)

---

## Understanding the Workflow

### What Gets Scanned?

✅ **All 4 Components:**
- `employee-portal/backend` (Node.js)
- `employee-portal/frontend` (React)
- `payments-portal/backend` (Node.js)
- `payments-portal/frontend` (React)

✅ **Security Checks:**
1. **npm audit**: Known vulnerabilities in dependencies
2. **Snyk**: Advanced vulnerability detection
3. **CodeQL**: Code analysis for security issues
4. **TruffleHog**: Hardcoded secrets detection
5. **ESLint**: Security linting rules
6. **SonarQube**: Code quality and security
7. **Dependency Review**: PR dependency changes
8. **OSV Scanner**: Open source vulnerabilities

### When Does It Run?

- ⏰ **Scheduled**: Daily at 2 AM UTC
- 🔄 **On Push**: To main/master/develop branches
- 🔀 **On PR**: To main/master/develop branches
- 🖱️ **Manual**: Via workflow_dispatch button

---

## Troubleshooting

### ❌ "SNYK_TOKEN not found"

**Solution**: This is optional. Either:
1. Add the `SNYK_TOKEN` secret (recommended)
2. Or remove/comment out the `snyk-scan` job in the workflow

### ❌ "CodeQL analysis failed"

**Common causes:**
- First run takes longer (up to 30 minutes for large codebases)
- Dependency installation issues

**Solution**: 
- Check the workflow logs
- Ensure all `package.json` and `package-lock.json` files are valid
- Re-run the workflow

### ❌ "npm audit found vulnerabilities"

**This is expected!** The workflow is working correctly.

**Solution**:
1. Review the audit report in artifacts
2. Update vulnerable dependencies:
   ```bash
   cd [portal]/[component]
   npm audit fix
   ```
3. For unfixable issues, assess the risk

### ❌ "Dependency Review blocked my PR"

**Solution**:
1. Review the dependency changes
2. Check for:
   - High/critical vulnerabilities
   - Incompatible licenses
3. Address issues or request review from maintainer

---

## Best Practices

### 🎯 Fix Issues Promptly

| Severity | Action Timeline |
|----------|----------------|
| **Critical** | Fix immediately (same day) |
| **High** | Fix within 3 days |
| **Medium** | Fix within 2 weeks |
| **Low** | Fix in next release cycle |

### 📊 Monitor Trends

- Review security tab weekly
- Track open security issues
- Monitor Dependabot PRs
- Keep dependencies updated

### 🔒 Prevent Issues

1. **Never commit secrets**
   - Use `.env` files (add to `.gitignore`)
   - Use GitHub Secrets for CI/CD
   - Use environment variables

2. **Review dependencies**
   - Check new dependencies before adding
   - Review Dependabot PRs before merging
   - Remove unused dependencies

3. **Code review**
   - Review security scan results in PRs
   - Check for security issues during code review
   - Test authentication/authorization changes

### 📝 Documentation

- Keep `SECURITY.md` updated
- Document security exceptions
- Track security decisions
- Update this guide as needed

---

## Workflow Customization

### Change Scan Frequency

Edit `.github/workflows/security-scan.yml`:

```yaml
schedule:
  # Run daily at 2 AM UTC (current setting)
  - cron: '0 2 * * *'
  
  # Run weekly on Monday at 9 AM UTC
  - cron: '0 9 * * 1'
  
  # Run on first day of month
  - cron: '0 0 1 * *'
```

### Adjust Severity Thresholds

**npm audit** (line ~42):
```yaml
npm audit --audit-level=critical  # Options: low, moderate, high, critical
```

**Snyk** (line ~75):
```yaml
args: --severity-threshold=medium  # Options: low, medium, high, critical
```

**Dependency Review** (line ~258):
```yaml
fail-on-severity: moderate  # Options: low, moderate, high, critical
```

### Disable Specific Scans

Comment out jobs you don't need:

```yaml
# Comment out lines to disable:
# snyk-scan:
#   name: Snyk Security Scan
#   ...entire job...
```

### Add More Scans

Add additional security tools:
- **OWASP ZAP**: Dynamic application security testing
- **Trivy**: Container and filesystem scanning
- **Semgrep**: Static analysis for security patterns

---

## Getting Help

### Resources

- 📚 [GitHub Actions Documentation](https://docs.github.com/en/actions)
- 🔒 [GitHub Security Documentation](https://docs.github.com/en/code-security)
- 📖 [Workflow README](.github/workflows/README.md)
- 🛡️ [SECURITY.md](../SECURITY.md)

### Support Channels

1. Check workflow logs in Actions tab
2. Review GitHub documentation
3. Check security tool documentation:
   - [Snyk Docs](https://docs.snyk.io)
   - [CodeQL Docs](https://codeql.github.com/docs/)
4. Contact your DevSecOps team

---

## Success Checklist

Before considering setup complete:

- [ ] GitHub Actions are enabled
- [ ] Code scanning is enabled
- [ ] Dependabot is configured
- [ ] Workflow has run successfully at least once
- [ ] You can view results in Security tab
- [ ] Snyk token is added (if using Snyk)
- [ ] Team members understand the workflow
- [ ] Notification preferences are set
- [ ] Documentation is reviewed

---

**Need help?** Check the workflow logs or refer to the main README documentation.

**Last Updated**: November 7, 2025

