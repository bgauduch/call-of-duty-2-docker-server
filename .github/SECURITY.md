# Security Policy

## Supported Versions

We actively support the following versions of the Call of Duty 2 Docker Server:

| Version | Supported          |
| ------- | ------------------ |
| latest  | :white_check_mark: |
| 3.x     | :white_check_mark: |
| < 3.0   | :x:                |

## Reporting a Vulnerability

We take the security of this project seriously. If you discover a security vulnerability, please follow these steps:

### 1. **Do Not** Open a Public Issue

Please do not report security vulnerabilities through public GitHub issues, discussions, or pull requests.

### 2. Report Privately

Instead, please report security vulnerabilities by:

- **Email**: Send details to the maintainer at the email associated with the GitHub account (@bgauduch)
- **GitHub Private Vulnerability Reporting**: Use GitHub's [private vulnerability reporting feature](https://github.com/bgauduch/call-of-duty-2-docker-server/security/advisories/new) (preferred method)

### 3. What to Include

Please include as much of the following information as possible:

- **Type of vulnerability** (e.g., remote code execution, privilege escalation, information disclosure)
- **Full paths of source file(s)** related to the vulnerability
- **Location of the affected source code** (tag/branch/commit or direct URL)
- **Step-by-step instructions** to reproduce the issue
- **Proof-of-concept or exploit code** (if available)
- **Impact of the vulnerability**, including how an attacker might exploit it
- **Any potential mitigations** you've identified

### 4. Response Timeline

- **Initial Response**: We aim to acknowledge your report within 48 hours
- **Status Update**: We will provide a detailed response within 7 days, including:
  - Confirmation of the vulnerability (or explanation if we believe it's not a vulnerability)
  - Our plan for addressing the issue
  - Estimated timeline for a fix
- **Resolution**: We will notify you when the vulnerability has been fixed

### 5. Coordinated Disclosure

We believe in coordinated disclosure and will work with you to:

- Understand and validate the vulnerability
- Develop and test a fix
- Prepare an advisory
- Coordinate the public disclosure timing

We ask that you:

- Give us reasonable time to fix the vulnerability before public disclosure
- Make a good faith effort to avoid privacy violations, data destruction, or service interruption
- Not exploit the vulnerability beyond what is necessary to demonstrate it

## Security Best Practices for Users

When deploying this Call of Duty 2 server, we recommend:

1. **Keep Images Updated**: Regularly pull the latest image versions to get security patches
   ```bash
   docker pull bgauduch/cod2server:latest
   ```

2. **Use Strong RCON Password**: Always set a strong, unique RCON password in your `server_mp.cfg`

3. **Network Security**:
   - Only expose necessary ports
   - Use a firewall to restrict access
   - Consider using a VPN for administrative access

4. **Resource Limits**: The provided docker-compose.yaml includes resource limits - keep them enabled

5. **Monitor Logs**: Regularly check server logs for suspicious activity
   ```bash
   docker-compose logs -f cod2_server
   ```

6. **Volume Permissions**: Ensure proper permissions on mounted volumes

7. **Regular Scans**: Use tools like Trivy to scan images for vulnerabilities:
   ```bash
   docker run --rm aquasec/trivy image bgauduch/cod2server:latest
   ```

## Security Updates

Security updates will be:

- Released as soon as possible after validation
- Documented in the release notes
- Announced in the GitHub Security Advisories section
- Applied to all supported versions when applicable

## Bug Bounty Program

We do not currently have a bug bounty program, but we deeply appreciate security researchers who responsibly disclose vulnerabilities to help keep this project and its users safe.

## Acknowledgments

We will acknowledge security researchers who responsibly disclose vulnerabilities (unless they prefer to remain anonymous) in:

- The fix commit message
- The release notes
- The security advisory (if published)

Thank you for helping keep Call of Duty 2 Docker Server and its users safe!
