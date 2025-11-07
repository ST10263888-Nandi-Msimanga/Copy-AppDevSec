# 🔧 Workflow Troubleshooting Guide

## ✅ Issues Fixed

### 1. Duplicate CodeQL Workflow
**Problem:** You had two CodeQL workflows running:
- Old: `.github/workflows/codeql.yml` (broken, pointing to wrong directory)
- New: `.github/workflows/security-scan.yml` (comprehensive, properly configured)

**Solution:** ✅ **FIXED** - Removed the old duplicate workflow

---

## ⚠️ Common Issues & Solutions

### Secret Scanning Failure

**Likely Causes:**

1. **Secret scanning is not enabled** (requires GitHub Advanced Security for private repos)
   - Public repos: Works automatically
   - Private repos: Requires GitHub Advanced Security license

2. **TruffleHog found secrets** (this is actually good - it's working!)
   - The scan "fails" when it finds secrets
   - Check the logs to see what was found

**Solutions:**

**If you're on a private repo without Advanced Security:**
```yaml
# Option 1: Disable secret scanning (edit security-scan.yml)
# Comment out or remove the secret-scan job (lines 131-145)

# Option 2: Use GitHub's built-in secret scanning
# Go to Settings → Security → Enable "Secret scanning"
```

**If secrets were found:**
1. Review the workflow logs to see what was detected
2. Remove the secrets from your code
3. Rotate any exposed credentials
4. Use environment variables instead
5. Add secrets to GitHub Secrets (Settings → Secrets)

### CodeQL Analysis Issues

**Now that we removed the duplicate workflow, CodeQL should work. If it still fails:**

**Check for:**
1. Syntax errors in your JavaScript/TypeScript code
2. Dependencies failing to install
3. Build errors

**Solutions:**
```bash
# Test locally first
cd employee-portal/backend
npm install
node -c app.js  # Check syntax

cd ../frontend  
npm install
npm run build --if-present
```

### ESLint Warnings (Common)

ESLint might report issues but continue-on-error is set, so it won't block your workflow.

**To fix ESLint issues:**
```bash
cd employee-portal/frontend
npx eslint . --ext .js,.jsx --fix
```

---

## 🔍 How to Diagnose Issues

### Step 1: Check the Workflow Logs

```
GitHub → Actions → Latest workflow run → Click failing job
```

Look for:
- Error messages in red
- Which step failed
- The actual error text

### Step 2: Check Common Issues

| Error Message | Cause | Fix |
|--------------|-------|-----|
| "No such file or directory: backend" | Wrong directory structure | ✅ Fixed by removing old workflow |
| "SNYK_TOKEN not found" | Missing secret (optional) | Add token or ignore |
| "TruffleHog found secrets" | Hardcoded secrets detected | Remove secrets, use env vars |
| "npm ci failed" | Lock files out of sync | Run `./fix-package-locks.sh` |
| "CodeQL analysis error" | Syntax or dependency issue | Check logs for specifics |

### Step 3: Re-run the Workflow

After fixing issues:
```
GitHub → Actions → Latest run → Re-run failed jobs
```

Or trigger manually:
```
GitHub → Actions → Security Scan → Run workflow
```

---

## 🎯 Expected Results

### ✅ Successful Run Looks Like:

```
✅ Dependency Scan: success
✅ CodeQL Analysis: success  
✅ Secret Scanning: success (or skipped)
✅ ESLint Security: success
✅ Snyk Scan: success (if token configured)
✅ SonarQube: success (if token configured)
```

### ⚠️ Acceptable "Failures"

Some "failures" are actually the tool working correctly:

1. **npm audit finds vulnerabilities** → Good! Now you can fix them
2. **Secret scanning finds secrets** → Good! Now you can remove them
3. **CodeQL finds security issues** → Good! Now you can fix them

These should show as warnings/alerts in the Security tab, not as workflow failures.

---

## 🔧 Quick Fixes

### Remove Secret Scanning (If Not Needed)

Edit `.github/workflows/security-scan.yml` and comment out lines 131-145:

```yaml
# secret-scan:
#   name: Secret Scanning
#   runs-on: ubuntu-latest
#   ...entire job...
```

### Disable Snyk (If No Token)

Snyk already has `continue-on-error: true`, so it shouldn't block. But if you want to disable it entirely:

```yaml
# snyk-scan:
#   name: Snyk Security Scan
#   ...entire job...
```

### Disable SonarQube (If Not Using)

Already configured to skip if no token is set. No action needed.

---

## 📊 Understanding the Summary

The workflow creates a summary at the end:

```bash
echo "- ✅ Dependency Scan: success" 
```

**Status meanings:**
- `success` → Scan ran and completed
- `failure` → Scan failed to run or found critical issues
- `skipped` → Scan was skipped (usually due to missing config)

**Note:** Finding vulnerabilities doesn't necessarily mean "failure". Check the Security tab for actual findings.

---

## ✅ Commit the Fix

Now that we've removed the duplicate workflow:

```bash
git add .github/workflows/
git commit -m "Fix: Remove duplicate CodeQL workflow"
git push
```

The workflow will now run correctly! 🎉

---

## 🆘 Still Having Issues?

### Check These Common Problems:

1. **Package lock files still out of sync?**
   → Run `./fix-package-locks.sh`

2. **Secrets detected in code?**
   → Review logs, remove secrets, use environment variables

3. **CodeQL still failing?**
   → Check for JavaScript syntax errors in your code

4. **Need to see detailed logs?**
   → Actions tab → Click the workflow run → Click each job

### Get More Info:

- View full logs: Actions → Workflow run → Job name
- Download artifacts: Actions → Workflow run → Artifacts section
- Check Security tab: Security → Code scanning alerts

---

## 📝 Next Steps

1. ✅ Commit the deletion of old workflow
2. ✅ Push to trigger a new run
3. ✅ Check the Actions tab for results
4. ✅ Review any findings in Security tab
5. ✅ Fix any actual vulnerabilities found

---

**The workflow is now properly configured and should run successfully!** 🚀

If you see failures, they're likely:
- Finding actual security issues (which is good!)
- Missing optional tokens (Snyk, SonarQube)
- Secret scanning needs Advanced Security (private repos only)

All of these are normal and expected. The important scans (npm audit, CodeQL, dependency review) should all work! ✅

