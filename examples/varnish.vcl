backend default {
    .host = "127.0.0.1";
    .port = "3040";
}

acl purge {
  "localhost";
}
sub vcl_recv {
    if (req.request == "GET" && req.url ~ "\.css$") {
        unset req.http.cookie;
        return(lookup);
    }
}

sub vcl_fetch {
    if (req.request == "GET" && req.url ~ "\.css)$") {
		beresp.ttl = 31556926s;
        unset beresp.http.set-cookie;
        return(deliver);
    }
}

sub vcl_deliver {
	set resp.http.X-Served-By = server.hostname;
	if (obj.hits > 0) {
		set resp.http.X-Cache = "HIT";
		set resp.http.X-Cache-Hits = obj.hits;
	} else {
		set resp.http.X-Cache = "MISS";
	}
	return (deliver);
}

sub vcl_recv {
  if (req.request == "PURGE") {
    if (!client.ip ~ purge) {
      error 405 "Not allowed.";
    }
    return(lookup);
  }
}

sub vcl_hit {
  if (req.request == "PURGE") {
    set obj.ttl = 0s;
    error 200 "Purged.";
  }
}

sub vcl_miss {
  if (req.request == "PURGE") {
  error 404 "Not in cache.";
  }
}