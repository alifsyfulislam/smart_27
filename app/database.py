"""Database helpers for SSMS (PyMySQL, raw SQL — the schema uses MySQL 8 style
keys like PRIMARY KEY (id DESC) which raw SQL reproduces exactly)."""
import pymysql
import pymysql.cursors

from . import config


def get_conn():
    return pymysql.connect(
        host=config.DB_HOST,
        port=config.DB_PORT,
        user=config.DB_USER,
        password=config.DB_PASS or None,
        database=config.DB_NAME,
        charset="utf8mb4",
        autocommit=True,
        cursorclass=pymysql.cursors.DictCursor,
    )


def q(sql, params=(), one=False):
    """Run a SELECT; return list of dict rows or a single dict/None."""
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            rows = cur.fetchall()
        return (rows[0] if rows else None) if one else rows
    finally:
        conn.close()


def x(sql, params=()):
    """Run an INSERT/UPDATE/DELETE; return (lastrowid, rowcount)."""
    conn = get_conn()
    try:
        with conn.cursor() as cur:
            cur.execute(sql, params)
            return cur.lastrowid, cur.rowcount
    finally:
        conn.close()


def scalar(sql, params=(), default=None):
    row = q(sql, params, one=True)
    if not row:
        return default
    return list(row.values())[0]


def db_alive():
    try:
        get_conn().close()
        return True
    except Exception:
        return False
