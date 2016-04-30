# Matrix Notification Resource for Concourse CI

Send notification messages to [Matrix](http://matrix.org) using a string message or templated message.

This resource borrows heavily from the [Slack notification resource](https://github.com/cloudfoundry-community/slack-notification-resource). Usage and behavior around text and text_file parameters should be handled exactly the same as in that.

## Installing

```
resource-types:
- name: matrix-notification-resource
  type: docker-image
  source:
    repository: freelock/matrix-notification-resource
```

## Registering with Matrix

This resource needs an access token for a valid user account. It will not create the user account for you, or retrieve the token.

To get a token, first create a Matrix user account on your homeserver of choice. Then you can use Curl to get an access token for the account:

```
curl -XPOST -d '{"type":"m.login.password", "user":"example", "password":"wordpass"}' "http://matrix.org/_matrix/client/api/r0/login"

{
    "access_token": "QGV4YW1wbGU6bG9jYWxob3N0.vRDLTgxefmKWQEtgGd",
    "home_server": "matrix.org",
    "user_id": "@example:matrix.org"
}
```

... add the returned access_token to the resource.

Then, a user will need to invite the account to the appropriate room, and the account will need to accept the invitation.

## Source Configuration

* `matrix_server_url`: *Required.* Example: https://matrix.org
* `token`: *Required.* token to authenticate with Matrix server
* `room_id`: *Required.* The room to send notifications to -- this account must already be a member of this room.

Pull requests accepted for room_alias, user logins, auto-joins.

#### `out`: Sends message to Matrix room

Send message to specified Matrix Room, with the configured parameters

#### Parameters
* `text`: (string) Text to send to the Matrix room
* `text_file`: (string) File containing text to send to the Matrix room
* `msgtype`: *Optional.* Message type, m.notice, m.text (default: m.notice)

## Example

### Check
```
---
resources:
- name: matrix-notification
  type: matrix-notification-resource
  source:
    matrix_server_url: https://matrix.org
    token: {{matrix_token}}
    room_id: {{matrix_room_id}}
```

### In

*Not supported*

### Out

```
---
---
  - put: matrix-notification
    params:
      text_file: results/message.txt
      text: |
        The build had a result. Check it out at:
        http://my.concourse.url/pipelines/$BUILD_PIPELINE_NAME/jobs/$BUILD_JOB_NAME/builds/$BUILD_NAME
        or at:
        http://my.concourse.url/builds/$BUILD_ID

        Result: $TEXT_FILE_CONTENT
```
