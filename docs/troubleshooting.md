# ❗ Most Common Issues and Solutions (FAQ)

Here you'll find a list of typical problems encountered during BorgTug installation or usage.

1. **Initial Connection Requires Manual Setup**  
   After configuring a new client, the first connections must be established manually because they require fingerprint verification. Without this step, neither manual nor automatic backups will work.

2. **Service Changes Require Reload**  
   After making changes to service/socket/timer files, you must execute:  
   ```console
   sudo systemctl daemon-reload
   ``` 
   to reload the configuration, otherwise the changes won't take effect.