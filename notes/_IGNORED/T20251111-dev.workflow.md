# 🧭 Simuleos-lab Development Workflow

This guide explains how our GitHub repositories are managed and how to contribute changes correctly under **Terraform-enforced branch protection**.  
By following these steps, we keep all code reviewed, traceable, and stable.

---

## ⚙️ Overview

We use **Terraform** to manage GitHub settings:
- Protects `main` from direct pushes or accidental deletion.
- Requires at least one review before merging.
- Dismisses stale reviews if new commits are pushed.
- Enforces linear history and conversation resolution.

This setup applies to **all repositories listed in Terraform** under `repositories`.

---

## 👩‍💻 Daily Workflow

### 1. Update your local `main`
```bash
git checkout main
git pull origin main
````

### 2. Create a new feature branch

```bash
git checkout -b feat/my-feature
```

Use short, descriptive names (`fix/`, `feat/`, `docs/`, etc.).

### 3. Make and commit your changes

```bash
git add .
git commit -m "feat: explain what this change does"
```

### 4. Push your branch

```bash
git push -u origin feat/my-feature
```

### 5. Open a Pull Request (PR)

* Go to GitHub and create a PR from your branch → `main`.
* Fill the PR template (see below).
* Request a review from another team member.

### 6. Respond to feedback

* Resolve comments.
* Push updates as needed:

  ```bash
  git push
  ```

  > ⚠️ Approvals reset automatically when you push new commits.

### 7. Merge

Once all checks pass and one review approves:

* Click **“Squash and merge”** (keeps history linear).
* Optionally delete the branch (GitHub can do this automatically).

### 8. Sync your local repo

```bash
git checkout main
git pull origin main
```

---

## 🚫 What you *cannot* do

* Push directly to `main`
* Force-push `main`
* Delete `main`
* Merge without a review
* Merge with unresolved PR comments

These are intentional guardrails for safe, collaborative development.

---

## 🧪 Keeping your branch up to date

If someone merged changes into `main` while you worked:

```bash
git fetch origin
git rebase origin/main
git push --force-with-lease
```

> Force-pushing is allowed on **your own feature branches**, not `main`.

---

## ✅ Example Flow

```bash
# Create branch
git checkout -b feat/add-plot-function

# Code and commit
git commit -am "feat: add new plotting function for analysis"

# Push and open PR
git push -u origin feat/add-plot-function

# After review and approval
git checkout main
git pull origin main
git branch -d feat/add-plot-function
```

---

## 🧰 Recommended Conventions

* Use **Conventional Commits** (`feat:`, `fix:`, `docs:`, `refactor:`).
* Keep PRs small and focused.
* Always review at least one teammate’s PR per week.
* Use **Draft PRs** for work-in-progress (early feedback without blocking `main`).

---

## 🏗️ Future Improvements

### 1. **CODEOWNERS**

Auto-assign reviewers for specific files or modules.

Example `.github/CODEOWNERS`:

```
# Core team owns everything
*       @Simuleos-lab/core

# Specific modules
src/data/     @Simuleos-lab/data
src/analysis/ @Simuleos-lab/analysis
```

Then, in Terraform, you can enable:

```hcl
required_pull_request_reviews {
  require_code_owner_reviews = true
}
```

---

### 2. **Pull Request Template**

Helps standardize PRs and avoid missing info.

Example `.github/pull_request_template.md`:

```markdown
## Summary
Explain what this PR does.

## Changes
- [ ] Code follows project conventions
- [ ] Tests added or updated
- [ ] Documentation updated (if applicable)

## Related Issues
Closes #
```

GitHub will automatically show this template when creating PRs.

---

### 3. **Status Checks**

Once CI workflows exist, add them to Terraform:

```hcl
required_status_checks {
  strict   = true
  contexts = ["ci/test", "lint"]
}
```

That ensures merges only happen when tests pass and branches are up-to-date.

---

### 4. **Automation Token (Optional)**

Later, we’ll create a dedicated bot user (`simuleos-bot`) with its own token, so automation runs independently of personal accounts.

---

### 5. **Labels & Issue Templates**

Terraform can also create standard issue labels across repos:

* `bug`, `enhancement`, `docs`, `question`
  And you can add `.github/ISSUE_TEMPLATE` files to guide issue creation.

### 6. **Continuous Integration (CI) with GitHub Actions**

Automated checks are an essential next step once branch protection is in place.  
CI runs tests, linting, and style checks automatically on every Pull Request, helping ensure that reviewed code actually *works* before merging.


---

## 🧩 Terraform Maintenance

* To apply updates to all repos:

  ```bash
  terraform plan  -var-file=auth.simuleos.tfvars
  terraform apply -var-file=auth.simuleos.tfvars
  ```
* Add new repositories to `variables.public.auto.tfvars`.
* Don’t commit your `auth.*.tfvars` (contains your personal token).

---

### 🪶 In summary

**Workflow principle:**

> Everyone codes in branches → submits PR → gets a review → merges cleanly.

This guarantees:

* Clean history
* Reviewed code
* Safe collaboration

---

© Simuleos-lab — *Collaborative reproducibility through infrastructure as code.*
