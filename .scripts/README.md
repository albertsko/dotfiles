## Absolute path

```sh
echo $(realpath "${BASH_SOURCE[0]:-${(%):-%x}}")
```
