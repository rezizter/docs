# List of Ansible Errors with Solutions

## Error
objc[50352]: +[__NSCFConstantString initialize] may have been in progress in another thread when fork() was called. We cannot safely call it or ignore it in the fork() child process. Crashing instead. Set a breakpoint on objc_initializeAfterForkError to debug.
ERROR! A worker was found in a dead state

## Solution

```bash
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

source ~/.zshrc
```


