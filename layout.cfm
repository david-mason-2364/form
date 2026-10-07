<cfoutput>
	<!DOCTYPE html>
	<html lang="en">
		<head>
			<meta charset="utf-8" />
			<meta http-equiv="X-UA-Compatible" content="IE=edge" />
			<meta name="viewport" content="width=device-width, initial-scale=1" />
			<title>Form Submission</title>
			<meta name="description" content="Web-based form submission tool that sends GET or POST requests to any URL, allowing developers to test endpoints, APIs, and server-side form handling." />
			<meta name="keywords" content="form submission tool, HTTP GET POST tester, web form testing, API testing utility, form data simulator, endpoint testing, developer debugging tool, HTTP request tester" />
			<link href="#request.urlBase#/assets/css/bootstrap.5.3.3.min.css" rel="stylesheet" />
			<link href="#request.urlBase#/assets/css/default.css" rel="stylesheet" />
			<link href="#request.urlBase#/assets/images/favicon.png" type="image/x-icon" rel="shortcut icon" />
			<link href="#request.urlBase#/assets/images/favicon.png" rel="apple-touch-icon" />
			<script src="#request.urlBase#/assets/js/jquery.3.7.1.min.js"></script>
			<script src="#request.urlBase#/assets/js/bootstrap.5.3.3.min.js"></script>
		</head>
		<body>
			<header>
				<div class="container">
				</div>
			</header>
			<main>
				<div class="container">
					<cfif isDefined("session.message")>
						<div class="alert alert-success">#htmlEditFormat(session.message)#</div>
						<cfset structDelete(session, "message") />
					</cfif>
					#request.pageContent#
				</div>
			</main>
			<footer>
				<div class="container">
					<hr />
					<p>Copyright &copy; #year(now())#. <a href="https://www.trinthlo.com" target="_blank" title="Trinthlo">Trinthlo</a>. All Rights Reserved.</p>
					<p><a href="https://www.trinthlo.com" target="_blank"><img src="#request.urlBase#/assets/images/logo.png" alt="Trinthlo" title="Trinthlo" class="logo" /></a></p>
				</div>
			</footer>
		</body>
	</html>
</cfoutput>