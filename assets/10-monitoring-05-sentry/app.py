#!/usr/bin/env python

import sentry_sdk

sentry_sdk.init(
    dsn="https://3a5eeb1598d25b05f63eff48bcb3ad63@o4506031283240960.ingest.sentry.io/4506031294840832",
    traces_sample_rate=1.0,
    profiles_sample_rate=1.0,
    environment="development",
)

try:
    file = open("license.key", "r")
    try:
        license_key = file.readline()
        if len(license_key) == 0:
            raise Exception("Invalid license key")
        
        print("Success")
    finally:
        file.close()
        
except Exception as e:
    sentry_sdk.capture_exception(e)