# Assignment 1

This Python code is a low-level command-line web diagnostic tool (written in Python 2 syntax) that analyzes a given web server's headers and protocols. Instead of using a high-level library like requests, it builds raw network sockets from scratch to communicate with web servers.

Here is a summary of what the script does:

### 1. Protocol Verification (HTTP/2 Check)
Before making its primary request, the script executes a standalone handshake (check_http2) via TLS Application-Layer Protocol Negotiation (ALPN). It queries the target server to see if it supports the HTTP/2 protocol or defaults to HTTP/1.1, storing the result for the final summary.

### 2. URL Parsing & Socket Connection
When processing the input URL, the script:
- Normative checks the string and prepends http:// if a scheme is missing.
- Extracts the hostname, network port (80 for HTTP, 443 for HTTPS), and query path.
- Resolves the domain name to an IP address via DNS lookup and opens a low-level TCP stream socket connection. If the URL requires HTTPS, it wraps the connection using an SSL/TLS context wrapper.

### 3. HTTP Request & Automated Redirect Handling
It constructs a raw, string-formatted GET request header and pushes it across the socket channel. It then isolates the incoming HTTP response headers.
- Recursion Limit: If it encounters an HTTP status code 301 (Moved Permanently) or 302 (Found), it parses out the Location: header and recursively triggers the connection again.
- It strictly limits this daisy-chain process to 5 maximum redirects to prevent infinite network loops.

### 4. Metadata Extraction & Reporting
Once it reaches the final destination page, it slices the raw data packet to separate the headers from the webpage body (which it discards). It prints a diagnostic breakdown to the terminal featuring:
- The raw server response headers.
- Authentication status: Confirms if the page is password-protected by checking for a 401 Unauthorized status code.
- Cookie tracking: Scans the metadata for Set-Cookie: strings and builds an array to display individual cookie names, domain scopes, and expiration dates.
