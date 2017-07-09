# Copy

Copy one volume to another.

For example: 

```
docker run --rm -v "redmine-data:/src:ro" -v "redmine-data-backup:/dst" copy
```
