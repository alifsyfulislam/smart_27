"""Central change-log writer.

Every create / update / soft delete / restore on a master table is recorded in
sm_audit_log by the application ONLY (no triggers needed).
"""
import json
from datetime import datetime

from .database import x


def _clean(row):
    out = {}
    for k, v in (row or {}).items():
        if isinstance(v, datetime):
            v = v.strftime("%Y-%m-%d %H:%M:%S")
        out[k] = v
    return out


def log_change(cid, table_name, record_key, action, old=None, new=None,
               changed_by="-", user_ip="-", note=""):
    try:
        x("""INSERT INTO sm_audit_log
             (cid, table_name, record_key, action, old_values, new_values,
              changed_by, user_ip, note, created_on)
             VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s, NOW())""",
          (cid, table_name, str(record_key), action,
           json.dumps(_clean(old), ensure_ascii=False, default=str) if old else None,
           json.dumps(_clean(new), ensure_ascii=False, default=str) if new else None,
           changed_by, user_ip, note))
    except Exception:
        # audit must never break the business transaction
        pass


def recent(limit=10, table=None, action=None):
    from .database import q
    sql = "SELECT * FROM sm_audit_log WHERE 1=1"
    params = []
    if table:
        sql += " AND table_name=%s"
        params.append(table)
    if action:
        sql += " AND action=%s"
        params.append(action)
    sql += " ORDER BY id DESC LIMIT %s"
    params.append(int(limit))
    return q(sql, params)
