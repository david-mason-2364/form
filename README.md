# Form Submission

A small ColdFusion site that sends GET or POST requests to any URL with your own field names and values, and shows you the response.

Live demo: https://www.trinthlo.com/sites/form

## What it does

- Lets you pick a method (POST or GET), enter a destination URL, and enter up to 10 name/value pairs. Rows with an empty name are skipped.
- Sends the request from the server with `cfhttp`. POST fields go in the body as form fields. GET fields are added to the URL's query string, after any parameters the URL already has.
- Shows the response status, headers and body. HTML responses also get a preview in a sandboxed frame, so the page's scripts, forms and cookies can't run on this site.
- Keeps your entries in the form after each submit so you can change a value and send again.

It's useful for testing APIs and form handlers, reproducing a request, or trying different parameter combinations without writing a form.

## Limits and safety

Because the server makes the request, a public copy of this tool could be used to reach machines on the server's own network. To prevent that:

- Only `http://` and `https://` URLs are accepted.
- Requests to local and private network addresses are refused. This covers `localhost`, `127.0.0.0/8`, `10.0.0.0/8`, `172.16.0.0/12`, `192.168.0.0/16`, `169.254.0.0/16` (including cloud metadata addresses), `100.64.0.0/10` and their IPv6 equivalents. Host names are resolved first, so a name that points to one of these addresses is refused too.
- Redirects aren't followed. A 3xx response is shown with its `Location` header so you can see where it was going.
- Requests time out after 15 seconds.

To test endpoints on your own machine or network, set `application.allowPrivateHosts = true` in `Application.cfc`. Only do this on a copy that isn't reachable from the internet.

ColdFusion's `scriptProtect` setting is on, so in a value containing tags like `<script>` or `<object>`, the tag name is replaced with `InvalidTag` before it's sent. For example, `<script>alert(1)</script>` is sent as `<InvalidTag>alert(1)</script>`.

## Requirements

- Adobe ColdFusion 2016 or later. It may also run on Lucee, but that hasn't been tested.
- HTTPS. The site redirects every http request to `application.urls.secure`.

## Setup

1. Put the folder in your web root, for example `https://localhost/form`.
2. In `Application.cfc`, inside `onApplicationStart`, change `application.urls.normal` and `application.urls.secure` to the address where the site will run (for example `https://localhost/form`). If you skip this step, the https redirect and the page's CSS, JavaScript and images still point to the Trinthlo demo site.
3. Open `index.cfm` in a browser. If you opened the site before changing the URLs, restart ColdFusion first so the new values are loaded.

## Project structure

```
Application.cfc   App settings, SSL redirect, and isPrivateHost()
index.cfm         URL checks, sending the request, the form and the response
layout.cfm        Page layout and footer
assets/           Bootstrap, jQuery, site CSS and images
```

## License

MIT, see [LICENSE](LICENSE).
