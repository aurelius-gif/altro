Safe `c` CLI wrapper

Files added:
- `tools/c` — Python CLI that performs local safety checks and calls Anthropic API if `ANTHROPIC_API_KEY` is set.
- `bin/c` — small shell shim that runs the Python CLI.

Usage:

Dry run (no API key required):

```bash
python3 tools/c "Hello, how are you?"
# or
./bin/c "Hello from the shell"
```

To enable real API calls, set your Anthropic key in the environment:

```bash
export ANTHROPIC_API_KEY="sk-..."
python3 tools/c "Tell me a story"
```

Install globally
---------------

Make `c` available as a top-level command:

```bash
./tools/install_c.sh         # installs to ~/bin and makes files executable
# or
sudo ./tools/install_c.sh -s # installs to /usr/local/bin
```

Ensure `requests` is installed for real API calls:

```bash
pip install requests
```

Safety:
- The CLI rejects prompts matching a denylist (weapons, illegal actions, jailbreak attempts, PII exfiltration, etc.).
- All attempts are logged to `tools/calls.log` (first 200 chars of prompt and result summary).

If you want stricter policies or integration with a real safety API, I can extend the checks or add a moderation webhook.
