def get_client_ip(req):
    xff = req.headers.get('X-Forwarded-For', None)
    if xff:
        ip = xff.split(',')[0].strip()
        if ip:
            return ip
    xr = req.headers.get('X-Real-IP', None)
    if xr:
        return xr.strip()
    return req.remote_addr or ''