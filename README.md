# Shadowatch
Insider Threat Detection Platform with Behavior Analytics.


# it-automation-tam-uar-cli

Ref: https://team-turo.atlassian.net/wiki/spaces/IE/pages/2007367753/User+Audit

## Usage

To use this template, link this repo as a template in tf-github.

To set up your repository once it has been created as a children of this
template, just run `./script/bootstrap` and follow the instructions

## Details

### Bootstrap Project
```
$ bash -x script/cli_setup
```

### AWS \ Okta Authorization
Must be a member of Okta Group: **aws_926358765449_aws-it-dev-tam**

### Configure: saml2aws
```
$ saml2aws configure
```
```
? Please choose a provider:  [Use arrows to move, type to filter]
  JumpCloud
  KeyCloak
  NetIQ
> Okta
  OneLogin
  Ping
  PingOne
```
```
? Please choose an MFA  [Use arrows to move, type to filter]
  DUO
  FIDO
  OKTA
> PUSH
  SMS
  SYMANTEC
  TOTP
```
### Complete Prompts
```
? Please choose a provider: Okta
? Please choose an MFA: PUSH
? AWS Profile: <Enter Your Profile Name | example: it_dev>
? URL: https://turo.okta.com/home/amazon_aws/0oa36wps3kKLadhWu357/272
? Username: <Your Okta Username>
? Password: <Your Okta Password>
? Confirm: <Your Okta Password>
```

### Result
```
account {
  DisableSessions: false
  DisableRememberDevice: false
  URL: https://turo.okta.com/home/amazon_aws/0oa36wps3kKLadhWu357/272
  Username: bshort@turo.com
  Provider: Okta
  MFA: PUSH
  SkipVerify: false
  AmazonWebservicesURN: urn:amazon:webservices
  SessionDuration: 3600
  Profile: it_dev
  RoleARN:
  Region:
}
```

### Authenticate saml2aws (Select Role: tam)
```
$ saml2aws login
Using IdP Account default to access Okta https://turo.okta.com/home/amazon_aws/0oa36wps3kKLadhWu357/272
To use saved password just hit enter.
? Username bshort@turo.com
? Password ***

Authenticating as bshort@turo.com ...
? Please choose the role  [Use arrows to move, type to filter]
  Account: relayrides (655631470870) / aws-it-dev-meeseeks
  Account: turo-it-dev (926358765449) / aws-it-dev-read
> Account: turo-it-dev (926358765449) / aws-it-dev-tam
```

### Using Tam
#### CLI: tam
  #### --action audit
    Required Params:
    --profile|-p
    --application|-n
    --csv|-c
    
    Example(s):
    
    $ tam --action audit \
    --profile <saml2aws profile> \
    --application <application_name> \
    --csv <path_to_csv>

    $ tam --action audit \
    --profile it_dev \
    --application test \
    --csv /path/to/csv

  #### --action synchronize
    Required Params:
    --profile|-p
    
    Example(s):
    $ tam --action synchronize --profile <saml2aws profile>
    $ tam --action synchronize --profile it_dev
  #### --action template
    Required Params:
    -application|n

    Example(s):
    $ tam --action template --application <application_name>
