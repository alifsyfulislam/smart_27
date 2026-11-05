"""SSMS application configuration.

DB_Connection (from requirements):
  host: localhost, username: root, password: NULL, database: smart_27
Values can be overridden with environment variables.
"""
import os

APP_NAME = "SSMS"
APP_FULL_NAME = "Secondary Sales Management System"
VERSION = "1.0.0"
CID = "SMART"  # default company id used everywhere

DB_HOST = os.environ.get("SSMS_DB_HOST", "localhost")
DB_PORT = int(os.environ.get("SSMS_DB_PORT", "3306"))
DB_USER = os.environ.get("SSMS_DB_USER", "root")
DB_PASS = os.environ.get("SSMS_DB_PASS", "")          # password: NULL
DB_NAME = os.environ.get("SSMS_DB_NAME", "smart_27")

SECRET_KEY = os.environ.get("SSMS_SECRET_KEY", "ssms-change-me-secret-key")
SESSION_MAX_AGE = 60 * 60 * 8  # 8 hours

DEFAULT_ADMIN_USER = "admin"
DEFAULT_ADMIN_PASSWORD = "admin123"

UPLOAD_CHUNK = 1000
PAGE_SIZE_DEFAULT = 10
