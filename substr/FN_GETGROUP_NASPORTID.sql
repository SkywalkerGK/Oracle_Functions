create or replace FUNCTION         FN_GETGROUP_NASPORTID 
(
  NASPORTID IN VARCHAR2 
) RETURN VARCHAR2 AS 

t_hf_port varchar2(100);
t_b_port varchar2(64);
t_a_port varchar2(64);
t_port_group varchar2(64);


BEGIN

    if NASPORTID is null then
        t_port_group := '-';
    elsif substr(NASPORTID,0,2)  = 'HF' then
        select substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)) into t_hf_port from dual;
    
        if substr(t_hf_port,0,4) = 'xpon'  then
            t_port_group :=  'FTTX-Huawei';
        elsif substr(t_hf_port,0,3) = 'atm'  then
            t_port_group := 'ADSL';
        else
            t_port_group := 'FTTX-Huawei-no-xpon';
        end if;

    elsif substr(NASPORTID,0,2)  = 'FF' then
        select SUBSTR(SUBSTR(SUBSTR(SUBSTR(t,instr(t,'/')+1),instr(SUBSTR(t,instr(t,'/')+1),'/')+1)
        ,instr(SUBSTR(SUBSTR(t,instr(t,'/')+1),instr(SUBSTR(t,instr(t,'/')+1),'/')+1),'/')+1),instr(SUBSTR(SUBSTR(SUBSTR(t,instr(t,'/')+1),instr(SUBSTR(t,instr(t,'/')+1),'/')+1)
        ,instr(SUBSTR(SUBSTR(t,instr(t,'/')+1),instr(SUBSTR(t,instr(t,'/')+1),'/')+1),'/')+1),'/')+1) into t_hf_port from
        (
            select SUBSTR(NASPORTID,instr(NASPORTID,'/')+1) as t from dual
        );
    
        if substr(t_hf_port,1,6) = 'FFtest'  then
            t_port_group := 'FTTX-TEST';
        else
            t_port_group := 'FTTX-Fiber Home';
        end if;
        
        
    elsif substr(NASPORTID,0,3)  = 'FBB' then    
        select substr(NASPORTID,instr(NASPORTID,'#O')+1,length(NASPORTID)) into t_hf_port from dual;
        if substr(t_hf_port,0,1) like 'O%'  then
            t_port_group := 'FTTX(AIS)';
        else
            t_port_group := 'FTTX(AIS)';
        end if;
    
    elsif substr(NASPORTID,0,3)  = 'OX_' then t_port_group := 'FTTX(AIS)'; -- จ.อำนาจเจริญ
    elsif substr(NASPORTID,0,3)  = 'OS_' then t_port_group := 'FTTX(AIS)';
    elsif substr(NASPORTID,0,3)  = 'OC_' then t_port_group := 'FTTX(AIS)';
    elsif substr(NASPORTID,0,3)  = 'ON_' then t_port_group := 'FTTX(AIS)';
    elsif substr(NASPORTID,0,2)  = 'ZF' then t_port_group := 'FTTX(AIS)';
    elsif substr(NASPORTID,0,3)  = 'OE_' then t_port_group := 'FTTX(AIS)';
    elsif substr(NASPORTID,0,3)  = 'OB_' then t_port_group := 'FTTX(AIS)';
    
        
    else
        --sub atm eth etc.. into t_b_port
        --select substr(substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)),0,instr(substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)),' ')-1)into t_b_port from dual;
        select substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)) into t_b_port from dual;
    
        if substr(t_b_port,0,3) = 'atm'  then
            if SUBSTR(t_b_port,length(t_b_port)-1) = '33' then
                t_port_group := 'ADSL';
            end if;
        elsif substr(t_b_port,0,3) = 'eth' then
            if SUBSTR(t_b_port,length(t_b_port)-1) = '33' then
                t_port_group := 'VDSL';
            else
                t_port_group := 'FTTX-vlan';
            end if;
        else
            t_port_group := 'Other-slot';
        end if;
        
    end if;  
        
    RETURN t_port_group;
    
END FN_GETGROUP_NASPORTID;
