<cfscript>

	// Define variables
	param name = "form.m" default = "post";
	param name = "form.dest" default = "";
	for (i = 1; i le 10; i++) {
		n = right("00#i#", 2);
		param name = "form.f#n#" default = "";
		param name = "form.v#n#" default = "";
	}
	errorMessage = "";
	results = {};
	body = "";

	// Prepare variables
	form.m = iif(listFindNoCase("post,get", form.m) eq 0, de("post"), "form.m");
	form.dest = trim(form.dest);

	// Form submitted
	if (cgi.request_method eq "POST") {

		// Validate destination url (http/https only, and no local or private network addresses unless allowed)
		// Note:  the function isPrivateHost is a custom function located in Application.cfc
		try {
			tmp = createObject("java", "java.net.URL").init(form.dest);
			if (! listFindNoCase("http,https", tmp.getProtocol()) or ! len(tmp.getHost())) errorMessage = "Please enter a URL that starts with http:// or https://.";
			else if (! application.allowPrivateHosts and isPrivateHost(tmp.getHost())) errorMessage = "Requests to local or private network addresses are not allowed.";
		} catch (Any e) {
			errorMessage = "Please enter a valid URL that starts with http:// or https://.";
		}

		// Submit form (redirects are not followed so a redirect can't be used to reach a blocked address)
		if (! len(errorMessage)) {
			try {
				cfhttp(method = form.m, url = form.dest, redirect = false, timeout = 15, result = "results") {
					fieldCount = 0;
					for (i = 1; i le 10; i++) {
						n = right("00#i#", 2);
						if (len(trim(form["f#n#"]))) {
							cfhttpparam(type = iif(form.m eq "get", de("url"), de("formfield")), name = trim(form["f#n#"]), value = form["v#n#"]);
							fieldCount++;
						}
					}
					// A POST needs at least one parameter, so send an empty body when no fields were entered
					if (form.m eq "post" and fieldCount eq 0) cfhttpparam(type = "body", value = "");
				}
				body = iif(isBinary(results.fileContent), de("[Binary content, #len(results.fileContent)# bytes]"), "results.fileContent");
			} catch (Any e) {
				errorMessage = "The request could not be completed: #e.message#";
			}
		}

	}

</cfscript>

<cfoutput>

	<h1>Form Submission</h1>

	<p>
		This project is a simple web-based utility designed to send form data to any specified endpoint using either the GET or POST method.
		The interface allows users to define a destination URL, choose the request method, and enter custom field names and values that will
		be included in the request. This makes it easy to simulate form submissions without needing to build a full front-end form or write
		additional code. The tool is useful during development and debugging when testing APIs, verifying server-side form handling,
		reproducing request payloads, or experimenting with different parameter combinations. By providing a quick way to construct and
		send requests, it helps developers validate endpoints, troubleshoot integrations, and confirm how applications respond to various
		input scenarios.
	</p>

	<p><br /></p>

	<div class="row">
		<div class="col-md-6">

			<form method="post" action="index.cfm">

				<div class="row g-3 mb-2">
					<div class="col-md-12">
						<select name="m" id="m" class="form-select">
							<option value="post"<cfif form.m eq "post"> selected</cfif>>POST</option>
							<option value="get"<cfif form.m eq "get"> selected</cfif>>GET</option>
						</select>
					</div>
				</div>

				<div class="row g-3 mb-2">
					<div class="col-md-12">
						<input type="text" name="dest" id="dest" value="#htmlEditFormat(form.dest)#" class="form-control" placeholder="URL" />
					</div>
				</div>

				<cfloop index="i" from="1" to="10">
					<cfset n = right("00#i#", 2) />
					<div class="row g-3 mb-2">
						<div class="col-md-6">
							<input type="text" name="f#n#" id="f#n#" value="#htmlEditFormat(form["f#n#"])#" class="form-control" placeholder="Name" />
						</div>
						<div class="col-md-6">
							<input type="text" name="v#n#" id="v#n#" value="#htmlEditFormat(form["v#n#"])#" class="form-control" placeholder="Value" />
						</div>
					</div>
				</cfloop>

				<input type="submit" value="Submit" class="btn btn-primary" />
				<a href="index.cfm" class="btn btn-primary">Reset</a>

			</form>

		</div>
	</div>

	<cfif cgi.request_method eq "POST">

		<h2>Response</h2>

		<cfif len(errorMessage)>

			<div class="alert alert-danger">#htmlEditFormat(errorMessage)#</div>

		<cfelse>

			<p><strong>Status:</strong> #htmlEditFormat(results.statusCode)#</p>

			<h3>Headers</h3>
			<pre class="response">#htmlEditFormat(results.header)#</pre>

			<h3>Body</h3>
			<pre class="response">#htmlEditFormat(body)#</pre>

			<!--- The preview is sandboxed so the response's scripts, forms and cookies can't run on this site --->
			<cfif findNoCase("html", results.mimeType) and ! isBinary(results.fileContent)>
				<h3>Preview</h3>
				<iframe sandbox srcdoc="#htmlEditFormat(body)#" class="preview" title="Response preview"></iframe>
			</cfif>

		</cfif>

	</cfif>

</cfoutput>
