backend default {
  .host = "127.0.0.1";
  .port = "8888";
}
 
backend eventpub {
  .host = "sports-event-api.mdev.brand--x.com";
  .port = "80";
  .connect_timeout = 10s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 10s;
}
 
backend betcapture {
  .host = "sports-bet-api.mdev.brand--x.com";
  .port = "80";
  .connect_timeout = 10s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 10s;
}
 
backend services {
  .host = "website-api.mdev.esportz.com";
  .port = "80";
  .connect_timeout = 10s;
  .first_byte_timeout = 60s;
  .between_bytes_timeout = 10s;
}
 
backend results {
  .host = "results-service-1.ldev.brand--x.com";
  .port = "8080";
}
 
sub vcl_recv {
  if (req.http.host ~ "bovada.lv") {
    set req.http.X-SiteId = "10";
  } else if (req.http.host ~ "slots.lv") {
    set req.http.X-SiteId = "12";
  } else if (req.http.host ~ "bodog.eu") {
    set req.http.X-SiteId = "4";
  }
 
 
  set req.http.X-Requested-Domain = req.http.host;
 
  if (req.url ~ "^/api/event/")
  {
    set req.backend = eventpub;
    set req.http.X-Forwarded-Host = req.http.host;
    set req.http.X-Forwarded-Host = regsuball(req.http.X-Forwarded-Host, "local\.ldev.", "mdev.");
    set req.http.X-Forwarded-Host = regsuball(req.http.X-Forwarded-Host, "_YOUR_USER_NAME_\.ldev.", "mdev.");
    set req.http.Cookie = regsuball(req.http.Cookie, "local\.ldev\.", "mdev.");
    set req.http.Cookie = regsuball(req.http.Cookie, "_YOUR_USER_NAME_\.ldev\.", "mdev.");
    set req.http.host = "sports-event-api.mdev.brand--x.com";
    set req.http.connection = "close";
    return(pass);
  }
  if (req.url ~ "^/api/bet/")
  {
    set req.backend = betcapture;
    set req.http.X-Forwarded-Host = req.http.host;
    set req.http.X-Forwarded-Host = regsuball(req.http.X-Forwarded-Host, "local\.ldev.", "mdev.");
    set req.http.X-Forwarded-Host = regsuball(req.http.X-Forwarded-Host, "_YOUR_USER_NAME_\.ldev.", "mdev.");
    set req.http.Cookie = regsuball(req.http.Cookie, "local\.ldev\.", "mdev.");
    set req.http.Cookie = regsuball(req.http.Cookie, "_YOUR_USER_NAME_\.ldev\.", "mdev.");
    set req.http.host = "sports-bet-api.mdev.brand--x.com";
    set req.http.connection = "close";
    return(pass);
  }
  if (req.url ~ "^/services/api")
  {
    set req.http.host = regsuball(req.http.host, "local\.ldev\.", "mdev.");
    set req.http.host = regsuball(req.http.host, "_YOUR_USER_NAME_\.ldev\.", "mdev.");
    set req.http.X-Forwarded-Host = req.http.host;
    set req.http.Cookie = regsuball(req.http.Cookie, "local\.ldev\.", "mdev.");
    set req.http.Cookie = regsuball(req.http.Cookie, "_YOUR_USER_NAME_\.ldev\.", "mdev.");
    set req.backend = services;
    set req.http.connection = "close";
    return(pass);
  }
  if (req.url ~ "^/api/results/")
  {
    set req.backend = results;
    set req.url = regsub(req.url, "^/api/results/", "/");
    set req.http.connection = "close";
    return(pass);
  }
}
