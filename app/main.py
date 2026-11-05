"""SSMS — Secondary Sales Management System (FastAPI web app)."""
from datetime import datetime, timezone

from fastapi import FastAPI, HTTPException, Request
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates
from starlette.middleware.sessions import SessionMiddleware
from starlette.responses import RedirectResponse
from starlette.status import HTTP_303_SEE_OTHER

from . import config
from .ctx import current_user, require_perm, set_flash
from .modules import MODULES

app = FastAPI(title=f"{config.APP_NAME} — {config.APP_FULL_NAME}", version=config.VERSION)

templates = Jinja2Templates(directory="app/templates")
templates.env.globals["APP_NAME"] = config.APP_NAME
templates.env.globals["APP_FULL_NAME"] = config.APP_FULL_NAME
templates.env.globals["VERSION"] = config.VERSION
templates.env.globals["MODULES"] = MODULES
templates.env.globals["max"] = max
templates.env.globals["min"] = min


def _page(request, title, message, status):
    return templates.TemplateResponse(request, "error.html", {
        "request": request, "title": title, "message": message,
        "user": current_user(request), "path": request.url.path,
        "app_name": config.APP_NAME, "app_full_name": config.APP_FULL_NAME,
        "version": config.VERSION,
    })


def forbidden(request):
    return _page(request, "403 — Forbidden",
                 "You do not have permission to access this module.", 403)


def not_found(request):
    return _page(request, "404 — Not Found", "The page you requested does not exist.", 404)


app.state.forbidden = forbidden


@app.exception_handler(HTTPException)
async def http_exc_handler(request: Request, exc: HTTPException):
    if exc.status_code == 404:
        return not_found(request)
    if exc.status_code == 403:
        return forbidden(request)
    return _page(request, f"Error {exc.status_code}", exc.detail or "Unexpected error.",
                 exc.status_code)


app.mount("/static", StaticFiles(directory="app/static"), name="static")

# routers
from .routers import acl_admin, core, crud  # noqa: E402

app.include_router(core.router)
app.include_router(acl_admin.router)   # before crud: /users,/roles,... must not fall into /{slug}
app.include_router(crud.router)


@app.middleware("http")
async def auth_gate(request: Request, call_next):
    path = request.url.path
    public = ("/login", "/static", "/favicon", "/error")
    if not any(path.startswith(p) for p in public):
        user = current_user(request)
        if user is None:
            url = f"/login?next={path}"
            return RedirectResponse(url, status_code=HTTP_303_SEE_OTHER)
    return await call_next(request)


# SessionMiddleware must be added AFTER auth_gate so it wraps it
# (later-registered middleware runs first and makes request.session available).
app.add_middleware(SessionMiddleware, secret_key=config.SECRET_KEY,
                   session_cookie="ssms_session", max_age=config.SESSION_MAX_AGE)


@app.on_event("startup")
async def startup_bootstrap():
    """Auto-create schema + seed the first time the app boots."""
    from scripts.setup_database import ensure_database, seed
    import logging
    try:
        ensure_database()
        seed()
        logging.getLogger("uvicorn.error").info("DB bootstrap OK (smart_27).")
    except Exception as e:  # app still boots, pages show the error
        logging.getLogger("uvicorn.error").error(f"DB bootstrap failed: {e}")


templates.env.globals["now_year"] = datetime.now(timezone.utc).year
