upstream vm_doc_backend {
    server IP_VM_DOC:9080;
    keepalive 32;
}

server {
    listen 443 ssl;
    http2 on;

    server_name vm-doc.domeniu.ro;

    ssl_certificate     /cale/certificat/fullchain.pem;
    ssl_certificate_key /cale/certificat/privkey.pem;

    ssl_protocols TLSv1.2 TLSv1.3;

    client_max_body_size 32m;

    location / {
        proxy_pass http://vm_doc_backend;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto https;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Port 443;

        proxy_set_header Connection "";

        proxy_connect_timeout 10s;
        proxy_send_timeout 90s;
        proxy_read_timeout 90s;
    }
}

server {
    listen 80;
    server_name vm-doc.domeniu.ro;

    return 301 https://$host$request_uri;
}
