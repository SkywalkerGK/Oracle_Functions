
คำสั่งตัด String SQL Oracle แบบพื้นฐาน

select substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)) from dual;

substr(string,start,length)

- instr(NASPORTID,' ') คือ เลขตำแหน่งของ Stringใน  ' '
- length(NASPORTID) คือ ความยาวของ String 
- สามารถเติม +1 +2 -1 -2 ต่อท้ายได้
- ต่อ String ด้วย  || 


-- Query เช็ค Nasportid ที่ไม่ตกเงื่อนไข

select username,auth,SUBSTR(acctsessionid,0,7) as Bras,acctstarttime,nasportid,TT_MIMS.FN_GETGROUP_NASPORTID(nasportid) as SN
    from tbl_acct
    where  acctstoptime = to_date('01-01-1800 00:00:00','DD-MM-YYYY HH24:MI:SS') 
    and username <> 'default@3bb' and SUBSTR(USERNAME,INSTR(USERNAME,'@')+1) not in ('is')
    and TT_MIMS.FN_GETGROUP_NASPORTID(nasportid) = 'Other-slot';

FN ที่ Return ค่าจาก Nasportid

- FN_GETGROUP_NASPORTID
- FN_GET_NODE_SLOT_PORT_NUMBER
- FN_GET_NODE_OLT_SN
- FN_GET_NODE_OLT_NAME
