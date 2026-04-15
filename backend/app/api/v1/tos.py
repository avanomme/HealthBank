# generated with chatgpt
from fastapi import APIRouter, Depends, Request
import ipaddress
from ...utils.utils import get_db_connection
from ..deps import get_current_user
import os

router = APIRouter()

CURRENT_TOS_VERSION = os.getenv("CURRENT_TOS_VERSION")

def ip_to_varbinary(ip: str | None) -> bytes | None:
    if not ip:
        return None
    try:
        return ipaddress.ip_address(ip).packed
    except ValueError:
        return None

@router.post("/accept")
async def accept_tos(request: Request, user=Depends(get_current_user)):
    ip = request.headers.get("x-forwarded-for", "").split(",")[0].strip() or (request.client.host if request.client else None)
    ip_bin = ip_to_varbinary(ip)

    conn = get_db_connection()
    cur = conn.cursor()
    cur.execute(
        """
        UPDATE AccountData
        SET TosAcceptedAt = UTC_TIMESTAMP(),
            TosVersion = %s,
            TosAcceptedIp = %s
        WHERE AccountID = %s
        """,
        (CURRENT_TOS_VERSION, ip_bin, user["account_id"]),
    )
    conn.commit()
    cur.close()
    conn.close()

    return {"accepted": True, "version": CURRENT_TOS_VERSION}
