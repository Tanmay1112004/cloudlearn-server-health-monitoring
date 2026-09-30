# CloudLearn — Linux Server Health Monitoring

## Project Overview
A Linux server monitoring project built on AWS EC2 using Bash scripting and cron.

The script monitors memory, disk usage, Apache service status, and website availability. It generates health reports and logs them automatically every five minutes.

## Tech Stack
- AWS EC2 — Amazon Linux 2023
- Linux and Bash
- Apache HTTP Server
- Cron
- curl, free, df, systemctl

## Architecture

AWS EC2 (Amazon Linux 2023)
        |
        v
  health_check.sh
        |
        +--> Memory check
        +--> Disk usage check
        +--> Apache service check
        +--> Website HTTP check
        |
        v
 Overall Health Status
        |
        v
 health.log (every 5 minutes)

## Features
- Monitors available memory percentage.
- Warns when available memory is below 15%.
- Warns when root disk usage reaches 80%.
- Checks Apache service status.
- Verifies website availability using HTTP status code.
- Reports HEALTHY, WARNING, or CRITICAL.
- Uses cron to run every five minutes.
- Stores reports in a log file.

## Cron Schedule

```cron
*/5 * * * * /home/ec2-user/health_check.sh >> /home/ec2-user/health-logs/health.log 2>&1

---

