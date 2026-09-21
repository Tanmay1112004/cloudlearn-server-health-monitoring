cat > docs/architecture.md <<'EOF'
# Project Architecture

## Workflow

1. AWS EC2 runs Amazon Linux 2023.
2. Cron executes health_check.sh every five minutes.
3. The script checks memory, root disk usage, Apache, and website HTTP status.
4. Each check produces a health status.
5. The script calculates an overall status.
6. Output is appended to health.log.

## Architecture Diagram

```text
             AWS EC2
       Amazon Linux 2023
                 |
                Cron
          (Every 5 minutes)
                 |
          health_check.sh
                 |
     +-----------+-----------+
     |           |           |
   Memory       Disk       Apache
     |           |           |
     +-----------+-----------+
                 |
          Website HTTP Check
                 |
          Overall Status
                 |
              health.log
