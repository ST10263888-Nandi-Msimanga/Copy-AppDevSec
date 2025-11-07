# 🚀 Security Workflow Quick Reference

A one-page reference for the security scanning workflow.

---

## ⚡ Getting Started (30 seconds)

```bash
# 1. Commit and push
git add .github/ SECURITY.md *.md
git commit -m "Add security workflow"
git push

# 2. Watch it run
# Go to: GitHub → Actions tab → "Security Scan" workflow
```

**That's it!** The workflow is now running automatically.

---

## 🎯 What Gets Scanned

| Component | Location | Scanned |
|-----------|----------|---------|
| Employee Backend | `employee-portal/backend` | ✅ |
| Employee Frontend | `employee-portal/frontend` | ✅ |
| Payments Backend | `payments-portal/backend` | ✅ |
| Payments Frontend | `payments-portal/frontend` | ✅ |

**8 Types of Security Scans:**
1. 📦 npm audit
2. 🔍 Snyk (optional)
3. 🧬 CodeQL
4. 🔑 TruffleHog (secrets)
5. 🛠️ ESLint
6. 📊 SonarQube (optional)
7. 👀 Dependency Review
8. 🌐 OSV Scanner

---

## 🔄 When It Runs

- ⏰ **Daily** at 2 AM UTC
- 📤 **Every push** to main/master/develop
- 🔀 **Every PR** to main/master/develop  
- 🖱️ **Manual**: Actions tab → Run workflow

---

## 📊 View Results

### Security Tab
```
Repository → Security → Code scanning alerts
```
See all security findings in one place

### Actions Tab
```
Repository → Actions → Latest workflow run
```
Detailed logs and downloadable reports

### Pull Requests
Security checks appear automatically in PR status

---

## 🔧 Optional Setup (Recommended)

### Add Snyk Token
```
1. Sign up: https://snyk.io
2. Get API token: Account Settings → API Token
3. Add to GitHub: Settings → Secrets → New secret
   - Name: SNYK_TOKEN
   - Value: <your-token>
```

### Add SonarQube (If Using)
```
Add two secrets:
- SONAR_TOKEN: Your SonarQube auth token
- SONAR_HOST_URL: Your SonarQube server URL
```

---

## 🚨 When You Get Alerts

### Priority Response Times

| Severity | Fix Within | Action |
|----------|-----------|--------|
| 🔴 Critical | Same day | Fix immediately |
| 🟠 High | 3 days | Priority fix |
| 🟡 Medium | 2 weeks | Schedule fix |
| 🟢 Low | Next sprint | Plan fix |

### Fix Process
1. **Review**: Security tab → Click alert → Read details
2. **Fix**: Apply patch or update dependency
3. **Test**: Run tests locally
4. **Deploy**: Merge and deploy
5. **Verify**: Check alert is resolved

---

## 🤖 Dependabot PRs

### What Dependabot Does
- Checks for updates **weekly** (Mondays, 9 AM)
- Creates PRs for **security updates** automatically
- Groups security patches together

### How to Handle
```bash
# Security updates → Merge immediately
# Other updates → Review and merge weekly
```

**Quick merge command:**
```bash
# If tests pass
gh pr merge <PR-number> --squash
```

---

## ⚙️ Common Customizations

### Change Scan Schedule

Edit `.github/workflows/security-scan.yml` line 8:

```yaml
schedule:
  - cron: '0 2 * * *'  # Daily at 2 AM
  # - cron: '0 9 * * 1'  # Weekly on Monday at 9 AM
  # - cron: '0 0 1 * *'  # Monthly on 1st at midnight
```

### Adjust Severity Threshold

Line 42 (npm audit):
```yaml
npm audit --audit-level=moderate  # low | moderate | high | critical
```

Line 78 (Snyk):
```yaml
args: --severity-threshold=high  # low | medium | high | critical
```

### Disable a Scan

Comment out the entire job:
```yaml
# snyk-scan:
#   name: Snyk Security Scan
#   ... (entire section)
```

---

## 🐛 Troubleshooting

### Workflow Failed
```
✅ Normal on first run!
→ Check Actions logs
→ Usually dependency issue
→ Fix and re-run
```

### Too Many Alerts
```
✅ Start with Critical/High only
→ Fix incrementally
→ Don't get overwhelmed
```

### Snyk Not Working
```
→ Add SNYK_TOKEN secret
→ Or disable Snyk job (it's optional)
```

### CodeQL Slow
```
✅ First run is slow (caching afterwards)
→ 5-30 minutes is normal
→ Subsequent runs are faster
```

---

## 📁 Important Files

| File | Purpose |
|------|---------|
| `.github/workflows/security-scan.yml` | Main workflow |
| `.github/dependabot.yml` | Auto-dependency updates |
| `.github/codeql-config.yml` | CodeQL configuration |
| `SECURITY.md` | Security policy (public) |
| `.github/workflows/README.md` | Full documentation |
| `.github/SECURITY_SETUP_GUIDE.md` | Setup instructions |

---

## 🆘 Need Help?

1. **Check Logs**: Actions tab → Latest run → Job logs
2. **Read Docs**: `.github/workflows/README.md`
3. **Setup Guide**: `.github/SECURITY_SETUP_GUIDE.md`
4. **Tool Docs**: Check specific tool documentation

---

## ✅ Quick Checklist

**Initial Setup:**
- [ ] Files committed and pushed
- [ ] Workflow ran successfully
- [ ] Can view results in Security tab
- [ ] (Optional) Snyk token added

**Weekly:**
- [ ] Check Security tab for new alerts
- [ ] Merge critical Dependabot PRs
- [ ] Fix high-severity issues

**Monthly:**
- [ ] Review all open alerts
- [ ] Merge remaining Dependabot PRs
- [ ] Check workflow success rate

---

## 💡 Pro Tips

1. **Enable notifications**: Settings → Notifications → Dependabot alerts
2. **Review weekly**: Block 30 mins every Monday
3. **Fix fast**: Merge security updates same day
4. **Monitor trends**: Are issues decreasing?
5. **Update regularly**: Don't let dependencies get stale
6. **Test locally**: Use `npm audit` before pushing
7. **Document exceptions**: If you can't fix, document why

---

## 🎯 Success Metrics

Your security is working when:
- ✅ Workflow runs without errors
- ✅ Alerts are reviewed within 1 week
- ✅ Critical issues fixed within 24 hours
- ✅ Dependencies stay current (< 1 month old)
- ✅ Zero secrets in repository
- ✅ Security trend improving over time

---

## 📞 Quick Links

- [Full Documentation](.github/workflows/README.md)
- [Setup Guide](.github/SECURITY_SETUP_GUIDE.md)
- [Security Policy](../SECURITY.md)
- [GitHub Security Docs](https://docs.github.com/en/code-security)
- [Snyk Docs](https://docs.snyk.io)
- [CodeQL Docs](https://codeql.github.com/docs/)

---

**Last Updated**: November 7, 2025

**Remember**: Security is a continuous process, not a one-time task! 🛡️

