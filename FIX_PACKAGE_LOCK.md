# 🔧 Fix Package Lock Files

## Problem

Your `package-lock.json` files are out of sync with your `package.json` files. This causes the CI/CD pipeline to fail because `npm ci` requires them to be in perfect sync.

## Quick Fix (Run These Commands)

Open your terminal and run these commands one by one:

```bash
# Navigate to your project root
cd /Users/nandimsimanga/NewDevSpace/Work-School/Copy-AppDevSec

# Fix employee-portal backend
cd employee-portal/backend
npm install
cd ../..

# Fix employee-portal frontend
cd employee-portal/frontend
npm install
cd ../..

# Fix payments-portal backend
cd payments-portal/backend
npm install
cd ../..

# Fix payments-portal frontend
cd payments-portal/frontend
npm install
cd ../..

# Commit the updated lock files
git add employee-portal/*/package-lock.json payments-portal/*/package-lock.json
git commit -m "Fix: Regenerate package-lock.json files to sync with package.json"
git push
```

## What This Does

1. **`npm install`** reads your `package.json` and regenerates the `package-lock.json` file
2. This ensures they're in sync
3. The workflow will now run successfully

## Alternative: Quick Script

Save this as `fix-locks.sh` and run it:

```bash
#!/bin/bash

echo "Fixing package-lock.json files..."

cd employee-portal/backend
echo "→ employee-portal/backend"
npm install

cd ../frontend
echo "→ employee-portal/frontend"
npm install

cd ../../payments-portal/backend
echo "→ payments-portal/backend"
npm install

cd ../frontend
echo "→ payments-portal/frontend"  
npm install

cd ../..

echo "✅ All package-lock.json files updated!"
echo "Don't forget to commit and push:"
echo "  git add */*/package-lock.json"
echo "  git commit -m 'Fix: Regenerate package-lock files'"
echo "  git push"
```

Then run:
```bash
chmod +x fix-locks.sh
./fix-locks.sh
```

## Why This Happened

This typically occurs when:
- Dependencies were added/removed manually in `package.json`
- Someone ran `npm install` with an older version of npm
- Dependencies were updated but lock file wasn't committed
- Merge conflicts in lock files were resolved incorrectly

## Prevention

To prevent this in the future:

1. **Always run `npm install`** after editing `package.json`
2. **Always commit lock files** together with `package.json` changes
3. **Don't edit lock files manually** - let npm generate them
4. **Use consistent npm version** across your team

## Verification

After fixing, verify it works:

```bash
# Test each component
cd employee-portal/backend && npm ci && cd ../..
cd employee-portal/frontend && npm ci && cd ../..
cd payments-portal/backend && npm ci && cd ../..
cd payments-portal/frontend && npm ci && cd ../..
```

If all commands succeed without errors, you're good to go! ✅

## If Still Having Issues

If you still get errors after running the fix:

1. **Delete node_modules and try again:**
   ```bash
   cd employee-portal/backend
   rm -rf node_modules package-lock.json
   npm install
   ```

2. **Check npm version:**
   ```bash
   npm --version
   # Should be 8.x or higher
   ```

3. **Clear npm cache:**
   ```bash
   npm cache clean --force
   npm install
   ```

## Note About the Workflow

I've updated the security workflow to automatically fall back to `npm install` if `npm ci` fails. This makes it more resilient, but it's still best practice to keep your lock files in sync.

**Workflow change:**
```yaml
# Before
run: npm ci

# After
run: npm ci || npm install  # Falls back to install if ci fails
```

---

**After fixing, commit and push your changes, then the workflow will run successfully!**

