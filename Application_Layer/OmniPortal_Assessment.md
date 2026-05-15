# OMNI-PORTAL ASSESSMENT REPORT
**Operator:** **Deadline:** April 5 @ 11:59 PM 

## PHASE 1: AUTH BYPASS (SQLi)
* **Payload Used:** ' OR 1=1 --
* **Result:** Successfully bypassed login and obtained 'auth_token' cookie.

## PHASE 2: CLIENT-SIDE HIJACK (XSS)
* **Stored XSS Payload:** http://127.0.0.1:8090/support
* **Secret Cookie Captured:** auth_token=SUPPORT_TIER_1_SECRET_TOKEN
## PHASE 3: API ENUMERATION (BOLA)
* **Insecure Order ID:** 501
* **Confidential Data Leaked:** {"amount":"$15,000.00","details":"Confidential Server Lease","order_id":501}

## PHASE 4: THE REMEDIATION
* **Fix for SQLi:**Parameterized Queries, this  treats user input as data only, never as executable code.
 **Fix for XSS:** Implement Output Encoding. Convert characters like < and > into HTML entities (like &lt;) so the browser displays them as text instead of running them as script.
* **Fix for API BOLA:** Implement Object-Level Authorization. The server must check if the User_ID of the person making the request matches the Owner_ID of the specific order being requested.
