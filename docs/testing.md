cd ~/cloudlearn-server-health-monitoring

cat > docs/testing.md <<'EOF'
# Testing and Validation

## Environment
- Platform: AWS EC2
- OS: Amazon Linux 2023
- Monitoring: Bash script + cron
- Script: health_check.sh

## Test Cases

| Test | Expected Result | Actual Result |
|---|---|---|
| Normal server health | HEALTHY | PASS |
| Apache stopped | CRITICAL detected | PASS |
| Apache restarted | HEALTHY | PASS |
| Website responds | HTTP 200 | PASS |
| Cron execution | Reports logged periodically | PASS |
| Memory threshold test | WARNING | PASS |
| Disk threshold test | WARNING | PASS |
| Combined threshold test | Overall WARNING | PASS |

## Threshold Test Details

A temporary copy of the monitoring script was used to trigger warning conditions without creating actual resource pressure.

- Memory threshold was temporarily changed from 15% to 99%.
- Disk threshold was temporarily changed from 80% to 1%.
- The test copy reported memory and disk warnings.
- Overall status correctly changed to WARNING.
- Apache remained HEALTHY.
- Website returned HTTP 200.
- The temporary test script was removed after testing.

The production script and cron configuration were not changed during this test.

## Cron Configuration

```cron
*/5 * * * * /home/ec2-user/health_check.sh >> /home/ec2-user/health-logs/health.log 2>&1
