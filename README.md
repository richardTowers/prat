prat - slow, unscalable, centralised revision control system
============================================================

Prat is a reimplementation of Git using Postgresql as the storage layer (instead of the .git directory on the local filesystem) and Ruby (instead of C).

It's a learning exercise. Don't use this in production.

Current status
--------------

Enough of the porcelain commands have been implemented to follow the [Git Internals](https://git-scm.com/book/en/v2/Git-Internals-Git-Objects) tutorial.

I imagine that some / most of the commands are buggy, in the sense that they don't produce the same hashes as git does, and there are more serious bugs with the way I'm doing trees. Still, good enough for government work.

Here's an example session:

```
# Initialise the prat repo
$ ./prat.rb init

# Create a couple of bits of content
$ echo 'test content' | ./prat.rb hash-object
d670460b4b4aece5915caf5c68d12f560a9fe3e4
$ echo 'another bit of content' | ./prat.rb hash-object
e8a9c0279ec4dce5157410ba8f562bc3ebe65b75

# Stage the content and write it to a tree
$ ./prat.rb update-index --add --cacheinfo 100644 d670460b4b4aece5915caf5c68d12f560a9fe3e4 test.txt
$ ./prat.rb update-index --add --cacheinfo 100644 e8a9c0279ec4dce5157410ba8f562bc3ebe65b75 test2.txt
$ ./prat.rb write-tree
8a44325cc616c1a0d6bc6685a2bdfc6eb9e2c086

# Create a commit for the tree we just made
$ echo -n "Initial commit" | ./prat.rb commit-tree 8a44325cc616c1a0d6bc6685a2bdfc6eb9e2c086
7d7c67c02166c3e770146f1b469f9e0e55d02555

# Update one of the bits of content
$ echo 'test content updated' | ./prat.rb hash-object
a80b94aae263eed5d39b1e25c9f6fe7d6df0e323

# Stage it and write it to a tree
$ ./prat.rb update-index --add --cacheinfo 100644 a80b94aae263eed5d39b1e25c9f6fe7d6df0e323 test.txt
$ ./prat.rb write-tree
33ec7ea538b4ae4927d091649621a4ad6ff8c428

# Create a second commit (with the first commit as its parent)
$ echo -n "Second commit" | ./prat.rb commit-tree -p 7d7c67c02166c3e770146f1b469f9e0e55d02555 33ec7ea538b4ae4927d091649621a4ad6ff8c428
034ae35ea1730504e420951abd59f12076983bc3

# Create a main branch pointing at that commit
$ ./prat.rb update-ref main 034ae35ea1730504e420951abd59f12076983bc3

# Check out the log!
$ ./prat.rb log main
commit 034ae35ea1730504e420951abd59f12076983bc3
Author: Richard Towers

    Second commit
commit 7d7c67c02166c3e770146f1b469f9e0e55d02555
Author: Richard Towers

    Initial commit
```

