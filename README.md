# Policy Checker

This is a tool that can be used both locally and in CI to determine if your repository is compliant with your Organisation's Policy as Code.

Policy location and versions are determined by:
- **Terraform:** Scans `policy_checker.json` file in your repository looking for 3 keys:
    ```json
    {
        "source": "https://github.com/appvia/policy",
        "version": "1.0.1",
        "config": "infra/generic/config.yaml"
    }
    ```
- **Kubernetes:** *Not yet implemented*

## Usage

The following env vars can be set (defaulted to false) depending on the checks you wish to run:
- `RUN_CHECKOV_POLICIES: true`
- `RUN_KYVERNO_POLICIES: true`

```bash
$ docker run --rm -v ${PWD}:/workdir -e RUN_CHECKOV_POLICIES=true ghcr.io/appvia/policy-checker
```

## Examples

- **Policy as Code:** https://github.com/appvia/policy
- **Terraform Module:** https://github.com/appvia/tf-aws-rds-postgres
