# Automatic Git Backup #

An easy way of getting automatic time stamped git screenshots of a directory through crontab.

## Getting Started ##

These instructions will get you a directory that is under automatic source control.

### Prerequisites ###

* A static place to store the scripts (so cron can reference them)
* A directory that is git initialized and connected to Github
* A secure way to access Github (ssh/gpg keys)

Clone the repository wherever you keep custom scripts (I recommend `~/bin`)

```bash
$ git clone https://github.com/srydell/auto-git.git
```

Create a directory and initialize it with git.

```bash
$ mkdir important_dir && cd important_dir
$ git init
```

Connect it to Github by [creating a new repository](https://help.github.com/articles/create-a-repo/).

[Generate a key pair](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/) to store on the server. 

### Installing ###

Installing on crontab is as easy as

```bash
$ source=/absolute/path/to/git_backup.sh
$ target_dir=/absolute/path/to/important_dir
$ log_file=/absolute/path/to/auto-git.log
$ { crontab -l; echo "0 * * * * $source $target_dir &>$log_file"; } | crontab -
```

This will run the script once every hour (at \*\*:00), every time the computer is on. Note that `auto-git.log` does not need to exist beforehand. Testing to make sure it works is as simple as checking the logfile after the script has executed once.

```bash
$ cat "$log_file"
```

The script will only push changes if there are any and will time stamp them with `date +%c` to suit every locale.

If you ever need to revert to the last cron run you can run `git_revert.sh /path/to/important_dir` to save where you are as a separate branch, and then move back in time. If you only use this on one directory I suggest to write a small wrapper (see example in the Appendix).

After all of this is done you can relax and enjoy automatic git pushes.

### Why did I build this? ###

My sister is starting her PhD in a field where she usually does not have to interact with computers. However, she, like all of us, need source control. By putting this script on her computer she is guaranteed to only ever lose one hour of work (or however often she wants to push changes).

### Appendix ###

Here is a small wrapper for `git_revert.sh` that can be placed in your `PATH` variable.

```bash
#!/usr/bin/env bash
#
# Wrapper around git_revert.sh for one directory
# Restore backup of directory $dir_under_source_control

dir_under_source_control=/absolute/path/to/important_dir

/absolute/path/to/git_revert.sh "$dir_under_source_control"
```
