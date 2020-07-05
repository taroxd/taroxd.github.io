---
title: OneDrive 个人保管库离线备份（PC）
---

来自自己的需求，以及[我在 reddit 上的回复](https://www.reddit.com/r/onedrive/comments/gcxnaz/offline_backup_for_personal_vault/fwvxzjd/)。

1. Unlock the vault when you are online.
2. Open disk management tool (Press Win+R and enter 'diskmgmt.msc' without the quotes). You should see a partition called 'OneDrive Personal Vault'.
3. Assign a drive letter to OneDrive Personal Vault. See <https://docs.microsoft.com/en-us/windows-server/storage/disk-management/change-a-drive-letter>. I will assume that the letter is O in the following steps.
4. Start command line prompt as administrator.
5. Run the command 'manage-bde -protectors -add O: -pw' (change O to the letter assigned in Step 3). This allows unlocking the partition in the vhdx file with a password. For more options, run 'manage-bde -protectors -add -?' and read the output message.
6. When you need to unlock the vault offline later, open `C:\OneDriveTemp`, find the vhdx file that contains the vault and unlock the partition inside with the password set in Step 5. When unlocking the vault online as usual, be sure **NOT** to mount the vhdx file, or you will encounter an error message when unlocking.

Important note: this method is not officially supported. Make a backup before performing these steps.
