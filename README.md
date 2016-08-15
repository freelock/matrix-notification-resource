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
* `msgtype`: Used to post a custom message type e.g. if you want to attach a json blob. If set to anything other than m.notice, the resource will attach a "build" json object containing the build metadata info. Defaults to `m.notice`, can be overridden by the put resource.
* `data_file`: *Optional.* (string) Default file to post to the data key of a custom message type. The contents of this file is generally assumed to be a JSON-encoded string. Can be overridden in the job parameters.


Pull requests accepted for room_alias, user logins, auto-joins.

#### `out`: Sends message to Matrix room

Send message to specified Matrix Room, with the configured parameters

#### Parameters
* `text`: (string) Text to send to the Matrix room as the content.body.
* `text_file`: (string) File containing text to send to the Matrix room as the content.body.
* `msgtype`: *Optional.* Message type, m.notice, m.text (default: m.notice)
* `data_file`: *Optional.* (string) Filename to post using a custom_event message type. If unset, defaults to the data_file on the resource.
* `always_notify`: If true, send a notice even if text_file and data_file are empty. If false, and a text_file is specified but empty, a notification will not be sent.

## Example

### Resources
```
---
resources:
- name: matrix-notification
  type: matrix-notification-resource
  source:
    matrix_server_url: https://matrix.org
    token: {{matrix_token}}
    room_id: {{matrix_room_id}}
    data_file: data
```

### Check

*Not supported*

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
