# Security Workflows

This directory contains GitHub Actions workflows for automated security scanning and code quality checks.

## 🔒 Security Scan Workflow

The `security-scan.yml` workflow provides comprehensive security scanning for the entire project, including both the Employee Portal and Payments Portal.

### Features

#### 1. **Dependency Vulnerability Scanning**
- **npm audit**: Scans for known vulnerabilities in npm dependencies
- Runs on all four components (employee/payments × backend/frontend)
- Generates JSON reports for tracking
- Threshold: Moderate severity and above

#### 2. **Snyk Security Scanning**
- Advanced vulnerability detection using Snyk
- Checks for security issues in dependencies
- Uploads results to GitHub Security tab (SARIF format)
- Threshold: High severity and above

#### 3. **CodeQL Analysis**
- GitHub's semantic code analysis engine
- Detects security vulnerabilities in JavaScript/Node.js code
- Uses extended security queries
- Results available in GitHub Security tab

#### 4. **Secret Scanning**
- Uses TruffleHog OSS to detect hardcoded secrets
- Scans entire git history
- Detects API keys, passwords, tokens, and other credentials
- Only reports verified secrets

#### 5. **ESLint Security Scan**
- Lints frontend code for security issues
- Checks for common JavaScript security patterns
- Generates reports for review

#### 6. **SonarQube Analysis**
- Comprehensive code quality and security analysis
- Detects bugs, code smells, and security hotspots
- Includes test coverage analysis
- Integrates with your SonarQube instance

#### 7. **Dependency Review** (PR only)
- Reviews dependency changes in pull requests
- Blocks PRs with problematic dependencies
- Checks for license compliance
- Denied licenses: GPL-2.0, GPL-3.0

#### 8. **OSV Scanner**
- Google's Open Source Vulnerability scanner
- Scans for known vulnerabilities across all package managers
- Fast and comprehensive

### Triggers

The workflow runs on:
- **Push** to main/master/develop branches
- **Pull Requests** to main/master/develop branches
- **Schedule**: Daily at 2 AM UTC
- **Manual**: Can be triggered manually via workflow_dispatch

### Setup Requirements

#### Required Secrets

Add these secrets to your GitHub repository (Settings → Secrets and variables → Actions):

1. **SNYK_TOKEN** (Optional but recommended)
   - Sign up at [snyk.io](https://snyk.io)
   - Get your API token from Account Settings
   - Add as repository secret

2. **SONAR_TOKEN** (Optional)
   - Your SonarQube authentication token
   - Required if using SonarQube analysis

3. **SONAR_HOST_URL** (Optional)
   - Your SonarQube server URL
   - Example: `https://sonarcloud.io` or your self-hosted instance

### Viewing Results

#### GitHub Security Tab
1. Navigate to your repository
2. Click "Security" tab
3. Select "Code scanning alerts" or "Dependabot alerts"
4. Review findings and take action

#### Artifacts
- Workflow artifacts contain detailed JSON reports
- Available for 30 days after workflow run
- Download from Actions → Workflow run → Artifacts

#### Summary
- Each workflow run generates a summary
- Available at the bottom of the workflow run page
- Shows status of all scan types

### Best Practices

1. **Fix High/Critical Issues Immediately**
   - Address critical and high severity issues before merging
   - Use the security tab to track progress

2. **Review Dependency Updates**
   - Keep dependencies up to date
   - Use Dependabot for automated updates

3. **Don't Commit Secrets**
   - Use environment variables
   - Store sensitive data in GitHub Secrets
   - Use `.env` files (and add to `.gitignore`)

4. **Regular Scanning**
   - The scheduled daily scan helps catch new vulnerabilities
   - Don't disable the scheduled runs

5. **Monitor Trends**
   - Track security metrics over time
   - Set up notifications for new issues

### Customization

#### Adjusting Severity Thresholds

Edit `security-scan.yml` to change severity thresholds:

```yaml
# For npm audit (line ~42)
npm audit --audit-level=critical  # Options: low, moderate, high, critical

# For Snyk (line ~75)
args: --severity-threshold=medium  # Options: low, medium, high, critical
```

#### Adding Custom ESLint Rules

Create `.eslintrc.json` in each frontend directory with security plugins:

```json
{
  "extends": [
    "plugin:security/recommended",
    "plugin:react/recommended"
  ],
  "plugins": ["security"]
}
```

Then install: `npm install --save-dev eslint-plugin-security`

#### Disabling Specific Scans

Comment out or remove the job you don't need from the workflow file.

### Troubleshooting

#### Workflow Fails on npm audit
- This is expected if vulnerabilities are found
- Review the audit report
- Update dependencies: `npm audit fix`
- For issues without fixes, assess risk and document exceptions

#### Snyk Integration Issues
- Ensure `SNYK_TOKEN` secret is set
- Check token permissions
- Verify token hasn't expired

#### SonarQube Connection Issues
- Verify `SONAR_HOST_URL` and `SONAR_TOKEN`
- Check network access to SonarQube instance
- Ensure project exists in SonarQube

#### CodeQL Analysis Timeout
- CodeQL may take time on large codebases
- This is normal for the first run
- Subsequent runs use caching and are faster

### Integration with CI/CD

This workflow complements your existing CircleCI setup:
- GitHub Actions: Security scanning and automated checks
- CircleCI: Build, test, and deployment
- SonarQube: Code quality and security analysis

### Additional Resources

- [GitHub Code Scanning](https://docs.github.com/en/code-security/code-scanning)
- [Snyk Documentation](https://docs.snyk.io)
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [npm audit Documentation](https://docs.npmjs.com/cli/v8/commands/npm-audit)

### Support

For issues or questions about this workflow:
1. Check the workflow run logs
2. Review this documentation
3. Consult your DevSecOps team
4. Check GitHub Actions documentation

---

**Remember**: Security is everyone's responsibility. Make security scanning part of your development workflow, not an afterthought.

