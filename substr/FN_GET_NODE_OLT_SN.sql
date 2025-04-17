create or replace FUNCTION         FN_GET_NODE_OLT_SN
(
  NASPORTID IN VARCHAR2 
) RETURN VARCHAR2 AS 

t_hf_port varchar2(100);
t_b_port varchar2(64);
t_a_port varchar2(64);
t_port_group varchar2(64);

t_nas_port varchar2(64);
t_fbb_port VARCHAR2(100);


BEGIN

    if NASPORTID is null then
        t_port_group := '-';
    elsif substr(NASPORTID,0,2)  = 'HF' then
        select substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)) into t_hf_port from dual;
    
        if substr(t_hf_port,0,4) = 'xpon'  then
            select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':'),length(NASPORTID)),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':'),length(NASPORTID)), ' ')+1 ) into t_port_group from dual;

           -- t_port_group := 'FTTX-Huawei';
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
            
        elsif substr(t_hf_port,0,3)  = 'HWT' then
        select SUBSTR(NASPORTID,INSTR(NASPORTID,'/H')+1,length(NASPORTID)) into t_port_group from dual;
            
        elsif substr(t_hf_port,0,3)  = 'XPT' then
        select SUBSTR(NASPORTID,INSTR(NASPORTID,'/X')+1,length(NASPORTID)) into t_port_group from dual;
        
        elsif substr(t_hf_port,0,3)  = 'T3T' then
        select SUBSTR(NASPORTID,INSTR(NASPORTID,'/T')+1,length(NASPORTID)) into t_port_group from dual;
            
        elsif substr(t_hf_port,0,3)  = 'ZTE' then
        select SUBSTR(NASPORTID,INSTR(NASPORTID,'/Z')+1,length(NASPORTID)) into t_port_group from dual;
        
        else
        select SUBSTR(NASPORTID,INSTR(NASPORTID,'/F')+1,length(NASPORTID)) into t_port_group from dual;
            --t_port_group := 'FTTX-Fiber Home';
        end if;
        
    elsif substr(NASPORTID,0,3)  = 'FBB' then    
        select substr(NASPORTID,instr(NASPORTID,'#O')+1,length(NASPORTID)) into t_hf_port from dual;
        select substr(NASPORTID,instr(NASPORTID,'.33'),length(NASPORTID)) into t_fbb_port from dual;
        
        if substr(t_hf_port,0,1) like 'O%'  then
        select SUBSTR(SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1),1,INSTR(SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1), '#')-1) into t_port_group from dual;
            --t_port_group := 'FTTX-AIS';
        else
            if substr(t_fbb_port,0,4) like '.33.%'  then
                --select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, '#D')+1), 1, INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, '#D')+1), '.33.') - 1) into t_port_group from dual;
                t_port_group := '';
                
            else
                --select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, '#D')+1), 1, INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, '#D')+1), ':') - 1) into t_port_group from dual;
                t_port_group := '';
            end if;
        end if;
    
    elsif substr(NASPORTID,0,3)  = 'OX_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual;
    
    elsif substr(NASPORTID,0,3)  = 'OS_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual;
    
    elsif substr(NASPORTID,0,3)  = 'OC_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual;   
    
    elsif substr(NASPORTID,0,3)  = 'ON_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual; 
    
    elsif substr(NASPORTID,0,3)  = 'OB_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual;

    elsif substr(NASPORTID,0,3)  = 'OE_' then 
    select SUBSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')),INSTR(SUBSTR(NASPORTID,INSTR(NASPORTID, ':')), '/')+1) into t_port_group from dual;
    
    elsif substr(NASPORTID,0,2)  = 'ZF' then 
    select substr(NASPORTID, INSTR(NASPORTID, 'ZTE')) into t_port_group from dual;     
        
        
    else
        --sub atm eth etc.. into t_b_port
        --select substr(substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)),0,instr(substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)),' ')-1)into t_b_port from dual;
        select substr(NASPORTID,instr(NASPORTID,' ')+1,length(NASPORTID)) into t_b_port from dual;
    
        if substr(t_b_port,0,3) = 'atm'  then
            --select SUBSTR(NASPORTID, 1, INSTR(NASPORTID, ' ') - 1) || 
            --SUBSTR(SUBSTR(substr(NASPORTID,instr(NASPORTID,' ')),5,length(substr(NASPORTID,instr(NASPORTID,' ')))) ,1, INSTR(SUBSTR(substr(NASPORTID,instr(NASPORTID,' ')),5,length(substr(NASPORTID,instr(NASPORTID,' ')))) , ':') - 1) into t_port_group from dual;
            t_port_group := '';
            --if SUBSTR(t_b_port,length(t_b_port)-1) = '33' then
                --t_port_group := 'ADSL';
            --end if;
        elsif substr(t_b_port,0,3) = 'eth' then
            if SUBSTR(t_b_port,length(t_b_port)-1) = '33' then
                --select SUBSTR(NASPORTID, 1, INSTR(NASPORTID, ' ') - 1) || 
                --SUBSTR(SUBSTR(substr(NASPORTID,instr(NASPORTID,' ')),5,length(substr(NASPORTID,instr(NASPORTID,' ')))) ,1, INSTR(SUBSTR(substr(NASPORTID,instr(NASPORTID,' ')),5,length(substr(NASPORTID,instr(NASPORTID,' ')))) , ':') - 1) into t_port_group from dual;
                t_port_group := '';
            else
                t_port_group := '';
            end if;
        else
            t_port_group := 'Other-slot';
        end if;
        
    end if;  
        
    RETURN t_port_group;
    
END FN_GET_NODE_OLT_SN;
